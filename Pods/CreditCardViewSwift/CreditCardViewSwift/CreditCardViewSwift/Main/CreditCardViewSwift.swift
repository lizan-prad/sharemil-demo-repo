//
//  CreditCardViewSwift.swift
//  CreditCardViewSwift
//
//  Created by Osama on 02/06/2020.
//  Copyright © 2020 Osama Azmat Khan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

public protocol CreditCardViewSwiftDelegate {
    func cardDataValidated(name: String, cardNumber: String, cardExpiry: String, cvvNumber: String)
}

extension UIView {
    func addBorder(_ color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
    }
    
    func hideError() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
    
    func showError() {
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
    }
}


@IBDesignable public class CreditCardViewSwift: UIView {
    
    var view: UIView!
    
    @IBOutlet weak var cardStack: UIView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var nameOnCardTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cardNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cardExpirationTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cvvTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var nickNameContainer: UIView!
    @IBOutlet weak var zipCOntainer: UIView!
    @IBOutlet weak var cvvContainer: UIView!
    @IBOutlet weak var expDateContainer: UIView!
    @IBOutlet weak var cardNumberCOntainer: UIView!
    
    @IBInspectable
    public var namePlaceHolder: String = "Your Name" {
        didSet {
            self.nameOnCardTextField.placeholder = self.namePlaceHolder
        }
    }
    
    @IBInspectable
    public var numPlaceHolder: String = "Card Number" {
        didSet {
            self.cardNumberTextField.placeholder = self.namePlaceHolder
        }
    }
    
    @IBInspectable
    public var expPlaceHolder: String = "Card Expiry" {
        didSet {
            self.cardExpirationTextField.placeholder = self.namePlaceHolder
        }
    }
    
    @IBInspectable
    public var cvvPlaceHolder: String = "CVV" {
        didSet {
            self.cvvTextField.placeholder = self.namePlaceHolder
        }
    }
    
    var nameOnCard: String      = ""
    var cardNumber: String      = ""
    var cardExpiry: String      = ""
    var cvvNumber: String       = ""
    
    public var delegate: CreditCardViewSwiftDelegate?
    
    func xibSetup() {
        view = loadViewFromNib()
        
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        bringSubviewToFront(view)
        
        nameOnCardTextField.makeAutoCapitalized()
        cardNumberTextField.keyboardType = .numberPad
        cardExpirationTextField.keyboardType = .numberPad
        cvvTextField.keyboardType = .numberPad
        
        cardNumberTextField.delegate = self
        cardExpirationTextField.delegate = self
        cardStack.isHidden = true
        nickNameContainer.addBorder(.black)
        zipCOntainer.addBorder(.black)
        cvvContainer.addBorder(.black)
        expDateContainer.addBorder(.black)
        cardNumberCOntainer.addBorder(.black)
        nameOnCardTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        cardNumberTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        cardExpirationTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        cvvTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: "CreditCardViewSwift", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    public override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    public static var visaIcon: UIImage {
        let bundle = Bundle(for: self)
        return UIImage(named: "visa", in: bundle, compatibleWith: nil)!
    }
    
    public static var masterIcon: UIImage {
        let bundle = Bundle(for: self)
        return UIImage(named: "mastercard", in: bundle, compatibleWith: nil)!
    }
    
    public static var americanIcon: UIImage {
        let bundle = Bundle(for: self)
        return UIImage(named: "american-express", in: bundle, compatibleWith: nil)!
    }
    
    public static var discoverIcon: UIImage {
        let bundle = Bundle(for: self)
        return UIImage(named: "discover", in: bundle, compatibleWith: nil)!
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 1 {
            self.nameOnCard = textField.text!
        }
        else if textField.tag == 2 {
            self.cardNumber = textField.text!
            self.cardStack.isHidden = CardManager.getCardType(textField.text ?? "") == "nil"
            switch CardManager.getCardType(textField.text ?? "") {
            case "visa":
                self.cardImage.image = CreditCardViewSwift.visaIcon
            case "mastercard":
                self.cardImage.image = CreditCardViewSwift.masterIcon
            case "discover":
                self.cardImage.image = CreditCardViewSwift.discoverIcon
            case "american-express":
                self.cardImage.image = CreditCardViewSwift.americanIcon
            default:
                break
            }
            
        }
        else if textField.tag == 3 {
            self.cardExpiry = textField.text!
        }
        else if textField.tag == 4 {
            self.cvvNumber = textField.text!
        }
        
        let isValid = validate()
        
        if isValid {
            if let delegate = self.delegate {
                delegate.cardDataValidated(name: self.nameOnCard, cardNumber: self.cardNumber, cardExpiry: self.cardExpiry, cvvNumber: self.cvvNumber)
            }
        }
    }
    
    func validate() -> Bool {
//        if Validator().isNameValid(nameOnCard) {
//            self.nickNameContainer.hideError()
            let creditCardValidationInfo = Validator().validateCreditCardFormat(cardNumber)
            if creditCardValidationInfo.valid {
                cardNumber = cardNumber.replacingOccurrences(of: " ", with: "")
                self.cardNumberCOntainer.hideError()
                if Validator().isExpiryValid(self.cardExpiry) {
                    self.expDateContainer.hideError()
                    if Validator().isCVVOfCardValid(self.cvvNumber) {
                        self.cvvContainer.hideError()
                        return true
                    }
                    else {
                        self.cvvContainer.showError()
                        return false
                    }
                }
                else {
                    self.expDateContainer.showError()
                    return false
                }
            }
            else {
                self.cardNumberCOntainer.showError()
                return false
            }
//        }
//        else {
////            self.nickNameContainer.showError()
//            return false
//        }
    }
    
}

extension CreditCardViewSwift: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 2 {
            let input = textField.text ?? ""
            let numberOnly = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            var formatted = ""
            // format
            var formatted4 = ""
            for character in numberOnly {
                if formatted4.count == 4 {
                    formatted += formatted4 + " "
                    formatted4 = ""
                }
                formatted4.append(character)
            }
            formatted += formatted4 // the rest
            
            textField.text = formatted
        }
        if textField.tag == 3 {
            if range.length > 0 {
                return true
            }
            if string == "" {
                return false
            }
            if range.location > 4 {
                return false
            }
            var originalText = textField.text
            let replacementText = string.replacingOccurrences(of: " ", with: "")
            
            //Verify entered text is a numeric value
            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: replacementText)) {
                return false
            }
            
            //Put / after 2 digit
            if range.location == 2 {
                originalText?.append("/")
                textField.text = originalText
            }
            return true
        }
        else {
            return true
        }
    }
}
