//
//  MyLocationViewController.swift
//  Sharemil
//
//  Created by lizan on 17/06/2022.
//

import UIKit
import GooglePlaces

class MyLocationViewController: UIViewController, Storyboarded, GMSAutocompleteTableDataSourceDelegate {
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        let coordinator = SaveLocationCoordinator.init(navigationController: UINavigationController())
        coordinator.location = place
        self.place = place
        coordinator.didSaveLocation = {
            self.setTableView()
            self.searchAddressField.text = ""
            self.tableVoiew.reloadData()
        }
        self.present(coordinator.getMainView(), animated: true)
        
    }
    
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator on.
    
        // Reload table data.
        self.tableVoiew.reloadData()
      }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        
    }
    

    @IBOutlet weak var tableVoiew: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var searchConatiner: UIView!
    @IBOutlet weak var searchAddressField: UITextField!
    private var tableDataSource: GMSAutocompleteTableDataSource!
    
    var viewModel: MyLocationViewModel!
    
    var locationName: String?
    var place: GMSPlace?
    
    var didGetPlace: ((MyLocationModel?) -> ())?
    
    var locations: [MyLocationModel]? {
        didSet {
            self.tableVoiew.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setup()
        
        searchAddressField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        setTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getLocations()
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.success.bind { msg in
            self.showToastMsg(msg ?? "", state: .success, location: .bottom)
        }
        self.viewModel.locations.bind { model in
            self.locations = model
        }
    }
    
    @objc func textChanged(_ sender: UITextField) {
        if sender.text?.count == nil || sender.text?.count == 0 {
            self.setTableView()
            self.tableVoiew.reloadData()
        } else {
            self.setupMapTable()
            tableDataSource.sourceTextHasChanged(sender.text ?? "")
        }
    }
    
    private func setupMapTable() {
        tableVoiew.delegate = tableDataSource
        tableVoiew.dataSource = tableDataSource
    }
    
    private func setTableView() {
        tableDataSource = GMSAutocompleteTableDataSource()
        tableDataSource.delegate = self
        tableDataSource.tableCellSeparatorColor = .white
        tableDataSource.tableCellBackgroundColor = .white
        tableVoiew.dataSource = self
        tableVoiew.delegate = self
        
        tableVoiew.register(UINib.init(nibName: "MyLocationListTableViewCell", bundle: nil), forCellReuseIdentifier: "MyLocationListTableViewCell")
        tableVoiew.register(UINib.init(nibName: "MyLocationHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "MyLocationHeaderTableViewCell")
        if #available(iOS 15.0, *) {
            tableVoiew.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func setup() {
        searchConatiner.addBorder(.black)
        searchConatiner.rounded()
        shadow.setStandardBoldShadow()
        shadow.rounded()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
//    @objc func openAutoCOmplete() {
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//
//        // Specify the place data types to return.
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//          UInt(GMSPlaceField.placeID.rawValue))
//        autocompleteController.placeFields = fields
//
//        // Specify a filter.
//        let filter = GMSAutocompleteFilter()
//        filter.type = .address
//        autocompleteController.autocompleteFilter = filter
//        
//        // Display the autocomplete view controller.
//        present(autocompleteController, animated: true, completion: nil)
//      }

}

extension MyLocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + ((self.locations?.isEmpty ?? true) ? 0 : 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : (self.locations?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyLocationListTableViewCell") as! MyLocationListTableViewCell
        if indexPath.section == 1 {
            
            cell.model = self.locations?[indexPath.row]
        } else {
            cell.locationName.text = self.viewModel.currentLocation
            cell.locationImage.image = UIImage.init(named: "send")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.didGetPlace?(self.locations?[indexPath.row])
            self.dismiss(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyLocationHeaderTableViewCell") as! MyLocationHeaderTableViewCell
        cell.headerTitle.text = section == 0 ? "Nearby" : "Saved Locations"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            let alert = AlertServices.showAlertWithOkCancelAction(title: nil, message: "Do you wish to delete?") { _ in
                self.viewModel.deleteLocation(self.locations?[indexPath.row].id ?? "")
            }
            self.present(alert, animated: true)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActions
    }
}


