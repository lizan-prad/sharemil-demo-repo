//
//  PaymentEditOptionCoordinator.swift
//  Sharemil
//
//  Created by Lizan on 28/09/2022.
//

import UIKit

class PaymentEditOptionCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    var id: String?
    var didSelectDefault: ((String?) -> ())?
    var didSelectDelete: ((String?) -> ())?
    
    func getMainView() -> PaymentEditOptionViewController {
        let vc = PaymentEditOptionViewController.instantiate()
        vc.id = self.id
        vc.didSelectDelete = self.didSelectDelete
        vc.didSelectDefault = self.didSelectDefault
        return vc
    }
    
    func start() {
        
    }

    
}
