//
//  CheckoutMapTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 24/06/2022.
//

import UIKit
import GoogleMaps

class CheckoutMapTableViewCell: UITableViewCell {

    
    @IBOutlet weak var pickUpLabel: UILabel!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var scheduleDateField: UITextField!
    @IBOutlet weak var scheduleContainer: UIView!
    @IBOutlet weak var standardContainer: UIView!
    
    @IBOutlet weak var chefLocation: UILabel!
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    var selectedDate: Date?
    var didSelectMainDate: ((Date?) -> ())?
    var didSelectTime: ((String) -> ())?
    
    var chef: ChefListModel? {
        didSet {
            businessName.text = chef?.businessName
            chefName.text = "\(chef?.firsName ?? "") \(chef?.lastName ?? "")"
            chefLocation.text = "\(chef?.address ?? ""), \(chef?.city ?? "") \(chef?.postalCode ?? ""), \(chef?.state ?? "")"
            let marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(chef?.latitude ?? 0), longitude: Double(chef?.longitude ?? 0)))
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.isFlat = true
            marker.icon = UIImage.init(named: "end")?.withTintColor(.green, renderingMode: .alwaysTemplate)
//            marker.rotation = angle
            marker.map = self.mapView
            self.pickUpLabel.text = "Pick Up (\(chef?.preparationTime ?? ""))"
        }
    }
    
    var polylines: [GMSPath]? {
        didSet {
            self.setup()
            polylines?.forEach({ path in
                let polyline = GMSPolyline(path: path)
                polyline.strokeColor = .red
                polyline.strokeWidth = 2.0
                polyline.map = self.mapView
            })
            
       
        }
    }
    
    @objc private func standardAction() {
        didSelectTime?("standard")
    }
  
    @objc private func didSelectDate(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: sender.date)
        let remaining = (minutes%15) == 0 ? 0 : (15 - (minutes%15))
        if remaining == 0 {
            let date = sender.date.addingTimeInterval(Double(remaining*60))
            formatter.dateFormat = "eee, MMM dd HH:mm a"
            self.selectedDate = sender.date
            self.scheduleDateField.text = formatter.string(from: date)
        } else {
            let date = Date().addingTimeInterval(Double(remaining*60))
            formatter.dateFormat = "eee, MMM dd HH:mm a"
            self.selectedDate = sender.date
            self.scheduleDateField.text = formatter.string(from: date)
        }
        
    }

    @objc private func doneButtonClicked(_ sender: Any) {
        didSelectMainDate?(self.selectedDate)
        didSelectTime?(self.scheduleDateField.text ?? "")
        
    }
    
    func setup() {
        
        standardContainer.isUserInteractionEnabled = true
        
        standardContainer.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(standardAction)))
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .dateAndTime
        picker.minuteInterval = 15
        picker.minimumDate = Date()
        
        picker.maximumDate = Date().addingTimeInterval(604800)
        picker.addTarget(self, action: #selector(didSelectDate(_:)), for: .valueChanged)
        scheduleDateField.inputView = picker
        scheduleDateField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        let cor = polylines?.first?.coordinate(at: (polylines?.first?.count() ?? 0)/2)
        
        let coordinate0 = CLLocation(latitude: chef?.latitude ?? 0, longitude: chef?.longitude ?? 0)
        let coordinate1 = CLLocation(latitude: loc?.location?.coordinate.latitude ?? 0, longitude: loc?.location?.coordinate.longitude ?? 0)
        let distanceInMeters = coordinate0.distance(from: coordinate1)*0.001
        let camera = GMSCameraPosition.camera(withLatitude: cor?.latitude ?? 0, longitude: cor?.longitude ?? 0, zoom: Float(14.5 - Double(distanceInMeters )/2))
        mapView.camera = camera
        let locationMarker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: loc?.location?.coordinate.latitude ?? 0, longitude: loc?.location?.coordinate.longitude ?? 0))
        locationMarker.groundAnchor = CGPoint(x: 0.5, y: 1)
        locationMarker.isFlat = true
        locationMarker.icon = UIImage.init(named: "start")
//            marker.rotation = angle
        locationMarker.map = self.mapView
    }
}
