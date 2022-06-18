//
//  MyLocationViewController.swift
//  Sharemil
//
//  Created by lizan on 17/06/2022.
//

import UIKit
import GooglePlaces

class MyLocationViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableVoiew: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var searchConatiner: UIView!
    @IBOutlet weak var searchAddressField: UITextField!
    
    var viewModel: MyLocationViewModel!
    
    var locationName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        searchConatiner.isUserInteractionEnabled = true
        searchConatiner.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openAutoCOmplete)))
        setTableView()
    }
    
    func setTableView() {
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
    
    func setup() {
        searchConatiner.addBorder(.black)
        searchConatiner.rounded()
        shadow.setStandardBoldShadow()
        shadow.rounded()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func openAutoCOmplete() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
          UInt(GMSPlaceField.placeID.rawValue))
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
      }

}

extension MyLocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyLocationListTableViewCell") as! MyLocationListTableViewCell
        cell.locationName.text = self.viewModel.currentLocation
        cell.locationImage.image = UIImage.init(named: "send")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyLocationHeaderTableViewCell") as! MyLocationHeaderTableViewCell
        cell.headerTitle.text = "Nearby"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
}

extension MyLocationViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true)
    }
    
    
}
