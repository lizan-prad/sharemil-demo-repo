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
            let totalPrice = (cart?.cartItems?.compactMap({Double($0.quantity ?? 0)*($0.menuItem?.price ?? 0)}).reduce(0, +) ?? 0)
            businessName.text = cart?.chef?.businessName
            itemsLabel.text = "\(cart?.cartItems?.count ?? 0) items · $\(String(format:"%.2f", totalPrice))"
            chefName.text = "\(cart?.chef?.firsName ?? "") \(cart?.chef?.lastName ?? "")"
            cartImage.sd_setImage(with: URL.init(string: cart?.chef?.mainImageUrl ?? ""))
        }
    }
}

