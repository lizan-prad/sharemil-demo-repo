//
//  MyLocationCoordinator.swift
//  Sharemil
//
//  Created by lizan on 18/06/2022.
//

import UIKit

class MyLocationCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    var locationName: String?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func getMainView() -> MyLocationViewController {
        let vc = MyLocationViewController.instantiate()
        let viewModel = MyLocationViewModel()
        viewModel.currentLocation = locationName
        vc.viewModel = viewModel
        return vc
    }
    
    func start() {
        let vc = MyLocationViewController.instantiate()
        let viewModel = MyLocationViewModel()
        viewModel.currentLocation = locationName
        vc.viewModel = viewModel
        
        navigationController.pushViewController(vc, animated: true)
    }

    
}
