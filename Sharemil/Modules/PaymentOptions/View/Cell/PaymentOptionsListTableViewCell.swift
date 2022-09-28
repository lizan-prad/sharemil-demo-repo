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
    
    var didSelectMenuAction: ((String?) -> ())?
    
    var model: PaymentMethods? {
        didSet {
            cardImage.image = UIImage.init(named: model?.stripePaymentMethod?.card?.brand?.lowercased() ?? "")
            cardNumber.text =  (model?.stripePaymentMethod?.card?.last4?.getCardNumberFormatted() ?? "") + " (\(model?.name ?? ""))"
        }
    }

    @IBAction func menuAction(_ sender: Any) {
        self.didSelectMenuAction?(model?.id)
    }
}



extension String {
    func getCardNumberFormatted() -> String {
        return ((1...12).map({ _ in
            "*"
        }).joined() + self.format("xxxx xxxx xxxx xxxx", oldString: ((1...12).map({ _ in
            "*"
        }).joined() + (self))))
    }
}
