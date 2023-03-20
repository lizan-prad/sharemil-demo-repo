//
//  CustomStripeCoordinator.swift
//  Sharemil
//
//  Created by Lizan on 17/07/2022.
//

import UIKit

class CustomStripeCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    var chef: ChefListModel?
    var cartList: [CartItems]?
    
    func start() {
        let vc = CustomStripeViewController.instantiate()
        let viewModel = CustomStripeViewModel()
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func getMainView() -> CustomStripeViewController {
        let vc = CustomStripeViewController.instantiate()
        let viewModel = CustomStripeViewModel()
        vc.viewModel = viewModel
        return vc
    }

    
}
