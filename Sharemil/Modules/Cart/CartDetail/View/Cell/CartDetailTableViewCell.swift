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
    
    var isEdit = false
    var index: Int?
    
    var didChangeQuantity: ((Int, Int?) -> ())?
    
    var item: CartItems? {
        didSet {
            itemName.text = item?.menuItem?.name
            quantityLabel.text = "\(item?.quantity ?? 0)"
            itemPrice.text = "$" + ((item?.menuItem?.price ?? 0)*Double(item?.quantity ?? 0)).withDecimal(2)
            options.isHidden = item?.options?.map({$0.choices?.first ?? ""}).joined(separator: ", ") == nil ||  item?.options?.map({$0.choices?.first ?? ""}).joined(separator: ", ") == ""
            options.text = item?.options?.map({$0.choices?.first ?? ""}).joined(separator: ", ")
        }
    }
    
    func setup() {
        self.plusBtn.isHidden = !isEdit
        self.minusBtn.isHidden = !isEdit
    }
    
  
    @IBAction func plusAction(_ sender: Any) {
        self.quantityLabel.text = "\((Int(quantityLabel.text ?? "") ?? 0) + 1)"
        self.didChangeQuantity?(Int(quantityLabel.text ?? "") ?? 0, index)
    }
    
    @IBAction func minusAction(_ sender: Any) {
        if !(Int(quantityLabel.text ?? "") == 0) {
            self.quantityLabel.text = "\((Int(quantityLabel.text ?? "") ?? 0) - 1)"
            self.didChangeQuantity?(Int(quantityLabel.text ?? "") ?? 0, index)
        }
    }
    
}
