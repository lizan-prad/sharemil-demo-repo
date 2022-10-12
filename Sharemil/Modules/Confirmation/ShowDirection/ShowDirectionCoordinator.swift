//
//  ShowDirectionCoordinator.swift
//  Sharemil
//
//  Created by Lizan on 17/08/2022.
//

import UIKit

class ShowDirectionCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var chef: ChefListModel?
    
    func getMainView() -> ShowDirectionViewController {
        let vc = ShowDirectionViewController.instantiate()
        vc.chef = chef
        return vc
    }
    
    func start() {
        
    }

    
}
