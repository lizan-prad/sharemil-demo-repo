//
//  ChefMenuViewController.swift
//  Sharemil
//
//  Created by lizan on 19/06/2022.
//

import UIKit

class ChefMenuViewController: UIViewController, Storyboarded {

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
    }
    
    @IBAction func viewCartAction(_ sender: Any) {
        let coordinator = CartDetailCoordinator.init(navigationController: UINavigationController())
        coordinator.cartItems = self.menuItems
        coordinator.chef = self.viewModel.chef
        self.present(coordinator.getMainView(), animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "ChefMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "ChefMenuTableViewCell")
        
    }
    
    private func setupData() {
        chefNameLabel.text = "\(viewModel.chef?.firsName ?? "") \(viewModel.chef?.lastName ?? "")"
    }

}

extension ChefMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChefMenuTableViewCell") as! ChefMenuTableViewCell
        cell.model = self.menuItems?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coordinator = MenuItemCoordinator.init(navigationController: UINavigationController())
        coordinator.menuItemModel = self.menuItems?[indexPath.row]
        self.present(coordinator.getMainView(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}
