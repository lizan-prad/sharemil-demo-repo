//
//  RecieptWebViewCoordinator.swift
//  Sharemil
//
//  Created by Lizan on 03/12/2022.
//

import UIKit

class RecieptWebViewCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var recipetUrl: String?
    
    func getMainView() -> RecieptWebViewViewController {
        let vc = RecieptWebViewViewController.instantiate()
        vc.recieptUrl = self.recipetUrl
        return vc
    }
    
    func start() {
        let vc = EditAccountViewController.instantiate()
        let viewModel = EditAccountViewModel()
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }

    
}
