//
//  OrderDetailMapTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 13/07/2022.
//

import UIKit
import GoogleMaps

class OrderDetailMapTableViewCell: UITableViewCell {

    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    var model: OrderModel? {
        didSet {
            let chef = model?.cart?.chef
            self.chefName.text = "\(chef?.firsName ?? "") \(chef?.lastName ?? "")"
            self.location.text = chef?.address
        }
    }
    
    var chef: ChefListModel? {
        didSet {
            let marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(chef?.latitude ?? 0) , longitude: Double(chef?.longitude ?? 0)))
            let arrow = UIImage.init(systemName: "arrowtriangle.right.fill")
            marker.icon = arrow?.withTintColor(.red, renderingMode: .alwaysTemplate)
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.isFlat = true
//            marker.rotation = angle
            marker.map = self.mapView
        }
    }
    
    var polylines: [GMSPath]? {
        didSet {
            polylines?.forEach({ path in
                let polyline = GMSPolyline(path: path)
                polyline.strokeColor = .red
                polyline.strokeWidth = 2.0
                polyline.map = self.mapView
            })
            
            
        }
    }
    
    @IBAction func directionAction(_ sender: Any) {
        
    }
    
    func setup() {
        let camera = GMSCameraPosition.camera(withLatitude: chef?.latitude ?? 0, longitude: chef?.longitude ?? 0, zoom: 13.5)
        mapView.camera = camera
        let locationMarker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: 34.06915277223104, longitude: -118.2931372947856))
        let locationImage = UIImage.init(named: "location")
        locationMarker.icon = locationImage?.withTintColor(.black)
        locationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        locationMarker.isFlat = true
//            marker.rotation = angle
//        locationMarker.map = self.mapView
    }
}
