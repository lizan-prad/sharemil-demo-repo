//
//  HelpIssuePageViewController.swift
//  Sharemil
//
//  Created by Lizan on 05/10/2022.
//

import UIKit

class HelpIssuePageViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detailsTextView: UITextView!
    var cart: Cart?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setup() {
        self.detailsTextView.addCornerRadius(16)
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "HelpIssueFoodListTableViewCell", bundle: nil), forCellReuseIdentifier: "HelpIssueFoodListTableViewCell")
        tableViewHeight.constant = CGFloat(cart?.cartItems?.count ?? 0)*53
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension HelpIssuePageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart?.cartItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpIssueFoodListTableViewCell") as! HelpIssueFoodListTableViewCell
        cell.menuItem = cart?.cartItems?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coordinator = HelpItemIssueListCoordinator.init(navigationController: UINavigationController())
        coordinator.categoryType = "item_quality"
        coordinator.didSelectIssue = { issue in
            
        }
        self.present(coordinator.getMainView(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
}
