//
//  CartDetailViewController.swift
//  Sharemil
//
//  Created by lizan on 23/06/2022.
//

import UIKit

class CartDetailViewController: UIViewController, Storyboarded {

    @IBOutlet weak var editBtn: UIButton!
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
    
    var didSelectCheckout: ((ChefListModel?) -> ())?
    var menu: [ChefMenuListModel]?
    var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        container.addCornerRadius(15)
        setup()
        setTable()
        setupGestures()
        self.cartId = cartItems?.first?.cartId
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: Notification.Name.init("ITEMR"), object: nil)
        self.viewModel.fetchChefMenu(self.chef?.id ?? "")
        self.viewModel.fetchChefBy(self.chef?.id ?? "")
    }
    
    @objc func updateData() {
        self.viewModel.fetchCarts()
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
        self.viewModel.chef.bind { model in
            self.chef = model
        }
        self.viewModel.deleteState.bind { msg in
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "CARTBADGE"), object: nil)
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "CARTUPDATE"), object: nil)
            self.dismiss(animated: true) {
                self.didUpdate?()
            }
        }
        self.viewModel.cartList.bind { cart in
            self.setup()
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "CARTBADGE"), object: nil)
            self.didUpdate?()
            self.cartItems = cart?.carts?.filter({$0.id == self.cartItems?.first?.cartId}).first?.cartItems
            self.cartItems = self.cartItems?.filter({$0.quantity != 0})
            self.tableView.reloadData()
        }
        self.viewModel.menuItems.bind { menu in
            self.menu = menu
        }
    }
    
    private func setup() {
        var prices = [Double]()
        cartItems?.enumerated().forEach({ (index, item) in
            let opt = item.options?.map({$0.choices?.map({$0.price ?? 0}).reduce(0, +) ?? 0})
            let options = opt?.reduce(0,+) ?? 0
            let price = (Double(item.quantity ?? 0)*((cartItems?[index].menuItem?.price ?? 0) + options))
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
    
    @IBAction func editAction(_ sender: Any) {
        self.isEdit = !isEdit
        self.tableView.reloadData()
        if isEdit {
            self.editBtn.setImage(nil, for: .normal)
            self.editBtn.setTitle("Save", for: .normal)
        } else {
            self.editBtn.setImage(UIImage.init(named: "edit"), for: .normal)
            self.editBtn.setTitle(nil, for: .normal)
            if cartItems?.filter({$0.quantity != 0}).count == 0 {
                self.viewModel.deleteCart(self.cartId ?? "")
            } else {
                self.viewModel.updateToCart(self.chef?.id ?? "", cartModels: self.cartItems?.filter({$0.quantity != 0}) ?? [])
            }
        }
    }
    
    @IBAction func checkoutAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.didSelectCheckout?(self.chef)
        }
    }
}

extension CartDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartDetailTableViewCell") as! CartDetailTableViewCell
        cell.isEdit = self.isEdit
        cell.setup()
        cell.index = indexPath.row
        cell.item = self.cartItems?[indexPath.row]
        cell.menuItem = menu?.filter({$0.id == self.cartItems?[indexPath.row].menuItemId}).first
        cell.didChangeQuantity = { (quantity, index) in
            if var item = self.cartItems?[index ?? 0] {
                item.quantity = quantity
                self.cartItems?.remove(at: index ?? 0)
                self.cartItems?.insert(item, at: index ?? 0)
                self.setup()
                self.tableView.reloadData()
            }
        }
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
        coordinator.selectedItem = cartItems?[indexPath.row]
        coordinator.isUpdate = true
        coordinator.didAddToCart = { model in
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "CARTBADGE"), object: nil)
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.viewModel.fetchCarts()
//            })
            
            if self.cartItems?.isEmpty == true {
                self.dismiss(animated: true) {
                    self.didUpdate?()
                }
            } else {
                //            UserDefaults.standard.set(model?.cart?.id, forKey: model?.cart?.chefId ?? "")
                self.didUpdate?()
            }
//            self.viewModel.fetchCarts(model?.cart?.id ?? "")
        }
        coordinator.didRemove = { model in
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "CARTBADGE"), object: nil)
            
            self.cartItems = self.cartItems?.filter({$0.id != model})
            self.tableViewHeight.constant = CGFloat((self.cartItems?.count ?? 0)*65) + 65
            self.tableView.reloadData()
            if self.cartItems?.isEmpty == true {
                self.dismiss(animated: true) {
                    self.didUpdate?()
                }
            } else {
                //            UserDefaults.standard.set(model?.cart?.id, forKey: model?.cart?.chefId ?? "")
                self.didUpdate?()
            }
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
