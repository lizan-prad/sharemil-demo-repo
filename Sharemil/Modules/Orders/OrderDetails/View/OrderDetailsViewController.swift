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

    @IBOutlet weak var tableView: UITableView!
   
    var viewModel: OrderDetailsViewModel!
    
    var polylines: [GMSPath]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var model: OrderModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewModel.getRoute(CLLocationCoordinate2D.init(), destination: CLLocationCoordinate2D.init())
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib.init(nibName: "OrderDetailMapTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailMapTableViewCell")
        tableView.register(UINib.init(nibName: "OrderDetailSummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailSummaryTableViewCell")
        
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
            cell.setup()
            cell.model = self.model
            cell.polylines = self.polylines
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailSummaryTableViewCell") as! OrderDetailSummaryTableViewCell
            cell.setTable()
            cell.cartItems = self.model?.cart?.cartItems
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
