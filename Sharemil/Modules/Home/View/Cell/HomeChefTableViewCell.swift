//
//  HomeChefTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 14/06/2022.
//

import UIKit
import SDWebImage

class HomeChefTableViewCell: UITableViewCell {

    @IBOutlet weak var chefDesc: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var chefImage: UIImageView!
    @IBOutlet weak var chefName: UILabel!
    
    var chef: ChefListModel? {
        didSet {
            chefDesc.text = "\(chef?.address ?? "") · \(chef?.distance?.withDecimal(2) ?? "") mi"
            chefName.text = "\(chef?.firsName ?? "") \(chef?.lastName ?? "")"
            chefImage.sd_setImage(with: URL.init(string: chef?.mainImageUrl ?? ""))
        }
    }
    
    func setup() {
        chefImage.addBorder(.black)
    }
}
