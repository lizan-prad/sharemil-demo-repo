//
//  HomeViewController.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit
import GooglePlaces
import CoreLocation
import FirebaseAuth
import GoogleMaps
import Mixpanel
import OneSignal

var loc: LLocation?
var isFirst = true

class HomeViewController: UIViewController, GMSMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var locationBackView: UIView!
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var mapCollectionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapCollectionView: UICollectionView!
    @IBOutlet weak var searchBack: UIView!
    @IBOutlet weak var mapHeight: NSLayoutConstraint!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var locationStack: UIStackView!
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    
    let refreshControl = UIRefreshControl()
    
    var orderId: String?
    var viewModel: HomeViewModel!
    var address: String?
    var mapV: GMSMapView!
    var currentLocation: LLocation? {
        didSet {
            loc = currentLocation
            let camera = GMSCameraPosition.camera(withLatitude: loc?.location?.coordinate.latitude ?? 0, longitude: loc?.location?.coordinate.longitude ?? 0, zoom: 16)
            let mapID = GMSMapID(identifier: "3591bb18c5c077ef")
            mapV = GMSMapView.init(frame: mapView.bounds, mapID: mapID, camera: camera)
            mapV.delegate = self
            mapView.addSubview(mapV)
            if self.mapHeight.constant != self.view.frame.height {
                self.initialExpanded()
            }
            viewModel.getCurrentAddress(currentLocation ?? LLocation.init(location: nil))
            self.start()
            if orderId != nil {
                self.openOrderDetails()
            }
        }
    }
    
    var user: UserModel? {
        didSet {
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            OneSignal.setExternalUserId(user?.id ?? "") { data in
                print(data)
            }
            Mixpanel.mainInstance().identify(distinctId: user?.id ?? "") {
                Mixpanel.mainInstance().people.set(properties: [ "$distinct_id": self.user?.id ?? "", "$name": "\(self.user?.firstName ?? "") \(self.user?.lastName ?? "")", "$email": self.user?.email ?? "", "$avatar" : self.user?.profileImage ?? "", "$phone" : self.user?.phoneNumber ?? "", "Environment": UserDefaults.standard.string(forKey: "ENV") == "D" ? "Stage" : "Production"])
            }
            Mixpanel.mainInstance().people.setOnce(properties: [ "$distinct_id": self.user?.id ?? "", "$name": "\(self.user?.firstName ?? "") \(self.user?.lastName ?? "")", "$email": self.user?.email ?? "", "$avatar" : self.user?.profileImage ?? "", "$phone" : self.user?.phoneNumber ?? "", "Environment": UserDefaults.standard.string(forKey: "ENV") == "D" ? "Stage" : "Production"])
        }
    }
    
    var chefs: [ChefListModel]? {
        didSet {
            self.filtered = chefs?.sorted(by: { a, b in
                return a.isOpen == true
            })
        }
    }
    
    private func start() {
        if UserDefaults.standard.string(forKey: StringConstants.userIDToken) != StringConstants.staticToken {
            self.showProgressHud()
            Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { token, error in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    UserDefaults.standard.set(token, forKey: StringConstants.userIDToken)
                    self.viewModel.fetchUserProfile()
                    self.viewModel.fetchChefBy(location: self.currentLocation!, name: "")
                }
            })
        } else {
            self.viewModel.fetchChefBy(location: self.currentLocation!, name: "")
        }
    }
    
    var filtered: [ChefListModel]? {
        didSet {
            filtered?.forEach({ m in
                let marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(m.latitude ?? 0), longitude: Double(m.longitude ?? 0)))
                let arrow = UIImage.init(named: m.isOpen == true ? "open_restaurant" : "circle-marker")?.withTintColor(UIColor.init(hex: "DA3143"))
                marker.icon = arrow?.withTintColor(.red, renderingMode: .alwaysTemplate)
                marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                marker.isFlat = true
                marker.title = m.firsName
                
    //            marker.rotation = angle
                marker.map = self.mapV
            })
            mapCollectionView.reloadData()
            tableView.reloadData()
        }
    }
    
    var selectedCusine: CusineListModel? {
        didSet {
            self.filtered = chefs?.filter({$0.cuisineId == selectedCusine?.id})
        }
    }
    
    var cusines: [CusineListModel]? {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderId = order_id
        setup()
        setTableView()
        setCollectionView()
        setMapCollectionView()
        self.viewModel = HomeViewModel()
        self.setupLocationManager()
        bindViewModel()
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(searchAction(_:)), for: .editingChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchField.resignFirstResponder()
        return true
    }
    
    private func openOrderDetails() {
        let coordinator = ConfirmationCoordinator.init(navigationController: UINavigationController())
        coordinator.orderId = self.orderId
        coordinator.location = self.currentLocation
        self.present(coordinator.getMainView(), animated: true)
    }
    
    private func setupLocationManager() {
        LocationManager.shared.locationManager?.requestAlwaysAuthorization()
        LocationManager.shared.locationManager?.startUpdatingLocation()
        LocationManager.shared.delegate = self
    }
    
    @objc func searchAction(_ sender: UITextField) {
        self.viewModel.fetchChefBy(location: loc ?? LLocation.init(location: nil), name: sender.text?.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
    
    private func setup() {
        self.listBtn.setStandardShadow()
        self.listBtn.rounded()
        self.mapHeight.constant = 90
        searchContainer.addBorder(.black)
        searchContainer.rounded()
        shadow.setStandardBoldShadow()
        shadow.rounded()
        setupLocationView()
        NotificationCenter.default.addObserver(self, selector: #selector(didGetCheckoutEvent(_:)), name: Notification.Name.init(rawValue: "CHECK"), object: nil)
        
        container.isUserInteractionEnabled = true
        let swipeGestureDown = UISwipeGestureRecognizer.init(target: self, action: #selector(expandMap))
        swipeGestureDown.direction = .down
        self.container.addGestureRecognizer(swipeGestureDown)
        
        let swipeGestureUp = UISwipeGestureRecognizer.init(target: self, action: #selector(contractMap))
        swipeGestureUp.direction = .up
        self.container.addGestureRecognizer(swipeGestureUp)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        UIView.animate(withDuration: 0.4) {
            self.mapHeight.constant = self.view.frame.height
            self.mapCollectionTopConstraint.constant = -380
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.filtered?.enumerated().forEach({ m in
                if m.element.firsName == marker.title {
                    self.mapCollectionView.scrollToItem(at: IndexPath.init(row: m.offset, section: 0), at: .centeredHorizontally, animated: true)
                }
            })
            self.mapV.frame = self.mapView.bounds
        }
        return true
    }
    
    @IBAction func listAction(_ sender: Any) {
        UIView.animate(withDuration: 0.4) {
            self.mapHeight.constant = self.view.frame.height/2
            self.mapCollectionTopConstraint.constant = 80
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.mapV.frame = self.mapView.bounds
        }
    }
    
    @objc private func contractMap() {
        UIView.animate(withDuration: 0.4) {
            if self.mapHeight.constant == self.view.frame.height - 240 {
                self.mapHeight.constant = self.view.frame.height/2
            } else {
                self.searchBack.backgroundColor = .systemBackground
                self.mapHeight.constant = 90
                self.container.addBorder(UIColor.gray.withAlphaComponent(0))
                self.container.addCornerRadius(0)
            }
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.mapV.frame = self.mapView.bounds
        }
        
    }
    
    func initialExpanded() {
        UIView.animate(withDuration: 0.4) {
            self.searchBack.backgroundColor = .clear
            self.mapHeight.constant = self.view.frame.height/2
            
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.container.addBorder(UIColor.gray.withAlphaComponent(0.3))
            self.container.addCornerRadius(20)
            self.mapV.frame = self.mapView.bounds
        }
    }
    
    
    @objc private func expandMap() {
        UIView.animate(withDuration: 0.4) {
            self.searchBack.backgroundColor = .clear
            if self.mapHeight.constant == self.view.frame.height/2 {
                self.mapHeight.constant = self.view.frame.height - 240
            } else {
                self.mapHeight.constant = self.view.frame.height/2
            }
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.container.addBorder(UIColor.gray.withAlphaComponent(0.3))
            self.container.addCornerRadius(20)
            self.mapV.frame = self.mapView.bounds
        }
        
    }
    
    @objc func didGetCheckoutEvent(_ sender: Notification) {
        let coordinator = ConfirmationCoordinator.init(navigationController: UINavigationController())
        coordinator.orderId = sender.object as? String
        coordinator.location = self.currentLocation
        self.present(coordinator.getMainView(), animated: true)
    }
    
    private func setupLocationView() {
        locationBackView.rounded()
        locationBackView.isUserInteractionEnabled = true
        locationBackView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openLocationView)))
    }
    
    @objc func openLocationView() {
        let vc = MyLocationCoordinator.init(navigationController: self.navigationController!)
        vc.locationName = self.address
        vc.didSelectPlace = { place in
            self.currentLocation = LLocation.init(location: CLLocation.init(latitude: place?.latitude ?? 0, longitude: place?.longitude ?? 0))
            
        }
        self.present(vc.getMainView(), animated: true)
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib.init(nibName: "HomeChefTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeChefTableViewCell")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
          refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        guard let currentLoc = self.currentLocation else { return }
        self.viewModel.fetchChefBy(location: currentLoc, name: "")
    }
    
    private func setMapCollectionView() {
        mapCollectionView.dataSource = self
        mapCollectionView.delegate = self
        
        mapCollectionView.register(UINib.init(nibName: "MapViewChefListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MapViewChefListCollectionViewCell")
    }
    
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib.init(nibName: "HomeCusinesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCusinesCollectionViewCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.refresh.bind { msg in
            self.refreshControl.endRefreshing()
            self.start()
        }
        self.viewModel.error.bind { msg in
            self.refreshControl.endRefreshing()
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.success.bind { models in
            self.refreshControl.endRefreshing()
            self.chefs = models
        }
        self.viewModel.cusines.bind { models in
            self.refreshControl.endRefreshing()
            self.cusines = models
        }
        
        self.viewModel.user.bind { models in
            self.user = models
            UserDefaults.standard.set(models?.id ?? "", forKey: "UID")
        }
        
        self.viewModel.address.bind { address in
            self.address = address
            self.addressLabel.text = address?.components(separatedBy: ",").first
        }
    }
}

extension HomeViewController: LocationManagerDelegate {
    
    func locationManager(_ manager: LocationManager, needsToPresentAlertController alert: UIAlertController) {
        
    }
    
    func didAuthorizeAccess(_ manager: LocationManager) {
        
    }
    
    
    func didUpdateLocation(_ manager: LocationManager, currentLocation location: LLocation?) {
        UserDefaults.standard.set("\(location?.location?.coordinate.latitude ?? 0) \(location?.location?.coordinate.longitude ?? 0)", forKey: "CURLOC")
        self.currentLocation = location
        LocationManager.shared.locationManager?.stopUpdatingLocation()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeChefTableViewCell") as! HomeChefTableViewCell
        cell.setup()
        cell.chef = self.filtered?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 236
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        Mixpanel.mainInstance().track(event: "Chef selected", properties: [
            "chef_id": self.filtered?[indexPath.row].id ?? "",
            "user_location": "\(loc?.location?.coordinate.latitude ?? 0) , \(loc?.location?.coordinate.longitude ?? 0)",
            "address": self.address ?? "",
            "chef": "\(self.filtered?[indexPath.row].firsName ?? "") \(self.filtered?[indexPath.row].lastName ?? "")",
            "app_version": appVersion ?? ""
            ])
        guard let nav = self.navigationController else {return}
        let coordinator = ChefMenuCoordinator.init(navigationController: nav)
        coordinator.chef = self.filtered?[indexPath.row]
        coordinator.cusine = cusines?.filter({$0.id == self.filtered?[indexPath.row].cuisineId}).first
        coordinator.start()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mapCollectionView {
            return filtered?.count ?? 0
        }
        return (cusines?.count ?? 0) + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mapCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapViewChefListCollectionViewCell", for: indexPath) as! MapViewChefListCollectionViewCell
            cell.setup()
            cell.model = filtered?[indexPath.row]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCusinesCollectionViewCell", for: indexPath) as! HomeCusinesCollectionViewCell
        if indexPath.row == 0 {
            cell.cusineLabel.text = "All"
            cell.cusinesImage.image = UIImage.init(named: "all-cuisine")
        } else {
            cell.model = self.cusines?[indexPath.row - 1]
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if collectionView == mapCollectionView {
            guard let nav = self.navigationController else {return}
            let coordinator = ChefMenuCoordinator.init(navigationController: nav)
            coordinator.cusine = cusines?.filter({$0.id == self.filtered?[indexPath.row].cuisineId}).first
            coordinator.chef = self.filtered?[indexPath.row]
            coordinator.start()
        } else {
            if indexPath.row == 0 {
                self.filtered = self.chefs
                return
            }
            self.selectedCusine = self.cusines?[indexPath.row - 1]
            
            Mixpanel.mainInstance().track(event: "Cuisine selected", properties: [
                "cuisine_id": self.selectedCusine?.id ?? "",
                "user_location": "\(loc?.location?.coordinate.latitude ?? 0) , \(loc?.location?.coordinate.longitude ?? 0)",
                "address": self.address ?? "",
                "cuisine": self.selectedCusine?.name ?? ""
                ])
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mapCollectionView {
            return CGSize.init(width: mapCollectionView.frame.width - 48, height: 250)
        }
        return CGSize.init(width: 86, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == mapCollectionView {
            return 0
        } else {
            return 10
        }
    }
}
