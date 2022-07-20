//
//  CustomStripeViewController.swift
//  Sharemil
//
//  Created by Lizan on 15/07/2022.
//

import UIKit
import Stripe
import CreditCardViewSwift

class CustomStripeViewController: UIViewController, Storyboarded {

    @IBOutlet weak var creditCardView: CreditCardViewSwift!
    
    
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
        creditCardView.delegate = self
    }

}

extension CustomStripeViewController: CreditCardViewSwiftDelegate {
    func cardDataValidated(name: String, cardNumber: String, cardExpiry: String, cvvNumber: String) {
        
        print(cardExpiry, cardNumber, cvvNumber, name)
    }
}
