//
//  ConfirmationViewController.swift
//  Sharemil
//
//  Created by Lizan on 14/07/2022.
//

import UIKit
import GoogleMaps

class ConfirmationViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var orderStatusTitle: UILabel!
    @IBOutlet weak var readyView: UIView!
    @IBOutlet weak var cookingView: UIView!
    @IBOutlet weak var processingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ConfirmationViewModel!
    
    var polylines: [GMSPath]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var id: String?
    var location: LLocation?
    
    var model: OrderModel? {
        didSet {
            switch model?.status?.lowercased() ?? "" {
            case "accepted":
                self.orderStatusTitle.text = "Preparing your order..."
                self.processingView.backgroundColor = UIColor.init(hex: "6A9962")
                
                self.cookingView.backgroundColor = UIColor.init(hex: "EAEAEA")
                self.readyView.backgroundColor = UIColor.init(hex: "EAEAEA")
            case "processing":
                self.orderStatusTitle.text = "Your order is being cooked..."
                self.processingView.backgroundColor = UIColor.init(hex: "6A9962")
                self.cookingView.backgroundColor = UIColor.init(hex: "6A9962")
                self.readyView.backgroundColor = UIColor.init(hex: "EAEAEA")
            case "ready":
                self.orderStatusTitle.text = "Your order is ready..."
                self.processingView.backgroundColor = UIColor.init(hex: "6A9962")
                self.cookingView.backgroundColor = UIColor.init(hex: "6A9962")
                self.readyView.backgroundColor = UIColor.init(hex: "6A9962")
            default: break
            }
            self.viewModel.getRoute(location?.location?.coordinate ?? CLLocationCoordinate2D.init(), destination: CLLocationCoordinate2D.init(latitude: model?.cart?.chef?.latitude ?? 0, longitude: model?.cart?.chef?.longitude ?? 0))
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewModel.getOrder(id ?? "")
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib.init(nibName: "ConfirmationDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfirmationDetailTableViewCell")
        tableView.register(UINib.init(nibName: "ConfirmationOrderSummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfirmationOrderSummaryTableViewCell")
        
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
        self.viewModel.order.bind { order in
            self.model = order
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension ConfirmationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmationDetailTableViewCell") as! ConfirmationDetailTableViewCell
            cell.setup()
            cell.model = self.model
            cell.chef = self.model?.cart?.chef
            cell.polylines = self.polylines
            cell.didTapDirection = {
                let coordinator = ShowDirectionCoordinator.init(navigationController: UINavigationController())
                self.present(coordinator.getMainView(), animated: true)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmationOrderSummaryTableViewCell") as! ConfirmationOrderSummaryTableViewCell
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
