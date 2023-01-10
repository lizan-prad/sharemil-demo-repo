//
//  CheckoutViewController.swift
//  Sharemil
//
//  Created by lizan on 24/06/2022.
//

import UIKit
import GoogleMaps
import Stripe
import GooglePlaces
import StripeApplePay
import PassKit

extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}

class CheckoutViewController: UIViewController, Storyboarded, ApplePayContextDelegate {
    func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: StripeAPI.PaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
        completion(self.paymentIntent ?? "", nil);
    }
    
    func applePayContext(_ context: STPApplePayContext, didCompleteWith status: STPApplePayContext.PaymentStatus, error: Error?) {
        switch status {
        case .success:
            self.viewModel.continuePayment(self.paymentIntent ?? "")
            // Payment succeeded, show a receipt view
        case .error:
            // Payment failed, show the error
            break
        case .userCancellation:
            // User canceled the payment
            break
        @unknown default:
            fatalError()
        }
    }
    

    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var placeOrderBtn: UIButton!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: CheckoutViewModel!
//    var paymentSheet: PaymentSheet?
 
    var polylines: [GMSPath]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var selectedScheduleDate: String?
    var scheduleType: String? {
        didSet {
            self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        }
    }
    
    var user: UserModel?
    
    var cusines: [CusineListModel]?
    
    var chef: ChefListModel?
    var cartItems: [CartItems]?
    var paymentIntent: String? {
        didSet {
            self.placeOrderBtn.enable()
        }
    }
    
    var scheduleDate: String? {
        didSet {
            if scheduleType != "standard" {
                (scheduleDate == nil || scheduleDate == "") ? self.placeOrderBtn.disable() : self.placeOrderBtn.enable()
            }
        }
    }
    
    var selectedPayment: PaymentMethods? {
        didSet {
            self.cardImage.isHidden = false
            self.cardImage.image = UIImage.init(named: selectedPayment?.stripePaymentMethod?.card?.brand ?? "")
            self.cardLabel.text = (selectedPayment?.name?.contains("Apple") ?? false ? selectedPayment?.name : selectedPayment?.stripePaymentMethod?.card?.last4?.getCardNumberFormatted())
            if self.chef?.isOpen == true {
                self.placeOrderBtn.enable()
            }
//            if !(selectedPayment?.name?.contains("Apple") ?? false) {
//            self.viewModel.createPayment(cartItems?.first?.cartId ?? "", paymentMethodId: selectedPayment?.id ?? "")
//            }
        }
    }
    
    var didCheckoutComplete: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
        setTableView()
        self.viewModel.getRoute(loc?.location?.coordinate ?? CLLocationCoordinate2D.init(), destination: CLLocationCoordinate2D.init(latitude: chef?.latitude ?? 0, longitude: chef?.longitude ?? 0))
        self.viewModel.getCart(self.cartItems?.first?.cartId ?? "")
        self.viewModel.fetchChefBy(location: loc ?? LLocation.init(location: nil), name: nil)
        self.viewModel.getDefaultMethod()
        self.viewModel.fetchUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewModel.getCart(self.cartItems?.first?.cartId ?? "")
//        self.viewModel.getDefaultMethod()
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
        
        self.viewModel.method.bind { method in
            if method == nil {
                self.cardImage.isHidden = false
                self.cardLabel.text = "Select payment method"
            } else {
                self.selectedPayment = method
            }
        }
        
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        
        self.viewModel.success.bind { msg in
            self.viewModel.getCart(self.cartItems?.first?.cartId ?? "")
        }
        self.viewModel.user.bind { user in
            self.user = user
        }
        
        self.viewModel.chefs.bind { chefs in
            self.chef = chefs?.filter({$0.id == self.chef?.id}).first
            if self.chef?.isOpen == false {
                self.scheduleType = ""
                self.placeOrderBtn.disable()
            } else {
                self.scheduleType = "standard"
                self.placeOrderBtn.enable()
            }
            self.tableView.reloadData()
        }
        self.viewModel.cusines.bind { cusines in
            self.cusines = cusines
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
        self.viewModel.completeCheckout.bind { msg in
            
            if self.scheduleType != "standard" {
                self.showToastMsg("Order scheduled successfully!", state: .success, location: .bottom)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.dismiss(animated: true) {
                        self.didCheckoutComplete?()
                        self.dismiss(animated: true) {
                            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "CARTBADGE"), object: msg?.id ?? "")
                        }
                    }
                    
                }
            } else {
                self.showToastMsg("Order placed!", state: .success, location: .bottom)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.dismiss(animated: true) {
                        self.didCheckoutComplete?()
                        self.dismiss(animated: true) {
                            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "CHECK"), object: msg?.id ?? "")
                            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "CARTBADGE"), object: msg?.id ?? "")
                            
                        }
                    }
                }
            }
        }
        
        
        self.viewModel.payment.bind { model in
//            STPAPIClient.shared.publishableKey = model?.publishableKey ?? ""
//            // MARK: Create a PaymentSheet instance
//            var configuration = PaymentSheet.Configuration()
//            configuration.merchantDisplayName = "Sharemil, Inc."
//            configuration.customer = .init(id: model?.customer ?? "", ephemeralKeySecret: model?.ephemeralKey ?? "")
//            // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
//            // methods that complete payment after a delay, like SEPA Debit and Sofort.
//            configuration.allowsDelayedPaymentMethods = true
//            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: model?.paymentIntent ?? "", configuration: configuration)
//            self.paymentSheet?.present(from: self) { paymentResult in
//                // MARK: Handle the payment result
//                switch paymentResult {
//                case .completed:
//                    self.showToastMsg("You order has been placed!", state: .success, location: .bottom)
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//                        self.dismiss(animated: true)
//                    }
//                case .canceled:
//                   break
//                case .failed(let error):
//                    self.showToastMsg("We are having some issues checking out!", state: .error, location: .bottom)
//                }
//              }
        }
    }
    
    
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func placeOrderAction(_ sender: Any) {
        self.openConfirmation()
    }
    
    private func openConfirmation() {
        let vc = ConfirmationAskCoordinator.init(navigationController: UINavigationController())
        vc.isUserReg = !(self.user?.isValid() ?? false)
        vc.isSchedule = self.scheduleType != "standard"
        vc.didApprove = {
            if self.user?.isValid() == false {
                guard let nav = self.navigationController else {return}
                let coordinator = EditAccountCoordinator.init(navigationController: nav)
                let vc = UINavigationController.init(rootViewController: coordinator.getMainView())
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc , animated: true)
            } else {
                if self.selectedPayment?.name?.contains("Apple") ?? false {
                    let merchantIdentifier = "merchant.com.sharemil.sharemil"
                    let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "US", currency: "USD")
                    var item = PKPaymentSummaryItem()
                    item.label = "Sharemil Inc"
                    let a = self.cartItems?.map({($0.menuItem?.price ?? 0)*Double($0.quantity ?? 0)})
                    let amount = a?.reduce(0, +).withDecimal(2)
                    item.amount = NSDecimalNumber.init(string: amount)
                    //                item.amount = NSDecimalNumber.init(string: amount)
                    // Configure the line items on the payment request
                    paymentRequest.paymentSummaryItems = [
                        item
                    ]
                    
                    if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
                        // Present Apple Pay payment sheet
                        applePayContext.presentApplePay(on: self)
                    } else {
                        // There is a problem with your Apple Pay configuration
                    }
                } else {
                    self.viewModel.createOrderWith(self.selectedScheduleDate, self.selectedPayment?.id ?? "", self.cartItems?.first?.cartId ?? "")
                }
            }
        }
        vc.didCancel = {
            
        }
        self.present(vc.getMainView(), animated: true)
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
            cell.chef = self.chef
            
            cell.scheduleDateField.text = self.scheduleType == "standard" ? scheduleDate : scheduleType
            cell.standardContainer.addBorderwith(scheduleType == "standard" ? .black : UIColor.init(hex: "EAEAEA"), width: 1)
            cell.scheduleContainer.addBorder( scheduleType == "standard" ? UIColor.init(hex: "EAEAEA") : .black)
            cell.polylines = self.polylines
            cell.didProcessDateError = { error in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.showToastMsg(error, state: .error, location: .top)
                }
                
            }
            cell.didTapSchedule = { hours in
                let vc = UIStoryboard.init(name: "CustomPicker", bundle: nil).instantiateViewController(withIdentifier: "CustomPickerViewController") as! CustomPickerViewController
                vc.hours = hours
                vc.didSelectDate = { (str, date) in
                    self.scheduleType = str
                    self.scheduleDate = date
                    self.selectedScheduleDate = date
                }
                self.present(vc, animated: true)
            }
            cell.didSelectTime = { type in
                self.scheduleType = type
                if self.scheduleType == "standard" {
                    self.viewModel.updateToCart(self.chef?.id ?? "", cartModels: self.cartItems ?? [])
                } else {
                    self.scheduleDate = type
                }
            }
            cell.didSelectMainDate = { date in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                self.selectedScheduleDate = formatter.string(from: date ?? Date())
            }
            
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
                coordinator.cusine = self.cusines?.filter({$0.id == self.chef?.cuisineId}).first
                coordinator.start()
            }
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return UITableView.automaticDimension
        default: return 0
        }
    }
    
}
