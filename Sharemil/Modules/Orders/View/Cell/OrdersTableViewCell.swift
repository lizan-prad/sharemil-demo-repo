//
//  OrdersTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 05/07/2022.
//

import UIKit
import SDWebImage

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var reorderBtn: UIButton!
    @IBOutlet weak var dateStatusLabel: UILabel!
    @IBOutlet weak var itemsPriceLabel: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var chefName: UILabel!
    
    var model: OrderModel? {
        didSet {
            self.orderImage.sd_setImage(with: URL.init(string: model?.cart?.chef?.mainImageUrl ?? ""))
            self.chefName.text = "\(model?.cart?.chef?.firsName ?? "") \(model?.cart?.chef?.lastName ?? "")"
            self.itemsPriceLabel.text = "\(2) items · $\(model?.total ?? 0)"
            self.dateStatusLabel.text = "Dec 16 · \(model?.status ?? "")"
        }
    }
    
    func setup() {
        reorderBtn.rounded()
    }
}
