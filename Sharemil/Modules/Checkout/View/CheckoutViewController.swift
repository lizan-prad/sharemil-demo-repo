//
//  CheckoutViewController.swift
//  Sharemil
//
//  Created by lizan on 24/06/2022.
//

import UIKit
import GoogleMaps
import Stripe

class CheckoutViewController: UIViewController, Storyboarded {

    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var placeOrderBtn: UIButton!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: CheckoutViewModel!
    var paymentSheet: PaymentSheet?
    
    var polylines: [GMSPath]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var chef: ChefListModel?
    var cartItems: [CartItems]?
    var paymentIntent: String? {
        didSet {
            self.placeOrderBtn.enable()
        }
    }
    
    var selectedPayment: PaymentMethods? {
        didSet {
            self.cardImage.isHidden = false
            self.cardImage.image = UIImage.init(named: "visa")
            self.cardLabel.text = selectedPayment?.stripePaymentMethod?.card?.last4?.getCardNumberFormatted()
            self.viewModel.createPayment(cartItems?.first?.cartId ?? "", paymentMethodId: selectedPayment?.id ?? "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
        setTableView()
        self.viewModel.getRoute(loc?.location?.coordinate ?? CLLocationCoordinate2D.init(), destination: CLLocationCoordinate2D.init(latitude: chef?.latitude ?? 0, longitude: chef?.longitude ?? 0))
        self.viewModel.getCart(self.cartItems?.first?.cartId ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        self.viewModel.getCart(self.cartItems?.first?.cartId ?? "")
    }
    
    private func setup() {
        self.cardImage.isHidden = true
        self.placeOrderBtn.disable()
        paymentView.isUserInteractionEnabled = true
        paymentView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openPaymentMethods)))
    }
    
    @objc private func openPaymentMethods() {
        guard let nav = self.navigationController else {return}
        let coordinator = PaymentOptionsCoordinator.init(navigationController: nav)
        coordinator.cartId = self.cartItems?.first?.cartId
        coordinator.didSelectMethod = { method in
            self.selectedPayment = method
        }
        coordinator.start()
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib.init(nibName: "CheckoutMapTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckoutMapTableViewCell")
        tableView.register(UINib.init(nibName: "CheckoutOrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckoutOrdersTableViewCell")
        
    }
    
    private func bindViewModel() {
        viewModel.polylines.bind { polylines in
            self.polylines = polylines
        }
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.cartList.bind { cartItems in
            self.subTotal.text = "$\((cartItems?.cartItems?.map({($0.menuItem?.price ?? 0)*Double($0.quantity ?? 0)}).reduce(0, +) ?? 0).withDecimal(2))"
            self.total.text = "$\((cartItems?.cartItems?.map({($0.menuItem?.price ?? 0)*Double($0.quantity ?? 0)}).reduce(0, +) ?? 0).withDecimal(2))"
            self.placeOrderBtn.setTitle("Place order · \("$\((cartItems?.cartItems?.map({($0.menuItem?.price ?? 0)*Double($0.quantity ?? 0)}).reduce(0, +) ?? 0).withDecimal(2))")", for: .normal)
            self.cartItems = cartItems?.cartItems
            self.tableView.reloadData()
        }
        
        self.viewModel.paymentIntent.bind { model in
            self.paymentIntent = model?.paymentIntentId
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
                    self.showToastMsg("You order has been placed!", state: .success, location: .bottom)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.dismiss(animated: true)
                    }
                case .canceled:
                   break
                case .failed(let error):
                    self.showToastMsg("We are having some issues checking out!", state: .error, location: .bottom)
                }
              }
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func placeOrderAction(_ sender: Any) {
        self.openConfirmation()
    }
    
    private func openConfirmation() {
        let vc = UIStoryboard.init(name: "ConfirmationAsk", bundle: nil).instantiateViewController(withIdentifier: "ConfirmationAskViewController") as! ConfirmationAskViewController
        vc.didApprove = {
            self.viewModel.continuePayment(self.paymentIntent ?? "")
        }
        vc.didCancel = {
            
        }
        self.present(vc, animated: true)
    }
    
}

extension CheckoutViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutMapTableViewCell") as! CheckoutMapTableViewCell
            
            cell.polylines = self.polylines
            cell.chef = self.chef
            cell.setup()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutOrdersTableViewCell") as! CheckoutOrdersTableViewCell
            cell.setTable()
            cell.setup()
            cell.cartItems = self.cartItems
            cell.didTapAdd = {
                guard let nav = self.navigationController else {return}
                let coordinator = ChefMenuCoordinator.init(navigationController: nav)
                coordinator.chef = self.chef
                coordinator.start()
            }
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 305
        case 1:
            return UITableView.automaticDimension
        default: return 0
        }
    }
    
}
