//
//  CheckoutViewController.swift
//  Sharemil
//
//  Created by lizan on 24/06/2022.
//

import UIKit
import GoogleMaps

class CheckoutViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: CheckoutViewModel!
    
    var polylines: [GMSPath]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var cartItems: [CartItems]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setTableView()
        self.viewModel.getRoute(CLLocationCoordinate2D.init(), destination: CLLocationCoordinate2D.init())
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib.init(nibName: "CheckoutMapTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckoutMapTableViewCell")
        tableView.register(UINib.init(nibName: "CheckoutOrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckoutOrdersTableViewCell")
        
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

extension CheckoutViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutMapTableViewCell") as! CheckoutMapTableViewCell
            cell.setup()
            cell.polylines = self.polylines
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutOrdersTableViewCell") as! CheckoutOrdersTableViewCell
            cell.setTable()
            cell.setup()
            cell.cartItems = self.cartItems
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 305
        case 1:
            return UITableView.automaticDimension
        default: return 0
        }
    }
    
}
