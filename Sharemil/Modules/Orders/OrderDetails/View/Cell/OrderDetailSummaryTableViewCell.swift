//
//  OrderDetailSummaryTableViewCell.swift
//  Sharemil
//
//  Created by Lizan on 13/07/2022.
//

import UIKit

class OrderDetailSummaryTableViewCell: UITableViewCell {

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
        tableViewHeight.constant = CGFloat((model?.cart?.cartItems?.count ?? 0)*85)
    
        tableView.register(UINib.init(nibName: "OrderSummaryListTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderSummaryListTableViewCell")
//        let val = cartItems?.compactMap({ item in
//            let opt = item.options?.map({ a in
//                var b = a.choices?.map({ m in
//                    return ((m.price ?? 0)*Double(m.quantity ?? 0))
//                })
//                return b?.reduce(0, +) ?? 0
//            })
//            let options = opt?.reduce(0,+) ?? 0
//            return Double(item.quantity ?? 0)*((item.menuItem?.price ?? 0) + options)
//        })
      
        subTotal.text = "$" + (model?.subTotal ?? 0).withDecimal(2)
        tax.text = "$" + (model?.tax ?? 0).withDecimal(2)
        fee.text = "$" + (model?.fee ?? 0).withDecimal(2)
        tip.text = "$" + (model?.tip ?? 0).withDecimal(2)
        total.text = "$" + (model?.total ?? 0).withDecimal(2)
    }
}

extension OrderDetailSummaryTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.cart?.cartItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryListTableViewCell") as! OrderSummaryListTableViewCell
        cell.item = self.model?.cart?.cartItems?[indexPath.row]
        cell.separator.isHidden = (indexPath.row + 1) == self.model?.cart?.cartItems?.count
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
