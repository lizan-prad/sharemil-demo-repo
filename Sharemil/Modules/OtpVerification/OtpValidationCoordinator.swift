//
//  OtpValidationCoordinator.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit

class OtpVerificationCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    var phoneNumber: String?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = OtpVerificationViewController.instantiate()
        let viewModel = OtpVerificationViewModel()
        viewModel.phoneNumber = self.phoneNumber
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}

