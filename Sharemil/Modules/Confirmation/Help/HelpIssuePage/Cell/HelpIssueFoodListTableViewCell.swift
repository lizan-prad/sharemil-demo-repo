//
//  HelpIssueFoodListTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 06/10/2022.
//

import UIKit
import MBRadioCheckboxButton

class HelpIssueFoodListTableViewCell: UITableViewCell {

    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var checkBtn: CheckboxButton!
    
    var menuItem: CartItems? {
        didSet {
            self.foodName.text = "x\(menuItem?.quantity ?? 0) \(menuItem?.menuItem?.name ?? "")"
        }
    }
    
    func setup() {
        
    }
}
