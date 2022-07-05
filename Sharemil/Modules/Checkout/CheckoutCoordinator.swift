//
//  CheckoutCoordinator.swift
//  Sharemil
//
//  Created by lizan on 24/06/2022.
//

import UIKit

class CheckoutCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    var chef: ChefListModel?
    var cartList: [CartItems]?
    
    func start() {
        let vc = CheckoutViewController.instantiate()
        let viewModel = CheckoutViewModel()
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func getMainView() -> CheckoutViewController {
        let vc = CheckoutViewController.instantiate()
        let viewModel = CheckoutViewModel()
        vc.cartItems = self.cartList
        vc.chef = self.chef
        vc.viewModel = viewModel
        return vc
    }

    
}
