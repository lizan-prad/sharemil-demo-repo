//
//  CheckoutTipsTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 01/05/2024.
//

import UIKit

enum TipType {
    case tip10
    case tip20
    case noTip
}

class CheckoutTipsTableViewCell: UITableViewCell {

    @IBOutlet weak var customTipField: UITextField!
    @IBOutlet weak var tip20Btn: UIButton!
    @IBOutlet weak var tip10Btn: UIButton!
    @IBOutlet weak var noTipBtn: UIButton!
    
    var tipType: TipType = .noTip {
        didSet {
            switch tipType {
            case .tip10:
                didSelectTip?(10)
            case .tip20:
                didSelectTip?(20)
            case .noTip:
                didSelectTip?(0)
            }
        }
    }
    
    var didSelectTip: ((Double) -> ())?
    var didSelectTipManual: ((Double) -> ())?
    
    func setup() {
        tip10Btn.addBorder(.lightGray)
        tip20Btn.addBorder(.lightGray)
        noTipBtn.addBorder(.darkGray)
        tip10Btn.addCornerRadius(8)
        tip20Btn.addCornerRadius(8)
        noTipBtn.addCornerRadius(8)
        customTipField.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
    }
    
    @objc func textChange(_ sender: UITextField) {
        
        tip10Btn.addBorder(.lightGray)
        tip20Btn.addBorder(.lightGray)
        noTipBtn.addBorder(.darkGray)
        self.didSelectTipManual?(Double(sender.text ?? "") ?? 0)
        
    }
    
    @IBAction func noTipAction(_ sender: Any) {
        tipType = .noTip
        tip10Btn.addBorder(.lightGray)
        tip20Btn.addBorder(.lightGray)
        noTipBtn.addBorder(.darkGray)
        customTipField.text = nil
    }
    
    @IBAction func tip10Action(_ sender: Any) {
        tipType = .tip10
        tip10Btn.addBorder(.darkGray)
        tip20Btn.addBorder(.lightGray)
        noTipBtn.addBorder(.lightGray)
        customTipField.text = nil
    }
    
    @IBAction func tip20Action(_ sender: Any) {
        tipType = .tip20
        tip10Btn.addBorder(.lightGray)
        tip20Btn.addBorder(.darkGray)
        noTipBtn.addBorder(.lightGray)
        customTipField.text = nil
    }
}
