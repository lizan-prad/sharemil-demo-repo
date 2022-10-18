//
//  HelpIssueFoodListTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 06/10/2022.
//

import UIKit
import MBRadioCheckboxButton

class HelpIssueFoodListTableViewCell: UITableViewCell {

    @IBOutlet weak var issueLabel: UILabel!
    @IBOutlet weak var issueView: UIView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var checkBtn: CheckboxButton!
    
    var menuItem: IssueListStruct? {
        didSet {
            checkBtn.isOn = menuItem?.issue != nil
            self.issueView.isHidden = menuItem?.issue == nil
            self.issueLabel.text = menuItem?.issue?.description
            self.foodName.text = "x\(menuItem?.item?.quantity ?? 0) \(menuItem?.item?.menuItem?.name ?? "")"
        }
    }
    
}
