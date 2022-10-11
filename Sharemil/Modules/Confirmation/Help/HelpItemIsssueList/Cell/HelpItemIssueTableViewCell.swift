//
//  HelpItemIssueTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 12/10/2022.
//

import UIKit
import MBRadioCheckboxButton

class HelpItemIssueTableViewCell: UITableViewCell, RadioButtonDelegate {

    @IBOutlet weak var issueTitle: UILabel!
    @IBOutlet weak var issueRadio: RadioButton!
    
    var selectedModel: ((SupportIssues?) -> ())?
    
    var model: SupportIssues? {
        didSet {
            issueTitle.text = model?.description
        }
    }
    
    func setup() {
        issueRadio.delegate = self
    }
    
    func radioButtonDidSelect(_ button: RadioButton) {
        self.selectedModel?(model)
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        
    }
}
