//
//  OrderDetailsCoordinator.swift
//  Sharemil
//
//  Created by Lizan on 13/07/2022.
//
import UIKit

class OrderDetailCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var model: OrderModel?
    
    func getMainView() -> OrderDetailsViewController {
        let vc = OrderDetailsViewController.instantiate()
        let viewModel = OrderDetailsViewModel()
        vc.viewModel = viewModel
        vc.model = model
        return vc
    }
    
    func start() {
        let vc = OrderDetailsViewController.instantiate()
        let viewModel = OrderDetailsViewModel()
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }

    
}
