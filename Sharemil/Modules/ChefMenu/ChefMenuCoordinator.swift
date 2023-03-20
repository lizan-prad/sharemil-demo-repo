//
//  ChefMenuCoordinator.swift
//  Sharemil
//
//  Created by lizan on 19/06/2022.
//
import UIKit

class ChefMenuCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    var chef: ChefListModel?
    var cusine: CusineListModel?
    var isFromCheckout = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func getMainView() -> ChefMenuViewController {
        let vc = ChefMenuViewController.instantiate()
        let viewModel = ChefMenuViewModel()
        viewModel.chef = self.chef
        vc.viewModel = viewModel
        vc.cusine = self.cusine
        vc.isFromCheckout = isFromCheckout
        return vc
    }
    
    func start() {
        let vc = ChefMenuViewController.instantiate()
        let viewModel = ChefMenuViewModel()
        viewModel.chef = self.chef
        vc.viewModel = viewModel
        vc.cusine = self.cusine
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    
}
