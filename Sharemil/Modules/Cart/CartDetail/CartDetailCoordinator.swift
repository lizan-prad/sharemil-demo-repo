//
//  CartDetailCoordinator.swift
//  Sharemil
//
//  Created by lizan on 23/06/2022.
//

import UIKit

class CartDetailCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var didCheckout: (() -> ())?
    var cartItems: [ChefMenuListModel]?
    var chef: ChefListModel?
    
    func getMainView() -> CartDetailViewController {
        let vc = CartDetailViewController.instantiate()
        let viewModel = CartDetailViewModel()
        vc.viewModel = viewModel
        vc.dummy = cartItems
        vc.chef = chef
        vc.didSelectCheckout = self.didCheckout
        return vc
    }
    
    func start() {
        let vc = CartDetailViewController.instantiate()
        let viewModel = CartDetailViewModel()
        vc.viewModel = viewModel
        vc.dummy = cartItems
        navigationController.pushViewController(vc, animated: true)
    }

    
}
