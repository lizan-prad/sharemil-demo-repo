//
//  OrderDetailsViewController.swift
//  Sharemil
//
//  Created by Lizan on 13/07/2022.
//

import UIKit
import CoreLocation
import GoogleMaps

class OrderDetailsViewController: UIViewController, Storyboarded {

    @IBOutlet weak var trackOrder: UIButton!
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var tableView: UITableView!
   
    var viewModel: OrderDetailsViewModel!
    
    var model: OrderModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        bindViewModel()
        setup()
    }
    
    private func setup() {
        self.orderNo.text = "Order #\(model?.orderNumber ?? 0)"
        self.trackOrder.isHidden = model?.status == "COMPLETED"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "OrderDetailMapTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailMapTableViewCell")
        tableView.register(UINib.init(nibName: "OrderDetailSummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailSummaryTableViewCell")
        
    }
    
    @IBAction func trackAction(_ sender: Any) {
        let coordinator = ConfirmationCoordinator.init(navigationController: UINavigationController())
        coordinator.orderId = self.model?.id
        coordinator.location = loc
        self.present(coordinator.getMainView(), animated: true)
    }
    
    @IBAction func helpNavAction(_ sender: Any) {
        let coordinator = HelpCoordinator.init(navigationController: UINavigationController())
        coordinator.cart = self.model?.cart
        coordinator.orderId = "\(self.model?.orderNumber ?? 0)"
        self.present(coordinator.getMainView(), animated: true)
    }
    
    @IBAction func getHelpAction(_ sender: Any) {
        let coordinator = RecieptWebViewCoordinator.init(navigationController: UINavigationController())
        coordinator.recipetUrl = self.model?.receiptUrl
        self.present(coordinator.getMainView(), animated: true)
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension OrderDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailMapTableViewCell") as! OrderDetailMapTableViewCell
            cell.model = self.model
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailSummaryTableViewCell") as! OrderDetailSummaryTableViewCell
            cell.cartItems = self.model?.cart?.cartItems
            cell.setTable()
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return UITableView.automaticDimension
        default: return 0
        }
    }
    
}
