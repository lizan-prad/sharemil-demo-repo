//
//  HelpCoordinator.swift
//  Sharemil
//
//  Created by Lizan on 06/10/2022.
//

import UIKit

class HelpCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var cart: Cart?
    var orderId: String?
    
    func getMainView() -> HelpViewController {
        let vc = HelpViewController.instantiate()
        vc.cart = cart
        vc.orderId = orderId
        return vc
    }
    
    func start() {
        
    }

    
}
