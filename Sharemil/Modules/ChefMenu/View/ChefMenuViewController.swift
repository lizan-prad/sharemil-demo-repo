//
//  ChefMenuViewController.swift
//  Sharemil
//
//  Created by lizan on 19/06/2022.
//

import UIKit
import FirebaseAuth

class ChefMenuViewController: UIViewController, Storyboarded {

    @IBOutlet weak var businessHoursTap: UILabel!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var tableviewBottomView: UIView!
    @IBOutlet weak var viewCartBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chefTime: UILabel!
    @IBOutlet weak var chefRating: UILabel!
    @IBOutlet weak var chefNameLabel: UILabel!
    
    var viewModel: ChefMenuViewModel!
    
    var isFromCheckout = false
    
    var menuItems: [ChefMenuListModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var cusine: CusineListModel?
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewModel.fetchChefMenu()
        self.viewModel.fetchCarts()
    }
    
    private func start() {
        self.showProgressHud()
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { token, error in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                UserDefaults.standard.set(token, forKey: StringConstants.userIDToken)
                self.viewModel.fetchChefMenu()
                self.viewModel.fetchCarts()
            }
        })
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.start()
        }
        self.viewModel.menuItems.bind { models in
            self.menuItems = models
        }
        self.viewModel.cartList.bind { cartItems in
            self.cartItems = cartItems
            self.tableviewBottomView.isHidden = cartItems?.isEmpty ?? true
            self.addToCartView.isHidden = cartItems?.isEmpty ?? true
            self.viewCartBtn.isHidden = cartItems?.isEmpty ?? true
            let count = (cartItems?.map({$0.quantity ?? 0}).reduce(0,+) ?? 0)
            self.viewCartBtn.setTitle("View cart (\(count))", for: .normal)
        }
    }
    
    @IBAction func viewCartAction(_ sender: Any) {
        if self.viewModel.chef?.isOpen == false {
            self.showToastMsg("The restaurant is closed. Please make your order when its open.", state: .info, location: .bottom)
        } else {
            let coordinator = CartDetailCoordinator.init(navigationController: UINavigationController())
            coordinator.cartItems = self.cartItems
            coordinator.menuItems = self.menuItems?.filter({self.cartItems?.map({$0.menuItemId ?? ""}).contains($0.id ?? "") ?? false})
            coordinator.chef = self.viewModel.chef
            coordinator.didUpdate = {
                self.viewModel.fetchCarts()
                self.viewModel.fetchChefMenu()
            }
            coordinator.didCheckout = { chef in
                let coordinator = CheckoutCoordinator.init(navigationController: UINavigationController())
                coordinator.cartList = self.cartItems
                coordinator.chef = chef
                coordinator.didCheckoutComplete = {
                    self.navigationController?.popViewController(animated: true)
                }
                let nav = UINavigationController.init(rootViewController: coordinator.getMainView())
                nav.modalPresentationStyle = .overFullScreen
                self.present(nav, animated: true)
            }
            self.present(coordinator.getMainView(), animated: true)
        }
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
    
    @objc func openBusinessHours() {
        let coordinator = ChefBusinessHoursCoordinator.init(navigationController: UINavigationController())
        coordinator.chef = self.viewModel.chef
        self.present(coordinator.getMainView(), animated: true)
    }
    
    private func setupData() {
        businessHoursTap.isUserInteractionEnabled = true
        businessHoursTap.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openBusinessHours)))
        
        chefNameLabel.text = "\(viewModel.chef?.firsName ?? "") \(viewModel.chef?.lastName ?? "")"
        self.businessName.text = viewModel.chef?.businessName
        
        self.viewCartBtn.isHidden = self.isFromCheckout
        let formatter = DateFormatter()
        formatter.dateFormat = "eee"
        let now = formatter.string(from: Date()).lowercased()
        let hour = viewModel.chef?.hours?.filter({($0.day?.lowercased() ?? "") == now.prefix(3)}).first
        formatter.dateFormat = "HH:mm:ss"
        let nowStrDate = formatter.string(from: Date())
        let nowDate = formatter.date(from: nowStrDate)
        let date = formatter.date(from: hour?.endTime ?? "")
        let sdate = formatter.date(from: hour?.startTime ?? "")
        formatter.dateFormat = "hh:mm a"
        
        if ((sdate ?? Date()) > (date ?? Date())) {
            if ((date ?? Date())...(sdate ?? Date())).contains(nowDate ?? Date()) {
                chefTime.text = "Open until \(formatter.string(from: date ?? Date()))"
            } else if date == nil {
                chefTime.text = "Closed"
            } else {
                chefTime.text = "Opens at \(formatter.string(from: sdate ?? Date()))"
            }
        } else {
            if ((sdate ?? Date())...(date ?? Date())).contains(nowDate ?? Date()) {
                chefTime.text = "Open until \(formatter.string(from: date ?? Date()))"
            } else if date == nil {
                chefTime.text = "Closed"
            } else {
                chefTime.text = "Opens at \(formatter.string(from: sdate ?? Date()))"
            }
        }
        self.chefRating.text = "★ 4.8 (500+ rating) · \(self.cusine?.name ?? "") · $$"
    }

}

extension ChefMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChefMenuTableViewCell") as! ChefMenuTableViewCell
        cell.model = self.menuItems?[indexPath.row]
        cell.quantity.text = "\(self.cartItems?.filter({$0.menuItemId == self.menuItems?[indexPath.row].id}).map({$0.quantity ?? 0}).reduce(0, +) ?? 0)"
        cell.quantityContainer.isHidden = self.cartItems?.filter({$0.menuItemId == self.menuItems?[indexPath.row].id}).isEmpty ?? true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.chef?.isOpen == false {
            self.showToastMsg("The restaurant is closed. Please make your order when its open.", state: .info, location: .bottom)
        } else {
            let coordinator = MenuItemCoordinator.init(navigationController: UINavigationController())
            coordinator.menuItemModel = self.menuItems?[indexPath.row]
            coordinator.cartModel = cartItems
            coordinator.didAddToCart = { model in
                NotificationCenter.default.post(name: Notification.Name.init(rawValue: "CARTBADGE"), object: nil)
                //            UserDefaults.standard.set(model?.cart?.id, forKey: model?.cart?.chefId ?? "")
                self.viewModel.fetchCarts()
                //            self.viewModel.fetchCarts(model?.cart?.id ?? "")
            }
            self.present(coordinator.getMainView(), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}
