//
//  PickUpCoordinator.swift
//  Sharemil
//
//  Created by Lizan on 18/01/2023.
//
import UIKit

class PickUpCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var didDismiss: (() -> ())?
    var orderId: String?
    
    func getMainView() -> PickUpViewController {
        let vc = PickUpViewController.instantiate()
        let viewModel = PickUpViewModel()
        vc.viewModel = viewModel
        vc.orderId = self.orderId
        vc.didDismiss = self.didDismiss
        return vc
    }
    
    func start() {
        let vc = CartDetailViewController.instantiate()
        let viewModel = CartDetailViewModel()
        vc.viewModel = viewModel
        
//        vc.menuItems = menuItems
        navigationController.pushViewController(vc, animated: true)
    }

    
}
