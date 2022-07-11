//
//  MyLocationListTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 18/06/2022.
//

import UIKit
import CoreLocation

class MyLocationListTableViewCell: UITableViewCell {

    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationTitle: UILabel!
    
//    AIzaSyDSiFR_IXzPLoKoQnzDcPavcAGThhmW55M
    
    var model: MyLocationModel? {
        didSet {
            locationTitle.text = model?.name
            self.getAddress(LLocation.init(location: CLLocation.init(latitude: model?.latitude ?? 0, longitude: model?.longitude ?? 0)))
        }
    }
    
    private func getAddress(_ location: LLocation) {
        GoogleMapsServices.shared.getAddress(location) { name in
            self.locationName.text = name
        }
    }
}
