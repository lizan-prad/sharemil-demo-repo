//
//  OrdersTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 05/07/2022.
//

import UIKit
import SDWebImage

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var reorderBtn: UIButton!
    @IBOutlet weak var dateStatusLabel: UILabel!
    @IBOutlet weak var itemsPriceLabel: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var chefName: UILabel!
    
    var didSelectReorder: ((ChefListModel?) -> ())?
    
    var model: OrderModel? {
        didSet {
            self.businessName.text = model?.cart?.chef?.businessName
            self.orderImage.sd_setImage(with: URL.init(string: model?.cart?.chef?.mainImageUrl ?? ""))
            self.chefName.text = "\(model?.cart?.chef?.firsName ?? "") \(model?.cart?.chef?.lastName ?? "")"
            let count = (model?.cart?.cartItems?.map({$0.quantity ?? 0}).reduce(0,+) ?? 0)
            self.itemsPriceLabel.text = "\(count) \(count == 1 ? "item" : "items")" + (model?.status?.lowercased() == "completed" ? "" : ("· $" + (model?.total ?? 0).withDecimal(2)))
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let orderDate = formatter.date(from: model?.createdAt ?? "")
            formatter.dateFormat = "MMM dd"
            self.dateStatusLabel.text = "\(formatter.string(from: orderDate ?? Date())) · \(model?.status ?? "")"
        }
    }

    func setup() {
        reorderBtn.rounded()
    }
    
    @IBAction func reorderAction(_ sender: Any) {
        self.didSelectReorder?(self.model?.cart?.chef)
    }
}
