//
//  ChefMenuOptionCheckBoxTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 22/06/2022.
//

import UIKit
import MBRadioCheckboxButton

class ChefMenuOptionCheckBoxTableViewCell: UITableViewCell, CheckboxButtonDelegate {
    
    

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStack: UIStackView!
    @IBOutlet weak var optionPrice: UILabel!
    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var checkBox: CheckboxButton!
    
    var section: Int?
    
    var model: ChoicesModel? {
        didSet {
            self.optionName.text = model?.name
            self.optionPrice.text = model?.price == 0 ? "" : "$\(model?.price ?? 0)"
        }
    }
    
    var didSelect: ((ChoicesModel?, Int) -> ())?
    var didUpdateQuantity: ((ChoicesModel?, Int, Int) -> ())?
    var didDeSelect: ((String, Int) -> ())?
    
    func setup() {
        quantityStack.isHidden = true
        checkBox.delegate = self
    }
    
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        self.quantityLabel.text = "1"
        self.quantityStack.isHidden = model?.price == 0.0 ? true : false
        didSelect?(model,section ?? 0)
    }
    
    @IBAction func minusAction(_ sender: Any) {
        if !(Int(quantityLabel.text ?? "") == 0) {
            self.quantityLabel.text = "\((Int(quantityLabel.text ?? "") ?? 0) - 1)"
            self.didUpdateQuantity?(model, section ?? 0, (Int(quantityLabel.text ?? "") ?? 0))
        }
    }
    
    @IBAction func plusAction(_ sender: Any) {
        self.quantityLabel.text = "\((Int(quantityLabel.text ?? "") ?? 0) + 1)"
        self.didUpdateQuantity?(model, section ?? 0, (Int(quantityLabel.text ?? "") ?? 0))
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        self.quantityLabel.text = "1"
        self.quantityStack.isHidden = true
        didDeSelect?(optionName.text ?? "",section ?? 0)
    }
}
