//
//  CartDetailViewController.swift
//  Sharemil
//
//  Created by lizan on 23/06/2022.
//

import UIKit

class CartDetailViewController: UIViewController, Storyboarded {

    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chefTitle: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var smoke: UIView!
    
    var viewModel: CartDetailViewModel!
    
    var dummy: [ChefMenuListModel]?
    var chef: ChefListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setTable()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.smoke.alpha = 0
        self.fogActivate()
        self.chefTitle.text = "\(chef?.firsName ?? "") \(chef?.lastName ?? "")"
    }
    
    private func setupGestures() {
        smoke.isUserInteractionEnabled = true
        smoke.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissPopUp)))
    }
    
    private func setup() {
        container.addCornerRadius(15)
        self.subTotal.text = "$\(dummy?.compactMap({$0.price}).reduce(0, +) ?? 0)"
    }
    
    private func setTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableViewHeight.constant = CGFloat((dummy?.count ?? 0)*65) + 65
        tableView.register(UINib.init(nibName: "CartDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CartDetailTableViewCell")
    }

    
    private func fogActivate() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear, animations: {
            self.smoke.alpha = 0.4
            
        }, completion: { _ in
            
        })
    }
    
    @objc private func dismissPopUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.smoke.alpha = 0.0
            
        }, completion: { _ in
            self.dismiss(animated: true)
        })
        
    }

    @IBAction func checkoutAction(_ sender: Any) {
        
    }
}

extension CartDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummy?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartDetailTableViewCell") as! CartDetailTableViewCell
        cell.model = self.dummy?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
