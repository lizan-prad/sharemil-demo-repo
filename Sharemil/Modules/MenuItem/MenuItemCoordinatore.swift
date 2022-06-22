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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func getMainView() -> ChefMenuItemViewController {
        let vc = ChefMenuItemViewController.instantiate()
        let viewModel = MenuItemViewModel()
        viewModel.menuItemModel = self.menuItemModel
        vc.viewModel = viewModel
        return vc
    }
    
    func start() {
        let vc = ChefMenuItemViewController.instantiate()
        let viewModel = MenuItemViewModel()
        viewModel.menuItemModel = self.menuItemModel
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }

    
}
