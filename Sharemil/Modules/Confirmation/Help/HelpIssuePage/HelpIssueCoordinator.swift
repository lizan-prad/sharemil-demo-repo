//
//  HelpIssueCoordinator.swift
//  Sharemil
//
//  Created by Lizan on 06/10/2022.
//

import UIKit

class HelpIssueCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var cart: Cart?
    var orderId: String?
    var type: String?
    var order: String?
    
    func getMainView() -> HelpIssuePageViewController {
        let vc = HelpIssuePageViewController.instantiate()
        vc.cart = cart
        vc.type = self.type
        vc.orderId = orderId
        vc.viewModel = HelpIssuePageViewModel()
        vc.order = self.order
        return vc
    }
    
    func start() {
        let vc = HelpIssuePageViewController.instantiate()
        vc.cart = cart
        vc.orderId = orderId
        vc.type = self.type
        vc.order = self.order
        vc.viewModel = HelpIssuePageViewModel()
        navigationController.pushViewController(vc, animated: true)
    }

    
}
