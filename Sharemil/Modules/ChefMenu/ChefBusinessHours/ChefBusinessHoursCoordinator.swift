//
//  ChefBusinessHoursCoordinator.swift
//  Sharemil
//
//  Created by Lizan on 13/12/2022.
//

import UIKit

class ChefBusinessHoursCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    var chef: ChefListModel?
   
    
    func start() {
        let vc = ChefBusinessHoursViewController.instantiate()
        let viewModel = ChefBusinessHoursViewModel()
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func getMainView() -> ChefBusinessHoursViewController {
        let vc = ChefBusinessHoursViewController.instantiate()
        let viewModel = ChefBusinessHoursViewModel()
        vc.viewModel = viewModel
        vc.chef = self.chef
        return vc
    }

    
}
