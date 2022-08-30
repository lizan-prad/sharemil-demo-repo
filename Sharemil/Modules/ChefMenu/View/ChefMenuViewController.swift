//
//  ChefMenuViewController.swift
//  Sharemil
//
//  Created by lizan on 19/06/2022.
//

import UIKit

class ChefMenuViewController: UIViewController, Storyboarded {

    @IBOutlet weak var viewCartBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chefTime: UILabel!
    @IBOutlet weak var chefRating: UILabel!
    @IBOutlet weak var chefNameLabel: UILabel!
    
    var viewModel: ChefMenuViewModel!
    
    var menuItems: [ChefMenuListModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var cartItems: [CartItems]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setTableView()
        bindViewModel()
        self.viewModel.fetchChefMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewModel.fetchCarts()
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.menuItems.bind { models in
            self.menuItems = models
        }
        self.viewModel.cartList.bind { cartItems in
            self.cartItems = cartItems
            self.viewCartBtn.isHidden = cartItems?.isEmpty ?? true
            self.viewCartBtn.setTitle("View cart (\(cartItems?.count ?? 0))", for: .normal)
        }
    }
    
    @IBAction func viewCartAction(_ sender: Any) {
        let coordinator = CartDetailCoordinator.init(navigationController: UINavigationController())
        coordinator.cartItems = self.cartItems
        coordinator.menuItems = self.menuItems?.filter({self.cartItems?.map({$0.menuItemId ?? ""}).contains($0.id ?? "") ?? false})
        coordinator.chef = self.viewModel.chef
        coordinator.didUpdate = {
            self.viewModel.fetchCarts()
            self.viewModel.fetchChefMenu()
        }
        coordinator.didCheckout = { [weak self] in
            let coordinator = CheckoutCoordinator.init(navigationController: UINavigationController())
            coordinator.cartList = self?.cartItems
            coordinator.chef = self?.viewModel.chef
            coordinator.didCheckoutComplete = {
                self?.navigationController?.popViewController(animated: true)
            }
            let nav = UINavigationController.init(rootViewController: coordinator.getMainView())
            nav.modalPresentationStyle = .overFullScreen
            self?.present(nav, animated: true)
        }
        self.present(coordinator.getMainView(), animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "ChefMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "ChefMenuTableViewCell")
        self.viewCartBtn.isHidden = true
        
    }
    
    private func setupData() {
        chefNameLabel.text = "\(viewModel.chef?.firsName ?? "") \(viewModel.chef?.lastName ?? "")"
        let formatter = DateFormatter()
        formatter.dateFormat = "eee"
        let now = formatter.string(from: Date()).lowercased()
        let hour = viewModel.chef?.hours?.filter({($0.day?.lowercased() ?? "") == now.prefix(3)}).first
        formatter.dateFormat = "HH:mm:ss"
        let date = formatter.date(from: hour?.endTime ?? "")
        formatter.dateFormat = "hh:mm a"
        self.chefTime.text = "Opens till \(formatter.string(from: date ?? Date()))"
    }

}

extension ChefMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChefMenuTableViewCell") as! ChefMenuTableViewCell
        cell.model = self.menuItems?[indexPath.row]
        cell.quantity.text = "\(self.cartItems?.filter({$0.menuItemId == self.menuItems?[indexPath.row].id}).first?.quantity ?? 0)"
        cell.quantityContainer.isHidden = self.cartItems?.filter({$0.menuItemId == self.menuItems?[indexPath.row].id}).isEmpty ?? true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coordinator = MenuItemCoordinator.init(navigationController: UINavigationController())
        coordinator.menuItemModel = self.menuItems?[indexPath.row]
        coordinator.cartModel = cartItems
        coordinator.didAddToCart = { model in
//            UserDefaults.standard.set(model?.cart?.id, forKey: model?.cart?.chefId ?? "")
            self.viewModel.fetchCarts()
//            self.viewModel.fetchCarts(model?.cart?.id ?? "")
        }
        self.present(coordinator.getMainView(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}
