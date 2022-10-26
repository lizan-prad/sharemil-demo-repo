//
//  CustomStripeViewController.swift
//  Sharemil
//
//  Created by Lizan on 15/07/2022.
//

import UIKit
import Stripe
import CreditCardViewSwift

struct CreditCardModel {
    
    var name: String
    var cardNumber: String
    var expMonth: String
    var cvv: String
    var expYear: String
    var isDefault: Bool
}

class CustomStripeViewController: UIViewController, Storyboarded {

    @IBOutlet weak var addCard: UIButton!
    @IBOutlet weak var creditCardView: CreditCardViewSwift!
    
    var model: CreditCardModel? {
        didSet {
            addCard.enable()
        }
    }
    
    var viewModel: CustomStripeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setup() {
        addCard.disable()
        creditCardView.delegate = self
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.success.bind { msg in
            self.showToastMsg(msg ?? "", state: .success, location: .bottom)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func addCardAction(_ sender: Any) {
        let alert = AlertServices.showAlertWithOkCancelActionCompletionYes(title: nil, message: "Set this as a default payment method?") { _ in
            self.model?.isDefault = true
            guard let model = self.model else {return}
            self.viewModel.addPaymentMethod(model)
        } cancelCompletion: { _ in
            guard let model = self.model else {return}
            self.viewModel.addPaymentMethod(model)
        }
        self.present(alert, animated: true)
        
    }
}

extension CustomStripeViewController: CreditCardViewSwiftDelegate {
    func cardDataValidated(name: String, cardNumber: String, cardExpiry: String, cvvNumber: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: Date())
        self.model = CreditCardModel.init(name: name, cardNumber: cardNumber, expMonth: cardExpiry.components(separatedBy: "/").first ?? "", cvv: cvvNumber, expYear: "\(year.prefix(2))\(cardExpiry.components(separatedBy: "/").last ?? "")", isDefault: false)
        
    }
}
