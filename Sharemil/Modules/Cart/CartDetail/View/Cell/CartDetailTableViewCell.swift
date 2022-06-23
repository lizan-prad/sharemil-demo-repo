//
//  CartDetailTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 23/06/2022.
//

import UIKit

class CartDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var model: ChefMenuListModel? {
        didSet {
            itemName.text = model?.name
            itemPrice.text = "$\(model?.price ?? 0)"
        }
    }
    
}
