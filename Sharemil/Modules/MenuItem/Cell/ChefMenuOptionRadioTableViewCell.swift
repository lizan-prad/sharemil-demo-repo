//
//  ChefMenuOptionRadioTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 22/06/2022.
//

import UIKit
import MBRadioCheckboxButton

class ChefMenuOptionRadioTableViewCell: UITableViewCell, RadioButtonDelegate {
    
    

    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var radioButton: RadioButton!
    
    var section: Int?
    var didSelect: ((String, Int) -> ())?
    
    func setup() {
        radioButton.delegate = self
    }
    
    func radioButtonDidSelect(_ button: RadioButton) {
        self.didSelect?(optionName.text ?? "", section ?? 0)
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        
    }
    
}
