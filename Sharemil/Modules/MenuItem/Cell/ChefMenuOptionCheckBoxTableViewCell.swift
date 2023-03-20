//
//  ChefMenuOptionCheckBoxTableViewCell.swift
//  Sharemil
//
//  Created by lizan on 22/06/2022.
//

import UIKit
import MBRadioCheckboxButton

class ChefMenuOptionCheckBoxTableViewCell: UITableViewCell, CheckboxButtonDelegate {
    
    

    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var checkBox: CheckboxButton!
    
    var section: Int?
    
    var didSelect: ((String, Int) -> ())?
    var didDeSelect: ((String, Int) -> ())?
    
    func setup() {
        checkBox.delegate = self
    }
    
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        didSelect?(optionName.text ?? "",section ?? 0)
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        didDeSelect?(optionName.text ?? "",section ?? 0)
    }
}
