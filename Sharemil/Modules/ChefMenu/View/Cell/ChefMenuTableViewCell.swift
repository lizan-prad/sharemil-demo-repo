//
//  ChefMenuTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 19/06/2022.
//

import UIKit
import SDWebImage

class ChefMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishDesc: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
    @IBOutlet weak var dishName: UILabel!
    
    var model: ChefMenuListModel? {
        didSet {
            dishImage.sd_setImage(with: URL.init(string: model?.imageUri ?? ""))
            dishDesc.text = model?.description
            dishName.text = model?.name
            dishPrice.text = "$\(model?.price ?? 0)"
        }
    }
}
