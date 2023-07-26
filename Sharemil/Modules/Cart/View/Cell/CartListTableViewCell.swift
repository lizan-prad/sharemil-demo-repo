//
//  CartListTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 23/06/2022.
//

import UIKit
import SDWebImage

class CartListTableViewCell: UITableViewCell {

    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var cartImage: UIImageView!
    
    var cart: Cart? {
        didSet {
            cartImage.rounded()
            
            addressLabel.text = "Pickup at \(cart?.chef?.address ?? "")"
            let val = cart?.cartItems?.compactMap({ item in
                let options = item.options?.map({$0.choices?.first?.price ?? 0}).reduce(0,+) ?? 0
                return Double(item.quantity ?? 0)*((item.menuItem?.price ?? 0) + options)
            })
            let totalPrice = val?.reduce(0, +) ?? 0
            businessName.text = cart?.chef?.businessName
            let count = (cart?.cartItems?.map({$0.quantity ?? 0}).reduce(0,+) ?? 0)
            itemsLabel.text = "\(count) \(count == 1 ? "item" : "items") · $\(String(format:"%.2f", totalPrice))"
            chefName.text = "\(cart?.chef?.firsName ?? "") \(cart?.chef?.lastName ?? "")"
            cartImage.sd_setImage(with: URL.init(string: cart?.chef?.mainImageUrl ?? ""))
        }
    }
}

