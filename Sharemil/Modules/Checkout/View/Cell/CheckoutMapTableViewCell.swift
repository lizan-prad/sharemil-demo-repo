//
//  CheckoutMapTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 24/06/2022.
//

import UIKit
import GoogleMaps

class CheckoutMapTableViewCell: UITableViewCell {

    
    @IBOutlet weak var timeErrorLabel: UILabel!
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
    var didProcessDateError: ((String) -> ())?
    var didTapSchedule: (([HoursModel]?) -> ())?
    
    var chef: ChefListModel? {
        didSet {
            
            standardContainer.isHidden = chef?.isOpen == false
            
            self.timeErrorLabel.text = ""
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
        let formatter1 = DateFormatter()
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: sender.date)
        let remaining = (minutes%15) == 0 ? 0 : (15 - (minutes%15))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "eee"
        let now = formatter.string(from: Date()).lowercased()
        let hour = chef?.hours?.filter({($0.day?.lowercased() ?? "") == now.prefix(3)}).first
        formatter.dateFormat = "HH:mm:ss"
        let nowStrDate = formatter.string(from: sender.date)
        let nowDate = formatter.date(from: nowStrDate) ?? Date()
        let date = formatter.date(from: hour?.endTime ?? "") ?? Date()
        let sdate = formatter.date(from: hour?.startTime ?? "") ?? Date()
        if (sdate ... date).contains(nowDate) {
            self.timeErrorLabel.text = ""
            if remaining == 0 {
                let date = sender.date.addingTimeInterval(Double(remaining*60))
                formatter1.dateFormat = "eee, MMM dd HH:mm a"
                self.selectedDate = date
                self.scheduleDateField.text = formatter1.string(from: date)
            } else {
                let date = Date().addingTimeInterval(Double(remaining*60))
                formatter1.dateFormat = "eee, MMM dd HH:mm a"
                self.selectedDate = date
                self.scheduleDateField.text = formatter1.string(from: date)
            }
        } else {
            self.timeErrorLabel.text = "Time out of bound. (\(hour?.startTime ?? "") - \(hour?.endTime ?? ""))"
        }
    }

    @objc private func doneButtonClicked(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "eee"
        let now = formatter.string(from: Date()).lowercased()
        didSelectMainDate?(self.selectedDate)
        didSelectTime?(self.scheduleDateField.text ?? "")
        let hour = chef?.hours?.filter({($0.day?.lowercased() ?? "") == now.prefix(3)}).first
        self.didProcessDateError?("The operating hour of restaurant is \(hour?.startTime ?? "") till \(hour?.endTime ?? "")")
    }
    
    func setup() {
        
        standardContainer.isUserInteractionEnabled = true
        
        standardContainer.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(standardAction)))
        scheduleContainer.isUserInteractionEnabled = true
        scheduleContainer.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openSchefuleView)))
        let formatter = DateFormatter()
        formatter.dateFormat = "eee"
        let now = formatter.string(from: Date()).lowercased()
        let hour = chef?.hours?.filter({($0.day?.lowercased() ?? "") == now.prefix(3)}).first
        formatter.dateFormat = "HH:mm:ss"
        let date = formatter.date(from: hour?.endTime ?? "") ?? Date()
        let sdate = formatter.date(from: hour?.startTime ?? "") ?? Date()
        
        let nowDateStr = formatter.string(from: Date())
        let nowDate = formatter.date(from: nowDateStr) ?? Date()
        let calendar = Calendar.current
        let d = calendar.dateComponents([.hour,.minute], from: nowDate, to: date)
        var h = (d.hour ?? 0)*60*60
        var m = (d.minute ?? 0)*60
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .dateAndTime
        picker.minuteInterval = 15
        picker.minimumDate = Date()
        picker.maximumDate = Date().addingTimeInterval(Double(h+m))
        picker.addTarget(self, action: #selector(didSelectDate(_:)), for: .valueChanged)
//        scheduleDateField.inputView = picker
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
    
    @objc func openSchefuleView() {
        self.didTapSchedule?(self.chef?.hours)
    }
}
