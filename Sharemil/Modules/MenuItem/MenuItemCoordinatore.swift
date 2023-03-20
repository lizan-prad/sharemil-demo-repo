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
    var didAddToCart: ((String?) -> ())?
    var cartModel: [CartItems]?
    var selectedItem: CartItems?
    var isUpdate = false
    var updateItem = false
    
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
        vc.selectedItem = self.selectedItem
        vc.isUpdate = self.isUpdate
        vc.updateItem = self.updateItem
        return vc
    }
    
    func start() {
        let vc = ChefMenuItemViewController.instantiate()
        let viewModel = MenuItemViewModel()
        viewModel.menuItemModel = self.menuItemModel
        vc.viewModel = viewModel
        vc.cartModel = cartModel
        vc.isUpdate = self.isUpdate
        vc.selectedItem = self.selectedItem
        vc.didAddToCart = self.didAddToCart
        vc.updateItem = self.updateItem
        navigationController.pushViewController(vc, animated: true)
    }

    
}
