//
//  OrderSummaryListTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 13/07/2022.
//

import UIKit

class OrderSummaryListTableViewCell: UITableViewCell {

    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var itemNamee: UILabel!
    @IBOutlet weak var choices: UILabel!
    
    var item: CartItems? {
        didSet {
            choices.text = item?.options?.map({$0.choices?.map({$0.name ?? ""}).joined(separator: ", ") ?? ""}).joined(separator: ", ")
            itemQuantity.text = "\(item?.quantity ?? 0)"
            itemNamee.text = item?.menuItem?.name
            let opt = item?.options?.map({$0.choices?.map({$0.price ?? 0}).reduce(0, +) ?? 0})
            let options = opt?.reduce(0,+) ?? 0
            priceLabel.text = "$" + (((item?.menuItem?.price ?? 0) + options)*Double(item?.quantity ?? 0)).withDecimal(2)
        }
    }
    
}
