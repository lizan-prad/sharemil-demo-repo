//
//  OrdersTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 05/07/2022.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var reorderBtn: UIButton!
    @IBOutlet weak var dateStatusLabel: UILabel!
    @IBOutlet weak var itemsPriceLabel: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var chefName: UILabel!
    
    var model: OrderModel? {
        didSet {
            
        }
    }
    
    func setup() {
        reorderBtn.rounded()
    }
}
