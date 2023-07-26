//
//  ChefMenuOptionRadioTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 22/06/2022.
//

import UIKit
import MBRadioCheckboxButton

class ChefMenuOptionRadioTableViewCell: UITableViewCell, RadioButtonDelegate {

    @IBOutlet weak var optionPrice: UILabel!
    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var radioButton: RadioButton!
    
    var section: Int?
    var didSelect: ((ChoicesModel?, Int) -> ())?
    
    var model: ChoicesModel? {
        didSet {
            self.optionName.text = model?.name
            self.optionPrice.text = model?.price == 0 ? "" : "$\(model?.price ?? 0)"
        }
    }
    
    
    func setup() {
        radioButton.delegate = self
    }
    
    func radioButtonDidSelect(_ button: RadioButton) {
        self.didSelect?(model, section ?? 0)
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        
    }
    
}
