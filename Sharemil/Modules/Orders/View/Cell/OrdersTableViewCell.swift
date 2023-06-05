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
    @IBOutlet weak var pickUpBtn: UIButton!
    @IBOutlet weak var chefName: UILabel!
    
    var didSelectReorder: ((ChefListModel?) -> ())?
    var didPickUp: ((String) -> ())?
    var model: OrderModel? {
        didSet {
            self.businessName.text = model?.cart?.chef?.businessName
            self.orderImage.sd_setImage(with: URL.init(string: model?.cart?.chef?.mainImageUrl ?? ""))
            self.chefName.text = "\(model?.cart?.chef?.firsName ?? "") \(model?.cart?.chef?.lastName ?? "")"
            let count = (model?.cart?.cartItems?.map({$0.quantity ?? 0}).reduce(0,+) ?? 0)
            if (model?.deliverAddress != nil && model?.deliverAddress != "") {
                self.pickUpBtn.isHidden = true
            } else {
                self.pickUpBtn.isHidden = model?.status != "READY"
                
                self.reorderBtn.isHidden = model?.status != "COMPLETED"
            }
            self.model?.customerIsHere ?? false ? self.pickUpBtn.disable() : self.pickUpBtn.enable()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let time = formatter.date(from: model?.pickupTime ?? "")
            let orderDate = formatter.date(from: model?.createdAt ?? "")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "MMM dd"
            self.dateStatusLabel.text = "\(formatter.string(from: orderDate ?? Date())) · \(model?.status ?? "")"
            
            formatter.dateFormat = "hh:mm a"
            self.itemsPriceLabel.text = "\(count) \(count == 1 ? "item" : "items")" + (model?.status?.lowercased() == "completed" ? "" : (" · " + (formatter.string(from: time ?? Date()))))
        }
    }

    func setup() {
        reorderBtn.rounded()
        pickUpBtn.rounded()
    }
    
    @IBAction func reorderAction(_ sender: Any) {
        self.didSelectReorder?(self.model?.cart?.chef)
    }
    
    @IBAction func pickUpAction(_ sender: Any) {
        self.didPickUp?(model?.id ?? "")
    }
}
