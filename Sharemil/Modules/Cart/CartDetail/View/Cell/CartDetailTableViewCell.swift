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
    
    var item: CartItems? {
        didSet {
            itemName.text = item?.menuItem?.name
            quantityLabel.text = "\(item?.quantity ?? 0)"
            itemPrice.text = "$\((item?.menuItem?.price ?? 0)*Double(item?.quantity ?? 0))"
        }
    }
    
  
    
}
