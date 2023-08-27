//
//  ChefMenuOptionRadioTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 22/06/2022.
//

import UIKit
import MBRadioCheckboxButton

class ChefMenuOptionRadioTableViewCell: UITableViewCell, RadioButtonDelegate {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStack: UIStackView!
    @IBOutlet weak var optionPrice: UILabel!
    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var radioButton: RadioButton!
    
    var section: Int?
    var row: Int?
    var didSelect: ((ChoicesModel?, Int, Int) -> ())?
    var didUpdateQuantity: ((ChoicesModel?, Int, Int, Int) -> ())?
    
    var model: ChoicesModel? {
        didSet {
            self.optionName.text = model?.name
            self.optionPrice.text = model?.price == 0 ? "" : "$\(model?.price ?? 0)"
        }
    }
    

    
    func setup() {
        radioButton.delegate = self
    }
    
    @IBAction func minusAction(_ sender: Any) {
        if !(Int(quantityLabel.text ?? "") == 0) {
            self.quantityLabel.text = "\((Int(quantityLabel.text ?? "") ?? 0) - 1)"
            self.didUpdateQuantity?(model, section ?? 0, row ?? 0, (Int(quantityLabel.text ?? "") ?? 0))
        }
    }
    
    @IBAction func plusAction(_ sender: Any) {
        self.quantityLabel.text = "\((Int(quantityLabel.text ?? "") ?? 0) + 1)"
        self.didUpdateQuantity?(model, section ?? 0, row ?? 0, (Int(quantityLabel.text ?? "") ?? 0))
    }
    
    func radioButtonDidSelect(_ button: RadioButton) {
//        self.quantityLabel.text = "1"
        self.didSelect?(model, section ?? 0, row ?? 0)
        
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
//        self.quantityLabel.text = "1"
    }
    
}
