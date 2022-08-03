//
//  OrdersViewController.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit
import FirebaseFirestore

class OrdersViewController: UIViewController, Storyboarded{
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: OrdersViewModel!
    
    var orders: [OrderModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OrdersViewModel()
        bindViewModel()
        setTableView()
        self.viewModel.fetchOrders()
        self.getOrderStatusUpdate()
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.orders.bind { orders in
            self.orders = orders
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Orders"
        navigationController?.navigationBar.prefersLargeTitles = true
  
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.register(UINib.init(nibName: "OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersTableViewCell")
        tableView.register(UINib.init(nibName: "OrdersHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersHeaderTableViewCell")
    }
    
    func getOrderStatusUpdate() {
        db.collection("orders").document("SF")
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
              print("Current data: \(data)")
            }
    }
    
    
}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell") as! OrdersTableViewCell
        cell.setup()
        cell.model = self.orders?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nav = self.navigationController else {return}
        let coordinator = OrderDetailCoordinator.init(navigationController: nav)
        coordinator.model = self.orders?[indexPath.row]
        self.present(coordinator.getMainView(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersHeaderTableViewCell") as! OrdersHeaderTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}
