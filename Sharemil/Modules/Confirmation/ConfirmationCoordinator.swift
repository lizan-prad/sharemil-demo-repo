//
//  ConfirmationCoordinator.swift
//  Sharemil
//
//  Created by Lizan on 14/07/2022.
//
import UIKit

class ConfirmationCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    var model: OrderModel?
    
    
    func getMainView() -> ConfirmationViewController {
        let vc = ConfirmationViewController.instantiate()
        let viewModel = ConfirmationViewModel()
        vc.viewModel = viewModel
        vc.model = model

        return vc
    }
    
    func start() {
        let vc = ConfirmationViewController.instantiate()
        let viewModel = ConfirmationViewModel()
        vc.viewModel = viewModel
        
        navigationController.pushViewController(vc, animated: true)
    }

    
}
