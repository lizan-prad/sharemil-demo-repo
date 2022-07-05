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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func getMainView() -> ChefMenuViewController {
        let vc = ChefMenuViewController.instantiate()
        let viewModel = ChefMenuViewModel()
        viewModel.chef = self.chef
        vc.viewModel = viewModel
        return vc
    }
    
    func start() {
        let vc = ChefMenuViewController.instantiate()
        let viewModel = ChefMenuViewModel()
        viewModel.chef = self.chef
        vc.viewModel = viewModel
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    
}
