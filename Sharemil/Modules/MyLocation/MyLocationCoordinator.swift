//
//  MyLocationCoordinator.swift
//  Sharemil
//
//  Created by lizan on 18/06/2022.
//

import UIKit
import GooglePlaces
class MyLocationCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    var locationName: String?
    var didSelectPlace: ((MyLocationModel?) -> ())?
    var isDeliverySection = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func getMainView() -> MyLocationViewController {
        let vc = MyLocationViewController.instantiate()
        let viewModel = MyLocationViewModel()
        viewModel.currentLocation = locationName
        vc.viewModel = viewModel
        vc.isDeliverySection = isDeliverySection
        vc.didGetPlace = didSelectPlace
        return vc
    }
    
    func start() {
        let vc = MyLocationViewController.instantiate()
        let viewModel = MyLocationViewModel()
        viewModel.currentLocation = locationName
        vc.viewModel = viewModel
        vc.didGetPlace = didSelectPlace
        vc.isDeliverySection = isDeliverySection
        navigationController.pushViewController(vc, animated: true)
    }

    
}
