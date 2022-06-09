//
//  RegistrationCoordinator.swift
//  Sharemil
//
//  Created by Macbook Pro on 09/06/2022.
//

import UIKit

class RegistrationCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = RegistrationViewController.instantiate()
        navigationController.pushViewController(vc, animated: true)
    }
}
