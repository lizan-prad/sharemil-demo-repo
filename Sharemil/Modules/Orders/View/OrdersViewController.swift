//
//  OrdersViewController.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit
 import FirebaseFirestore
import FirebaseAuth

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
        self.getOrderStatusUpdate()
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
//            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
            self.start()
        }
        self.viewModel.orders.bind { orders in
            self.orders = orders?.sorted(by: { a, b in
               
                return (a.orderNumber ?? 0) > (b.orderNumber ?? 0)
            })
        }
    }
    
    private func start() {
        self.showProgressHud()
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { token, error in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                UserDefaults.standard.set(token, forKey: StringConstants.userIDToken)
                self.viewModel.fetchOrders()
            }
        })
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Orders"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.viewModel.fetchOrders()
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
        db.collection("orders").whereField("userId", isEqualTo: "\(UserDefaults.standard.string(forKey: "UID") ?? "")")
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        print("New city: \(diff.document.data())")
                    }
                    if (diff.type == .modified) {
                        guard let status = diff.document.data()["status"] as? String else {return}
                        self.viewModel.fetchOrders()
                        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "CARTBADGE"), object: nil)
                        self.setNotification(date: Date().addingTimeInterval(40), title: "Order Status", body: "Your order is \(status)", id: "")
                    }
                    if (diff.type == .removed) {
                        print("Removed city: \(diff.document.data())")
                    }
                }
                
            }
    }
    
    func setNotification(date: Date, title: String, body: String, id: String) {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            if #available(iOS 15.0, *) {
                content.interruptionLevel = .critical
            } else {
                // Fallback on earlier versions
            }
            content.userInfo = ["id": id]
            content.sound = UNNotificationSound.defaultCritical
            let dateComponents = Calendar.current.dateComponents([.year, .day, .month,.hour, .minute], from: date)
            
            // Create the trigger as a repeating event.
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents, repeats: false)
            
            let uuidString = id
            let request = UNNotificationRequest(identifier: uuidString,
                                                content: content, trigger: trigger)
            
            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
                print(error?.localizedDescription)
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
        cell.didSelectReorder = { model in
            guard let nav = self.navigationController else {return}
            let coordinator = ChefMenuCoordinator.init(navigationController: nav)
            coordinator.chef = model
            coordinator.start()
        }
        cell.didPickUp = { orderId in
            guard let nav = self.navigationController else {return}
            let coordinator = PickUpCoordinator.init(navigationController: nav)
            coordinator.orderId = orderId
            coordinator.didDismiss = {
                self.viewModel.fetchOrders()
            }
            self.present(coordinator.getMainView(), animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
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
