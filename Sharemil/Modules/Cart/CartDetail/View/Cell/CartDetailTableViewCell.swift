//
//  CartDetailTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 23/06/2022.
//

import UIKit

class CartDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var options: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    
    var isEdit = false
    var index: Int?
    var menuItem: ChefMenuListModel?
    var didChangeQuantity: ((Int, Int?) -> ())?
    
    var item: CartItems? {
        didSet {
            itemName.text = item?.menuItem?.name
            quantityLabel.text = "\(item?.quantity ?? 0)"

            let opt = item?.options?.map({ a in
                var b = a.choices?.map({ m in
                    return ((m.price ?? 0)*Double(m.quantity ?? 0))
                })
                return b?.reduce(0, +) ?? 0
            })
            let itemOptions = opt?.reduce(0,+) ?? 0
            itemPrice.text = "$" + (((item?.menuItem?.price ?? 0) + itemOptions)*Double(item?.quantity ?? 0)).withDecimal(2)
            options.isHidden = item?.options?.map({$0.choices?.first?.name ?? ""}).joined(separator: ", ") == nil ||  item?.options?.map({$0.choices?.first?.name ?? ""}).joined(separator: ", ") == ""
            options.text = item?.options?.map({ m in
                return "\(m.title ?? ""): " + (m.choices?.map({ c in
                    return c.quantity == nil ? (c.name ?? "") : (c.price == 0.0 ? (c.name ?? "") : "\(c.name ?? "")(x\(c.quantity ?? 0))")
                }).joined(separator: " , ") ?? "")
            }).joined(separator: ", ")
            if let note = item?.note, note != "" {
                instructionLabel.isHidden = false
                instructionLabel.text = note
            }else {
                instructionLabel.isHidden = true
            }
        }
    }
    
    func setup() {
        self.plusBtn.isHidden = !isEdit
        self.minusBtn.isHidden = !isEdit
    }
    
  
    @IBAction func plusAction(_ sender: Any) {
        if (menuItem?.remainingItems ?? 0) > (Int(quantityLabel.text ?? "") ?? 0) {
            self.quantityLabel.text = "\((Int(quantityLabel.text ?? "") ?? 0) + 1)"
            self.didChangeQuantity?(Int(quantityLabel.text ?? "") ?? 0, index)
        } else if menuItem?.remainingItems == nil {
            self.quantityLabel.text = "\((Int(quantityLabel.text ?? "") ?? 0) + 1)"
            self.didChangeQuantity?(Int(quantityLabel.text ?? "") ?? 0, index)
        }
    }
    
    @IBAction func minusAction(_ sender: Any) {
        if !(Int(quantityLabel.text ?? "") == 0) {
            self.quantityLabel.text = "\((Int(quantityLabel.text ?? "") ?? 0) - 1)"
            self.didChangeQuantity?(Int(quantityLabel.text ?? "") ?? 0, index)
        }
    }
    
}
