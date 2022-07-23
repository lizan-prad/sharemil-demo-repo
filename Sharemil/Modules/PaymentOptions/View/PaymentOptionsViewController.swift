//
//  PaymentOptionsViewController.swift
//  Sharemil
//
//  Created by lizan on 01/07/2022.
//

import UIKit
import Stripe
import Alamofire

class PaymentOptionsViewController: UIViewController, Storyboarded, STPAddCardViewControllerDelegate, STPPaymentOptionsViewControllerDelegate {
    func paymentOptionsViewController(_ paymentOptionsViewController: STPPaymentOptionsViewController, didFailToLoadWithError error: Error) {
        
    }
    
    func paymentOptionsViewControllerDidFinish(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
        
    }
    
    func paymentOptionsViewControllerDidCancel(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
        
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        print("--- created payment method with stripe ID: \(paymentMethod.stripeId)")

            // Call the previous server code to store card info with Alamofire
        let url = URL.init(string: URLConfig.baseUrl)!.appendingPathComponent("attach_card")

            AF.request(url, method: .post, parameters: [
                "customer_id": model?.customer ?? "",
                "stripe_id": paymentMethod.stripeId
            ]).responseJSON { response in
                switch response.result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }

            // Dismiss the modally presented VC
            dismiss(animated: true, completion: nil)
    }
    

    @IBOutlet weak var addCardView: UIView!
    var viewModel: PaymentOptionsViewModel!
    var model: PaymentIntentModel?
    var cartId: String?
    var paymentSheet: PaymentSheet?
    var models: [PaymentMethods]? {
        didSet {
            
        }
    }
    
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
        
        self.viewModel.methods.bind { models in
            self.models = models
        }
        
        self.viewModel.payment.bind { model in
            self.model = model
            self.openCustomStripeUI()
//            STPAPIClient.shared.publishableKey = model?.publishableKey ?? ""
//            // MARK: Create a PaymentSheet instance
//            var configuration = PaymentSheet.Configuration()
//            configuration.merchantDisplayName = "Example, Inc."
//            configuration.customer = .init(id: model?.customer ?? "", ephemeralKeySecret: model?.ephemeralKey ?? "")
//            // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
//            // methods that complete payment after a delay, like SEPA Debit and Sofort.
//            configuration.allowsDelayedPaymentMethods = true
//            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: model?.paymentIntent ?? "", configuration: configuration)
//            self.paymentSheet?.present(from: self) { paymentResult in
//                // MARK: Handle the payment result
//                switch paymentResult {
//                case .completed:
//                  print("Your order is confirmed")
//                case .canceled:
//                  print("Canceled!")
//                case .failed(let error):
//                  print("Payment failed: \(error)")
//                }
//              }
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
        guard let nav = self.navigationController else {return}
                let coordinator = CustomStripeCoordinator.init(navigationController: nav)
                coordinator.start()
//        self.viewModel.proceedPayment(cartId ?? "")
    }
    
    private func openCustomStripeUI() {
        let config = STPPaymentConfiguration()
        config.requiredBillingAddressFields = .none
//        let viewController = STPPaymentOptionsViewController.init(configuration: config, theme: .defaultTheme, customerContext: STPCustomerContext.init(keyProvider: STPCustomerEphemeralKeyProvider), delegate: self)
        
        let viewController = STPAddCardViewController(configuration: config, theme: STPTheme.defaultTheme)
        viewController.delegate = self

        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
//
    }
}
