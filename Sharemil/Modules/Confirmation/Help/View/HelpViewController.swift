//
//  HelpViewController.swift
//  Sharemil
//
//  Created by Lizan on 05/10/2022.
//

import UIKit

class HelpViewController: UIViewController, Storyboarded {

    @IBOutlet weak var issueOption: UIView!
    @IBOutlet weak var missingView: UIView!
    @IBOutlet weak var chefName: UILabel!
    
    var cart: Cart?
    var orderId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setData()
    }
    
    private func setData() {
        self.chefName.text = "\(cart?.chef?.firsName ?? "") \(cart?.chef?.lastName ?? "")"
    }
    
    private func setup() {
        self.missingView.isUserInteractionEnabled = true
        self.missingView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openMissing)))
        self.issueOption.isUserInteractionEnabled = true
        self.issueOption.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openIssue)))
    }
    
    @objc func openMissing() {
        let coordinator = HelpIssueCoordinator.init(navigationController: UINavigationController())
        coordinator.cart = self.cart
        coordinator.type = "missing"
        coordinator.orderId = orderId
        self.present(coordinator.getMainView(), animated: true)
    }
    
    @objc func openIssue() {
        let coordinator = HelpIssueCoordinator.init(navigationController: UINavigationController())
        coordinator.cart = self.cart
        coordinator.orderId = orderId
        coordinator.type = "item_quality"
        self.present(coordinator.getMainView(), animated: true)
    }

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
