//
//  PaymentOptionsCoordinator.swift
//  Sharemil
//
//  Created by lizan on 01/07/2022.
//

import UIKit

class PaymentOptionsCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var didSelectMethod: ((PaymentMethods?) -> ())?
    var cartId: String?
    
    func start() {
        let vc = PaymentOptionsViewController.instantiate()
        let viewModel = PaymentOptionsViewModel()
        vc.viewModel = viewModel
        vc.cartId = self.cartId
        vc.didSelectMethod = self.didSelectMethod
        navigationController.pushViewController(vc, animated: true)
    }
    
    func getMainView() -> PaymentOptionsViewController {
        let vc = PaymentOptionsViewController.instantiate()
        let viewModel = PaymentOptionsViewModel()
        vc.viewModel = viewModel
        return vc
    }

    
}
