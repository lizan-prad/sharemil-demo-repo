//
//  OrderDetailSummaryTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 13/07/2022.
//

import UIKit

class OrderDetailSummaryTableViewCell: UITableViewCell {

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
    
        tableView.register(UINib.init(nibName: "OrderSummaryListTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderSummaryListTableViewCell")
        let val = cartItems?.compactMap({ item in
            let opt = item.options?.map({$0.choices?.map({$0.price ?? 0}).reduce(0, +) ?? 0})
            let options = opt?.reduce(0,+) ?? 0
            return Double(item.quantity ?? 0)*((item.menuItem?.price ?? 0) + options)
        })
        let totalPrice = val?.reduce(0, +) ?? 0
        
        total.text = "$" + (totalPrice).withDecimal(2)
    }
}

extension OrderDetailSummaryTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryListTableViewCell") as! OrderSummaryListTableViewCell
        cell.item = self.cartItems?[indexPath.row]
        cell.separator.isHidden = (indexPath.row + 1) == self.cartItems?.count
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
