//
//  BaseTabbarCoordinator.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit

class BaseTabbarCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {}

    func getMainView() -> BaseTabbarViewController {
        let vc = BaseTabbarViewController.instantiate()
        vc.viewModel = TabbarControllerViewModel()
        return vc
    }
}
