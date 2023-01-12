//
//  ChefMenuTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 19/06/2022.
//

import UIKit
import SDWebImage

class ChefMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var itemLeftView: UIView!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishDesc: UILabel!
    @IBOutlet weak var quantityContainer: UIView!
    @IBOutlet weak var dishPrice: UILabel!
    @IBOutlet weak var dishName: UILabel!
    
    var model: ChefMenuListModel? {
        didSet {
            quantityContainer.rounded()
            quantityContainer.addBorder(.black)
            dishImage.sd_setImage(with: URL.init(string: model?.imageUri ?? ""))
            
            self.itemLeftView.isHidden =  model?.remainingItems == nil || model?.remainingItems == 0
            
            dishDesc.text = model?.description
            dishName.text = model?.name
            dishPrice.text = "$" + (model?.price ?? 0).withDecimal(2)
            self.itemCount.text = "only \(model?.remainingItems ?? 0) left"
        }
    }
}
