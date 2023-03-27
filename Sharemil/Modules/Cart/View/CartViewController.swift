//
//  CartViewController.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit
import FirebaseAuth

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: CartViewModel!
    var carts: [Cart]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CartViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartItems), name: Notification.Name.init("CARTUPDATE"), object: nil)
        bindViewModel()
        setTableView()
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
//            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
            self.start()
        }
        self.viewModel.carts.bind { cartItems in
            self.carts = cartItems?.carts
        }
        self.viewModel.deleteState.bind { msg in
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "CARTBADGE"), object: nil)
            self.viewModel.fetchCarts()
        }
    }
    
    @objc func updateCartItems() {
        self.viewModel.fetchCarts()
    }
    
    private func start() {
        self.showProgressHud()
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { token, error in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                UserDefaults.standard.set(token, forKey: StringConstants.userIDToken)
                self.viewModel.fetchCarts()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Cart"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.viewModel.fetchCarts()
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "CartListTableViewCell", bundle: nil), forCellReuseIdentifier: "CartListTableViewCell")
    }
    

}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartListTableViewCell") as! CartListTableViewCell
        cell.cart = carts?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coordinator = CartDetailCoordinator.init(navigationController: UINavigationController())
        coordinator.cartItems = self.carts?[indexPath.row].cartItems
        coordinator.menuItems = self.carts?[indexPath.row].cartItems?.compactMap({$0.menuItem})
        coordinator.chef = self.carts?[indexPath.row].chef
        coordinator.didUpdate = {
            self.viewModel.fetchCarts()
        }
        coordinator.didCheckout = { chef in
          
            let coordinator = CheckoutCoordinator.init(navigationController: UINavigationController())
            coordinator.cartList = self.carts?[indexPath.row].cartItems
            coordinator.chef = chef
            coordinator.didCheckoutComplete = {
                self.viewModel.fetchCarts()
            }
            let nav = UINavigationController.init(rootViewController: coordinator.getMainView())
            nav.modalPresentationStyle = .overFullScreen
            self.present(nav, animated: true)
        }
        self.present(coordinator.getMainView(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            let alert = AlertServices.showAlertWithOkCancelAction(title: nil, message: "Do you wish to delete?") { _ in
                self.viewModel.deleteCart(self.carts?[indexPath.row].id ?? "")
            }
            self.present(alert, animated: true)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActions
    }
    
    
}
