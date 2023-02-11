//
//  HelpItemIssueTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 12/10/2022.
//

import UIKit
import MBRadioCheckboxButton

class HelpItemIssueTableViewCell: UITableViewCell, RadioButtonDelegate {

    @IBOutlet weak var issueExample: UILabel!
    @IBOutlet weak var issueTitle: UILabel!
    @IBOutlet weak var issueRadio: RadioButton!
    
//    var selectedModel: ((SupportIssues?) -> ())?
    
    var model: SupportIssues? {
        didSet {
            issueExample.isHidden = model?.example == nil || model?.example == ""
            issueExample.text = "Ex: \(model?.example ?? "")"
            issueTitle.text = model?.description
        }
    }
    
    func setup() {
        issueRadio.delegate = self
    }
    
    func radioButtonDidSelect(_ button: RadioButton) {
//        self.selectedModel?(model)
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        
    }
}
