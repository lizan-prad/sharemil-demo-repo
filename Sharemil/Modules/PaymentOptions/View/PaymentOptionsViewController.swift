//
//  PaymentOptionsViewController.swift
//  Sharemil
//
//  Created by lizan on 01/07/2022.
//

import UIKit
import Stripe

class PaymentOptionsViewController: UIViewController, Storyboarded {

    @IBOutlet weak var addCardView: UIView!
    var viewModel: PaymentOptionsViewModel!
    
    var cartId: String?
    var paymentSheet: PaymentSheet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        
        self.viewModel.payment.bind { model in
            STPAPIClient.shared.publishableKey = model?.publishableKey ?? ""
            // MARK: Create a PaymentSheet instance
            var configuration = PaymentSheet.Configuration()
            configuration.merchantDisplayName = "Example, Inc."
            configuration.customer = .init(id: model?.customer ?? "", ephemeralKeySecret: model?.ephemeralKey ?? "")
            // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
            // methods that complete payment after a delay, like SEPA Debit and Sofort.
            configuration.allowsDelayedPaymentMethods = true
            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: model?.paymentIntent ?? "", configuration: configuration)
            self.paymentSheet?.present(from: self) { paymentResult in
                // MARK: Handle the payment result
                switch paymentResult {  
                case .completed:
                  print("Your order is confirmed")
                case .canceled:
                  print("Canceled!")
                case .failed(let error):
                  print("Payment failed: \(error)")
                }
              }
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setup() {
        addCardView.isUserInteractionEnabled = true
        addCardView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action:          #selector(openCardView)))
    }
  
    @objc private func openCardView() {
        openCustomStripeUI()
//        self.viewModel.proceedPayment(cartId ?? "")
    }
    
    private func openCustomStripeUI() {
        guard let nav = self.navigationController else {return}
        let coordinator = CustomStripeCoordinator.init(navigationController: nav)
        coordinator.start()
    }
}
