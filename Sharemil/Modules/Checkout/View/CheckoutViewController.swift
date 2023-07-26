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

class CustomSegmentedControl: UISegmentedControl{
    private let segmentInset: CGFloat = 5       //your inset amount
    private let segmentImage: UIImage? = UIImage(color: UIColor.white)    //your color

    override func layoutSubviews(){
        super.layoutSubviews()

        //background
        layer.cornerRadius = bounds.height/2
        //foreground
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView
        {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = segmentImage    //substitute with our own colored image
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")    //this removes the weird scaling animation!
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.bounds.height/2
        }
    }
}

extension UIImage{
    
    //creates a UIImage given a UIColor
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

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

enum CheckoutType {
    case delivery
    case pickup
}

class CheckoutViewController: UIViewController, Storyboarded, ApplePayContextDelegate, PaymentOptionsService {
    func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: StripeAPI.PaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
        
        self.createPaymentIntent(.apple ,self.cartItems?.first?.cartId ?? "", paymentMethodId: paymentMethod.id, self.orderModel?.id ?? "", completion: { result in
            
            switch result {
            case .success(let model):
                self.paymentIntent = model.data?.paymentIntentId ?? ""
                completion(model.data?.paymentIntentIdSecret ?? "", nil);
            case .failure(let error):
                break
            }
        })
        
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
    
    @IBOutlet weak var deliveryStack: UIView!
    @IBOutlet weak var deliveryPickupSegment: CustomSegmentedControl!
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var placeOrderBtn: UIButton!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedDeliveryLocation: MyLocationModel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var defaultCheckoutType: CheckoutType = .pickup {
        didSet {
            self.tableView.reloadData()
        }
    }
    
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
    var orderModel: OrderModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.deliveryPickupSegment.selectedSegmentIndex = 1
        self.deliveryPickupSegment.layer.masksToBounds = true
        deliveryPickupSegment.layer.cornerRadius = 20
        self.deliveryPickupSegment.backgroundColor = UIColor.init(hex: "D9D9D9")
        bindViewModel()
        setTableView()
        self.viewModel.getRoute(loc?.location?.coordinate ?? CLLocationCoordinate2D.init(), destination: CLLocationCoordinate2D.init(latitude: chef?.latitude ?? 0, longitude: chef?.longitude ?? 0))
        self.viewModel.getCart(self.cartItems?.first?.cartId ?? "")
        if self.chef?.isOpen == false {
            self.scheduleType = ""
            self.placeOrderBtn.disable()
        } else {
            self.scheduleType = "standard"
            self.placeOrderBtn.enable()
        }
        self.viewModel.getDefaultMethod()
        self.viewModel.fetchChefBy(location: loc ?? LLocation(location: nil), name: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewModel.getCart(self.cartItems?.first?.cartId ?? "")
        self.viewModel.fetchUserProfile()
//        self.viewModel.getDefaultMethod()
//        self.viewModel.getCart(self.cartItems?.first?.cartId ?? "")
    }
    
    private func setup() {
        self.cardImage.isHidden = true
        self.placeOrderBtn.disable()
        paymentView.isUserInteractionEnabled = true
        paymentView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openPaymentMethods)))
    }
    
    @IBAction func deliveryPickupAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.defaultCheckoutType = .delivery
        } else {
            self.defaultCheckoutType = .pickup
        }
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
            self.deliveryStack.isHidden = !(self.chef?.deliverySettings?.deliveryEnabled ?? false)
            self.tableView.reloadData()
        }
        self.viewModel.cusines.bind { cusines in
            self.cusines = cusines
        }
        
        self.viewModel.cartList.bind { cartItems in
            let val = cartItems?.cartItems?.compactMap({ item in
                let options = item.options?.map({$0.choices?.first?.price ?? 0}).reduce(0,+) ?? 0
                return Double(item.quantity ?? 0)*((item.menuItem?.price ?? 0) + options)
            })
            let totalPrice = val?.reduce(0, +) ?? 0
            self.subTotal.text = "$\(totalPrice.withDecimal(2))"
            self.total.text = "$\(totalPrice.withDecimal(2))"
            self.placeOrderBtn.setTitle("Place order · \("$\(totalPrice.withDecimal(2))")", for: .normal)
            self.cartItems = cartItems?.cartItems
            self.tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .automatic)
            if self.cartItems?.filter({$0.menuItem?.remainingItems == 0}).count != 0 {
                self.showToastMsg("Some items in your cart seems to be out of stock today, either remove the item or you can schedule your order for another day.", state: .warning, location: .bottom)
            }
        }
        
        self.viewModel.paymentIntent.bind { model in
            self.paymentIntent = model?.paymentIntentId
            self.viewModel.continuePayment(self.paymentIntent ?? "")
        }
        
        self.viewModel.orderCreated.bind { m in
            self.orderModel = m
            if self.selectedPayment?.name?.contains("Apple") ?? false {
                self.openApplePay()
            } else {
                self.viewModel.createPayment(self.cartItems?.first?.cartId ?? "", paymentMethodId: self.selectedPayment?.id ?? "", m?.id ?? "")
            }
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
        vc.isSchedule = self.scheduleType != "standard" && self.defaultCheckoutType != .delivery
        vc.isDeliver = self.defaultCheckoutType == .delivery
        vc.didApprove = {
            if self.user?.isValid() == false {
                
                let coordinator = EditAccountCoordinator.init(navigationController: UINavigationController())
//                let vc = UINavigationController.init(rootViewController: coordinator.getMainView())
//                vc.modalPresentationStyle = .overFullScreen
                self.navigationController?.pushViewController(coordinator.getMainView(), animated: true)
            } else {
                if self.defaultCheckoutType == .delivery {
                    self.viewModel.createOrderWithDelivery(self.selectedDeliveryLocation?.id, self.selectedScheduleDate, self.selectedPayment?.id ?? "", self.cartItems?.first?.cartId ?? "")
                } else {
                    self.viewModel.createOrderWith(self.selectedScheduleDate, self.selectedPayment?.id ?? "", self.cartItems?.first?.cartId ?? "")
                }
               
            }
        }
        vc.didCancel = {
            
        }
        self.present(vc.getMainView(), animated: true)
    }
    
    @objc func openLocationView() {
        let vc = MyLocationCoordinator.init(navigationController: self.navigationController!)
        vc.isDeliverySection = true
        vc.didSelectPlace = { place in
            self.selectedDeliveryLocation = place
        }
        self.present(vc.getMainView(), animated: true)
    }
    
    private func openApplePay() {
        let merchantIdentifier = "merchant.com.sharemil.sharemil"
        let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "US", currency: "USD")
        let item = PKPaymentSummaryItem()
        item.label = "Sharemil Inc"
        let val = self.cartItems?.compactMap({ item in
            let options = item.options?.map({$0.choices?.first?.price ?? 0}).reduce(0,+) ?? 0
            return Double(item.quantity ?? 0)*((item.menuItem?.price ?? 0) + options)
        })
        let amount = val?.reduce(0, +).withDecimal(2) ?? ""
        item.amount = NSDecimalNumber.init(string: amount)
        //                item.amount = NSDecimalNumber.init(string: amount)
        // Configure the line items on the payment request
        paymentRequest.paymentSummaryItems = [
            item
        ]
        
        if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
            // Present Apple Pay payment sheet
            applePayContext.presentApplePay()
        } else {
            // There is a problem with your Apple Pay configuration
        }
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
            cell.containsOutOfStockItem = !(self.cartItems?.filter({$0.menuItem?.remainingItems == 0}).isEmpty ?? false)
            cell.currentDeliveryLocation = self.selectedDeliveryLocation
            cell.checkoutType = self.defaultCheckoutType
            cell.chef = self.chef
            cell.scheduleDateField.text = self.scheduleType == "standard" ? scheduleDate : scheduleType
            cell.standardContainer.addBorderwith(scheduleType == "standard" ? .black : UIColor.init(hex: "EAEAEA"), width: 1)
            cell.scheduleContainer.addBorder( scheduleType == "standard" ? UIColor.init(hex: "EAEAEA") : .black)
            cell.polylines = self.polylines
            cell.didTapDeliveryAction = {
                self.openLocationView()
            }
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
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let d = formatter.date(from: date.replacingOccurrences(of: " GMT", with: ""))
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
                    self.selectedScheduleDate = formatter.string(from: d ?? Date())
                }
                self.present(vc, animated: true)
            }
            cell.didSelectTime = { type in
                self.scheduleType = type
                if self.scheduleType == "standard" {
                    self.selectedScheduleDate = nil
                } else {
                    self.scheduleDate = type
                }
            }
            cell.didSelectMainDate = { date in
//                let formatter = DateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
//                self.selectedScheduleDate = formatter.string(from: date ?? Date())
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
                coordinator.isFromCheckout = true
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
            return 109 + (CGFloat(self.cartItems?.count ?? 0) * 65)
        default: return 0
        }
    }
    
}
