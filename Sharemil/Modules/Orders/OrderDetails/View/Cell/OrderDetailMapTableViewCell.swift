//
//  OrderDetailMapTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 13/07/2022.
//

import UIKit

class OrderDetailMapTableViewCell: UITableViewCell {

    @IBOutlet weak var chefImage: UIImageView!
    
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var orderDate: UILabel!

    
    var model: OrderModel? {
        didSet {
            let chef = model?.cart?.chef
            self.chefName.text = "\(chef?.firsName ?? "") \(chef?.lastName ?? "")"
            self.chefImage.sd_setImage(with: URL.init(string: model?.cart?.chef?.mainImageUrl ?? ""))
        }
    }
    
}
