//
//  EditAccountCoordinator.swift
//  Sharemil
//
//  Created by Lizan on 06/07/2022.
//

import UIKit

class EditAccountCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func getMainView() -> EditAccountViewController {
        let vc = EditAccountViewController.instantiate()
        let viewModel = EditAccountViewModel()
        vc.viewModel = viewModel
        return vc
    }
    
    func start() {
        let vc = EditAccountViewController.instantiate()
        let viewModel = EditAccountViewModel()
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }

    
}
