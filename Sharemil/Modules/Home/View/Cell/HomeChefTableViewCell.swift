//
//  HomeChefTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 14/06/2022.
//

import UIKit
import SDWebImage

class HomeChefTableViewCell: UITableViewCell {

    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var chefDesc: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var chefImage: UIImageView!
    @IBOutlet weak var closedView: UIView!
    @IBOutlet weak var chefName: UILabel!
    
    var chef: ChefListModel? {
        didSet {
            closedView.rounded()
            businessName.text = chef?.businessName
            
            chefName.text = "\(chef?.firsName ?? "") \(chef?.lastName ?? "")"
            chefImage.sd_setImage(with: URL.init(string: chef?.mainImageUrl ?? ""))
            self.chefImage.alpha = chef?.isOpen == true ? 1 : 0.5
            closedView.isHidden = chef?.isOpen == true
            
            let formatter = DateFormatter()
            formatter.dateFormat = "eee"
            let now = formatter.string(from: Date()).lowercased()
            let hour = chef?.hours?.filter({($0.day?.lowercased() ?? "") == now.prefix(3)}).first
            formatter.dateFormat = "HH:mm:ss"
            let date = formatter.date(from: hour?.endTime ?? "")
            formatter.dateFormat = "hh:mm a"
            chefDesc.text = "\( date == nil ? "Closed" : "Open until \(formatter.string(from: date ?? Date()))") · \(chef?.distance?.withDecimal(2) ?? "") mi"
        }
    }
    
    func setup() {
        chefImage.addBorder(.black)
    }
}
