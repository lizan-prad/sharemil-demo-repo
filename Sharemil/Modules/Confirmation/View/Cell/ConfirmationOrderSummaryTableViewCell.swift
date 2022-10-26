//
//  ConfirmationOrderSummaryTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 26/07/2022.
//

import UIKit

class ConfirmationOrderSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var cartItems: [CartItems]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    func setTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableViewHeight.constant = CGFloat((cartItems?.count ?? 0)*65)
    
        tableView.register(UINib.init(nibName: "ConfirmationSummaryListTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfirmationSummaryListTableViewCell")
        let totalPrice = cartItems?.map({ c in
            return (c.menuItem?.price ?? 0)*Double(c.quantity ?? 0)
        }).reduce(0, +)
        total.text = "$" + (totalPrice ?? 0).withDecimal(2)
    }
}

extension ConfirmationOrderSummaryTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmationSummaryListTableViewCell") as! ConfirmationSummaryListTableViewCell
        cell.item = self.cartItems?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

}
