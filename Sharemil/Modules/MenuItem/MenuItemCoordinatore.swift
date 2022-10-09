//
//  MenuItemCoordinatore.swift
//  Sharemil
//
//  Created by lizan on 22/06/2022.
//
import UIKit

class MenuItemCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
   
    var menuItemModel: ChefMenuListModel?
    var didAddToCart: ((CartListModel?) -> ())?
    var cartModel: [CartItems]?
    var isUpdate = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func getMainView() -> ChefMenuItemViewController {
        let vc = ChefMenuItemViewController.instantiate()
        let viewModel = MenuItemViewModel()
        viewModel.menuItemModel = self.menuItemModel
        vc.viewModel = viewModel
        vc.cartModel = cartModel
        vc.didAddToCart = self.didAddToCart
        vc.isUpdate = self.isUpdate
        return vc
    }
    
    func start() {
        let vc = ChefMenuItemViewController.instantiate()
        let viewModel = MenuItemViewModel()
        viewModel.menuItemModel = self.menuItemModel
        vc.viewModel = viewModel
        vc.cartModel = cartModel
        vc.isUpdate = self.isUpdate
        vc.didAddToCart = self.didAddToCart
        navigationController.pushViewController(vc, animated: true)
    }

    
}
