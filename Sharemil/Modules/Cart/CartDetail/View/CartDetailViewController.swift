//
//  CartDetailViewController.swift
//  Sharemil
//
//  Created by lizan on 23/06/2022.
//

import UIKit

class CartDetailViewController: UIViewController, Storyboarded {

    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chefTitle: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var smoke: UIView!
    
    var viewModel: CartDetailViewModel!
    
    var cartItems: [CartItems]?
    
    var chef: ChefListModel?
    var cartId: String?
    
    var didUpdate: (() -> ())?
    
    var didSelectCheckout: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setup()
        setTable()
        setupGestures()
        self.cartId = cartItems?.first?.cartId
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.smoke.alpha = 0
        self.fogActivate()
        self.chefTitle.text = "\(chef?.firsName ?? "") \(chef?.lastName ?? "")"
    }
    
    private func setupGestures() {
        smoke.isUserInteractionEnabled = true
        smoke.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissPopUp)))
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.deleteState.bind { msg in
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "CARTBADGE"), object: nil)
            self.dismiss(animated: true) {
                self.didUpdate?()
            }
        }
        self.viewModel.cartList.bind { cart in
            self.setup()
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "CARTBADGE"), object: nil)
            self.didUpdate?()
            self.tableView.reloadData()
        }
    }
    
    private func setup() {
        container.addCornerRadius(15)
        var prices = [Double]()
        cartItems?.enumerated().forEach({ (index, item) in
            let price = (Double(item.quantity ?? 0)*(cartItems?[index].menuItem?.price ?? 0))
            prices.append(price)
        })
        self.subTotal.text = "$\(String(format:"%.2f", prices.reduce(0, +)))"
    }
    
    private func setTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableViewHeight.constant = CGFloat((cartItems?.count ?? 0)*65) + 65
        tableView.register(UINib.init(nibName: "CartDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CartDetailTableViewCell")
    }

    
    private func fogActivate() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear, animations: {
            self.smoke.alpha = 0.4
            
        }, completion: { _ in
            
        })
    }
    
    @objc private func dismissPopUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.smoke.alpha = 0.0
            
        }, completion: { _ in
            self.dismiss(animated: true)
        })
        
    }

    @IBAction func checkoutAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.didSelectCheckout?()
        }
    }
}

extension CartDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartDetailTableViewCell") as! CartDetailTableViewCell
        cell.item = self.cartItems?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            let alert = AlertServices.showAlertWithOkCancelAction(title: nil, message: "Do you wish to delete this item?") { _ in
                self.cartItems?.remove(at: indexPath.row)
                if self.cartItems?.isEmpty ?? true {
                    self.viewModel.deleteCart(self.cartId ?? "")
                } else {
                    self.viewModel.updateToCart(self.chef?.id ?? "", cartModels: self.cartItems ?? [])
                }
            }
            self.present(alert, animated: true)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coordinator = MenuItemCoordinator.init(navigationController: UINavigationController())
        coordinator.menuItemModel = self.cartItems?[indexPath.row].menuItem
        coordinator.cartModel = cartItems
        coordinator.isUpdate = true
        coordinator.didAddToCart = { model in
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "CARTBADGE"), object: nil)
//            UserDefaults.standard.set(model?.cart?.id, forKey: model?.cart?.chefId ?? "")
            self.didUpdate?()
//            self.viewModel.fetchCarts(model?.cart?.id ?? "")
        }
        self.present(coordinator.getMainView(), animated: true)
//        let alert = AlertServices.showAlertWithOkCancelAction(title: nil, message: "Do you wish to delete this item?") { _ in
//            self.cartItems?.remove(at: indexPath.row)
//            if self.cartItems?.isEmpty ?? true {
//                self.viewModel.deleteCart(self.cartId ?? "")
//            } else {
//                self.viewModel.updateToCart(self.chef?.id ?? "", cartModels: self.cartItems ?? [])
//            }
//        }
//        self.present(alert, animated: true)
    }
}
