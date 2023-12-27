//
//  OrderSummaryListTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 13/07/2022.
//

import UIKit

class OrderSummaryListTableViewCell: UITableViewCell {

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var itemNamee: UILabel!
    @IBOutlet weak var choices: UILabel!
    
    var item: CartItems? {
        didSet {
            choices.text = item?.options?.map({ m in
                return "\(m.title ?? ""): " + (m.choices?.map({ c in
                    return c.quantity == nil ? (c.name ?? "") : (c.price == 0.0 ? (c.name ?? "") : "\(c.name ?? "")(x\(c.quantity ?? 0))")
                }).joined(separator: " , ") ?? "")
            }).joined(separator: ", ")
            itemQuantity.text = "\(item?.quantity ?? 0)"
            itemNamee.text = item?.menuItem?.name
            let opt = item?.options?.map({ a in
                var b = a.choices?.map({ m in
                    return ((m.price ?? 0)*Double(m.quantity ?? 0))
                })
                return b?.reduce(0, +) ?? 0
            })
            let options = opt?.reduce(0,+) ?? 0
            noteLabel.text = "Note: \(item?.note ?? "")"
            priceLabel.text = "$" + (((item?.menuItem?.price ?? 0) + options)*Double(item?.quantity ?? 0)).withDecimal(2)
        }
    }
    
}
