//
//  CustomStripeViewController.swift
//  Sharemil
//
//  Created by Lizan on 15/07/2022.
//

import UIKit
import Stripe


class CustomStripeViewController: UIViewController, Storyboarded {

    @IBOutlet var cvcField: STPCardCVCInputTextField?
    @IBOutlet var expDateField: STPCardExpiryInputTextField?
    @IBOutlet var cardField: STPCardNumberInputTextField?
    @IBOutlet weak var nickNameContainer: UIView!
    @IBOutlet weak var zipCOntainer: UIView!
    @IBOutlet weak var cvvContainer: UIView!
    @IBOutlet weak var expDateContainer: UIView!
    @IBOutlet weak var cardNumberCOntainer: UIView!
    
    var viewModel: CustomStripeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setup() {
        cvcField = STPCardCVCInputTextField.init(prefillDetails: nil)
        expDateField = STPCardExpiryInputTextField.init(prefillDetails: nil)
        cardField = STPCardNumberInputTextField.init(prefillDetails: nil)
        nickNameContainer.addBorder(.black)
        zipCOntainer.addBorder(.black)
        cvvContainer.addBorder(.black)
        expDateContainer.addBorder(.black)
        cardNumberCOntainer.addBorder(.black)
    }

}
