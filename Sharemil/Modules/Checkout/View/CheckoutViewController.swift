//
//  CheckoutViewController.swift
//  Sharemil
//
//  Created by lizan on 24/06/2022.
//

import UIKit
import GoogleMaps

class CheckoutViewController: UIViewController, Storyboarded {

    @IBOutlet weak var placeOrderBtn: UIButton!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: CheckoutViewModel!
    
    var polylines: [GMSPath]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var chef: ChefListModel?
    var cartItems: [CartItems]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
        setTableView()
        self.viewModel.getRoute(CLLocationCoordinate2D.init(), destination: CLLocationCoordinate2D.init())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewModel.getCart(self.cartItems?.first?.cartId ?? "")
    }
    
    private func setup() {
        paymentView.isUserInteractionEnabled = true
        paymentView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openPaymentMethods)))
    }
    
    @objc private func openPaymentMethods() {
        guard let nav = self.navigationController else {return}
        let coordinator = PaymentOptionsCoordinator.init(navigationController: nav)
        coordinator.cartId = self.cartItems?.first?.cartId
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
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
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
            cell.setup()
            cell.polylines = self.polylines
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
