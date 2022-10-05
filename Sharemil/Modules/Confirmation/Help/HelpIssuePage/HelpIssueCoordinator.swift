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
    
    func getMainView() -> HelpIssuePageViewController {
        let vc = HelpIssuePageViewController.instantiate()
        vc.cart = cart
        return vc
    }
    
    func start() {
        let vc = HelpIssuePageViewController.instantiate()
        vc.cart = cart
        navigationController.pushViewController(vc, animated: true)
    }

    
}
