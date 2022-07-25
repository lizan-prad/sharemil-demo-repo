//
//  PaymentOptionsListTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 25/07/2022.
//

import UIKit

class PaymentOptionsListTableViewCell: UITableViewCell {

    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    
    var model: PaymentMethods? {
        didSet {
            cardImage.image = UIImage.init(named: "visa")
            cardNumber.text = ((1...12).map({ _ in
                "*"
            }).joined() + (model?.stripePaymentMethod?.card?.last4 ?? "")).format("xxxx xxxx xxxx xxxx", oldString: ((1...12).map({ _ in
                "*"
            }).joined() + (model?.stripePaymentMethod?.card?.last4 ?? ""))) + " (\(model?.name ?? ""))"
        }
    }
}
