//
//  CheckoutMapTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 24/06/2022.
//

import UIKit
import GoogleMaps

class CheckoutMapTableViewCell: UITableViewCell {

    @IBOutlet weak var pickUpTime: UILabel!
    @IBOutlet weak var chefLocation: UILabel!
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    var chef: ChefListModel? {
        didSet {
            let marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(chef?.latitude ?? 0), longitude: Double(chef?.longitude ?? 0)))
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
