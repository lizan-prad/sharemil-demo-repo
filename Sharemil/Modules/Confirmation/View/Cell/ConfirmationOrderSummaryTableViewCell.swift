//
//  ConfirmationOrderSummaryTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 26/07/2022.
//

import UIKit

class ConfirmationOrderSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var fee: UILabel!
    @IBOutlet weak var tip: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var model: OrderModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    func setTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableViewHeight.constant = CGFloat((model?.cart?.cartItems?.count ?? 0)*65)
    
        tableView.register(UINib.init(nibName: "ConfirmationSummaryListTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfirmationSummaryListTableViewCell")
        
        subTotal.text = "$" + (model?.subTotal ?? 0).withDecimal(2)
        tax.text = "$" + (model?.tax ?? 0).withDecimal(2)
        tip.text = "$" + (model?.tip ?? 0).withDecimal(2)
        fee.text = "$" + (model?.fee ?? 0).withDecimal(2)
        total.text = "$" + (model?.total ?? 0).withDecimal(2)
    }
}

extension ConfirmationOrderSummaryTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.cart?.cartItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmationSummaryListTableViewCell") as! ConfirmationSummaryListTableViewCell
        cell.item = self.model?.cart?.cartItems?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

}
