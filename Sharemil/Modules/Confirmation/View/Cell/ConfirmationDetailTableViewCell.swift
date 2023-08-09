//
//  ConfirmationDetailTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 26/07/2022.
//

import UIKit
import GoogleMaps

class ConfirmationDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    var didTapDirection: (() -> ())?
    
    var model: OrderModel? {
        didSet {
            let chef = model?.cart?.chef
            self.chefName.text = "\(chef?.firsName ?? "") \(chef?.lastName ?? "")"
            self.location.text = chef?.address
            self.note.text = model?.deliverAddress
        }
    }
    
    var chef: ChefListModel? {
        didSet {
            let marker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: Double(chef?.latitude ?? 0), longitude: Double(chef?.longitude ?? 0)))
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.isFlat = true
            marker.icon = UIImage.init(named: "open_restaurant")?.withTintColor(.green, renderingMode: .alwaysTemplate)
//            marker.rotation = angle
            marker.map = self.mapView
        }
    }
    
    var polylines: [GMSPath]? {
        didSet {
            setup()
            polylines?.forEach({ path in
                let polyline = GMSPolyline(path: path)
                polyline.strokeColor = .red
                polyline.strokeWidth = 2.0
                polyline.map = self.mapView
            })
            
            
        }
    }
    
    @IBAction func directionAction(_ sender: Any) {
        self.didTapDirection?()
    }
    
    func setup() {
        let cor = polylines?.first?.coordinate(at: (polylines?.first?.count() ?? 0)/2)
        let camera = GMSCameraPosition.camera(withLatitude: cor?.latitude ?? 0, longitude: cor?.longitude ?? 0, zoom: 13.5)
        mapView.camera = camera
        let locationMarker = GMSMarker.init(position: CLLocationCoordinate2D.init(latitude: loc?.location?.coordinate.latitude ?? 0, longitude: loc?.location?.coordinate.longitude ?? 0))
        locationMarker.groundAnchor = CGPoint(x: 0.5, y: 1)
        locationMarker.isFlat = true
        locationMarker.icon = UIImage.init(named: "start")
        locationMarker.map = self.mapView
//            marker.rotation = angle
//        locationMarker.map = self.mapView
    }
}
