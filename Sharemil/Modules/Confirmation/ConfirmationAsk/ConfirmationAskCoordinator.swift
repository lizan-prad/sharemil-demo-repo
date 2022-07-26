//
//  ConfirmationAskCoordinator.swift
//  Sharemil
//
//  Created by Lizan on 26/07/2022.
//

import UIKit

class ConfirmationAskCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var didApprove: (() -> ())?
    var didCancel: (() -> ())?
    
    
    func getMainView() -> ConfirmationAskViewController {
        let vc = ConfirmationAskViewController.instantiate()
       
        vc.didApprove = self.didApprove
        vc.didCancel = self.didCancel

        return vc
    }
    
    func start() {
        
    }

    
}
