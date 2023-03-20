//
//  MapViewChefListCollectionViewCell.swift
//  Sharemil
//
//  Created by Lizan on 07/09/2022.
//

import UIKit
import SDWebImage

class MapViewChefListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var chefImage: UIImageView!
    @IBOutlet weak var openingHour: UILabel!
    @IBOutlet weak var chefName: UILabel!
    
    var model: ChefListModel? {
        didSet {
            chefImage.sd_setImage(with: URL.init(string: model?.mainImageUrl ?? ""))
            chefName.text = "\(model?.firsName ?? "") \(model?.lastName ?? "")"
            let formatter = DateFormatter()
            formatter.dateFormat = "eee"
            let now = formatter.string(from: Date()).lowercased()
            let hour = model?.hours?.filter({($0.day?.lowercased() ?? "") == now.prefix(3)}).first
            formatter.dateFormat = "HH:mm:ss"
            let date = formatter.date(from: hour?.startTime ?? "")
            formatter.dateFormat = "hh:mm a"
            self.openingHour.text = "Opens at \(formatter.string(from: date ?? Date()))"
        }
    }
    
    func setup() {
        self.container.addBorder(UIColor.lightGray.withAlphaComponent(0.4))
        self.container.addCornerRadius(16)
        self.layoutIfNeeded()
    }
}
