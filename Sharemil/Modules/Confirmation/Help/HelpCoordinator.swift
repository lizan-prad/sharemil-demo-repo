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
    
    func getMainView() -> HelpViewController {
        let vc = HelpViewController.instantiate()
        vc.cart = cart
        return vc
    }
    
    func start() {
        
    }

    
}
