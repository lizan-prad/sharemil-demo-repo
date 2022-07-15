//
//  OrderSummaryListTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 13/07/2022.
//

import UIKit

class OrderSummaryListTableViewCell: UITableViewCell {

    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var itemNamee: UILabel!
    
    var item: CartItems? {
        didSet {
            itemQuantity.text = "\(item?.quantity ?? 0)"
            itemNamee.text = item?.menuItem?.name
        }
    }
    
}
