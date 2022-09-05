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

var loc: LLocation?
var isFirst = true
class HomeViewController: UIViewController {

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
    
    var viewModel: HomeViewModel!
    var address: String?
    var mapV: GMSMapView!
    var currentLocation: LLocation? {
        didSet {
            loc = currentLocation
            let camera = GMSCameraPosition.camera(withLatitude: loc?.location?.coordinate.latitude ?? 0, longitude: loc?.location?.coordinate.longitude ?? 0, zoom: 16)
            let mapID = GMSMapID(identifier: "3591bb18c5c077ef")
            mapV = GMSMapView.init(frame: mapView.bounds, mapID: mapID, camera: camera)
            mapView.addSubview(mapV)
            viewModel.getCurrentAddress(currentLocation ?? LLocation.init(location: nil))
            if isFirst {
                self.showProgressHud()
                Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { token, error in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        UserDefaults.standard.set(token, forKey: StringConstants.userIDToken)
                        self.viewModel.fetchChefBy(location: self.currentLocation!, name: "")
                        isFirst = false
                    }
                })
            } else {
                viewModel.fetchChefBy(location: currentLocation!, name: "")
            }
        }
    }
    
    var chefs: [ChefListModel]? {
        didSet {
            self.filtered = chefs
        }
    }
    
    var filtered: [ChefListModel]? {
        didSet {
            filtered?.forEach({ m in
                let marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(m.latitude ?? 0), longitude: Double(m.longitude ?? 0)))
                let arrow = UIImage.init(named: "circle-marker")?.withTintColor(UIColor.init(hex: "DA3143"))
                marker.icon = arrow?.withTintColor(.red, renderingMode: .alwaysTemplate)
                marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                marker.isFlat = true
                marker.title = m.firsName
     
    //            marker.rotation = angle
                marker.map = self.mapV
            })
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
        setup()
        setTableView()
        setCollectionView()
        self.viewModel = HomeViewModel()
        self.setupLocationManager()
        bindViewModel()
        searchField.addTarget(self, action: #selector(searchAction(_:)), for: .editingChanged)
        self.viewModel.fetchUserProfile()
    }
    
    func setupLocationManager() {
        LocationManager.shared.locationManager?.requestAlwaysAuthorization()
        LocationManager.shared.locationManager?.startUpdatingLocation()
        LocationManager.shared.delegate = self
    }
    
    @objc func searchAction(_ sender: UITextField) {
        self.viewModel.fetchChefBy(location: LLocation.init(location: nil), name: sender.text ?? "")
    }
    
    private func setup() {
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
        locationStack.isUserInteractionEnabled = true
        locationStack.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openLocationView)))
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
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.success.bind { models in
            self.chefs = models
        }
        self.viewModel.cusines.bind { models in
            self.cusines = models
        }
        
        self.viewModel.user.bind { models in
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
        return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nav = self.navigationController else {return}
        let coordinator = ChefMenuCoordinator.init(navigationController: nav)
        coordinator.chef = self.filtered?[indexPath.row]
        coordinator.start()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cusines?.count ?? 0) + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        if indexPath.row == 0 {
            self.filtered = self.chefs
            return
        }
        self.selectedCusine = self.cusines?[indexPath.row - 1]
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 86, height: 85)
    }
}
