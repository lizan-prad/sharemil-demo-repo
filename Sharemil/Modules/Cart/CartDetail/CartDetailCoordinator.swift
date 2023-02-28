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
    
    var didCheckout: ((ChefListModel?) -> ())?
    var didUpdate: (() -> ())?
    var cartItems: [CartItems]?
    var menuItems: [ChefMenuListModel]?
    var chef: ChefListModel?
    
    func getMainView() -> CartDetailViewController {
        let vc = CartDetailViewController.instantiate()
        let viewModel = CartDetailViewModel()
        vc.viewModel = viewModel
        vc.cartItems = cartItems
        vc.chef = chef
        vc.didUpdate = self.didUpdate
//        vc.menuItems = menuItems
        vc.didSelectCheckout = self.didCheckout
        return vc
    }
    
    func start() {
        let vc = CartDetailViewController.instantiate()
        let viewModel = CartDetailViewModel()
        vc.viewModel = viewModel
        vc.cartItems = cartItems
//        vc.menuItems = menuItems
        navigationController.pushViewController(vc, animated: true)
    }

    
}
