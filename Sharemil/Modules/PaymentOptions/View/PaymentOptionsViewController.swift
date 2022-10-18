//
//  PaymentOptionsViewController.swift
//  Sharemil
//
//  Created by lizan on 01/07/2022.
//

import UIKit
import Stripe
import Alamofire
import PassKit

class PaymentOptionsViewController: UIViewController, Storyboarded {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCardView: UIView!
    var viewModel: PaymentOptionsViewModel!
    var model: PaymentIntentModel?
    var cartId: String?
    var paymentSheet: PaymentSheet?
    
    var models: [PaymentMethods]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var didSelectMethod: ((PaymentMethods?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTable()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getPaymentMethods()
    }
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "PaymentOptionsListTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentOptionsListTableViewCell")
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.success.bind { msg in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.dismiss(animated: true) {
                    self.viewModel.getPaymentMethods()
                }
            }
        }
        self.viewModel.methods.bind { models in
            if StripeAPI.deviceSupportsApplePay() {
                var m = models
                guard let p = PaymentMethods.init(JSON: ["name": "Apple Pay", "stripePaymentMethod" : ["card": ["brand" : "apple"]]]) else {return}
                m?.insert( p, at: 0)
                self.models = m
            } else {
                self.models = models
            }
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
        
//        let viewController = STPAddCardViewController(configuration: config, theme: STPTheme.defaultTheme)
//        viewController.delegate = self
//
//        let navigationController = UINavigationController(rootViewController: viewController)
//        present(navigationController, animated: true, completion: nil)
//
    }
}

extension PaymentOptionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionsListTableViewCell") as! PaymentOptionsListTableViewCell
        cell.model = self.models?[indexPath.row]
        cell.didSelectMenuAction = { id in
            let coordinator = PaymentEditOptionCoordinator.init(navigationController: UINavigationController.init())
            coordinator.id = id
            coordinator.didSelectDelete = { id in
                self.viewModel.deletePaymentMethod(id ?? "")
            }
            coordinator.didSelectDefault = { id in
                self.viewModel.makeDefaultPaymentMethod(id ?? "")
            }
            self.present(coordinator.getMainView(), animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectMethod?(self.models?[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}
