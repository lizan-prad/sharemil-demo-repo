//
//  OtherHelpCoordinator.swift
//  Sharemil
//
//  Created by Lizan on 16/02/2023.
//

import UIKit

class OtherHelpCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func getMainView() -> OtherHelpViewController {
        let vc = OtherHelpViewController.instantiate()
        vc.viewModel = OtherHelpViewModel()
        return vc
    }
    
    func start() {
        
    }

    
}
