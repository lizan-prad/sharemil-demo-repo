//
//  SaveLocationCoordinator.swift
//  Sharemil
//
//  Created by lizan on 21/06/2022.
//
import UIKit
import GooglePlaces

class SaveLocationCoordinator: Coordinator {
    func start() {
        let vc = SaveLocationViewController.instantiate()
        vc.location = location
        self.navigationController.present(vc, animated: true)
    }
    
    var didSaveLocation: (() -> ())?
    var didUpdateLocation: (() -> ())?
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    var location: GMSPlace?
    
    var model: MyLocationModel?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func getMainView() -> SaveLocationViewController {
        let vc = SaveLocationViewController.instantiate()
        vc.location = location
        let viewModel = SaveLocationViewModel()
        vc.viewModel = viewModel
        vc.model = self.model
        vc.didCompleteSaving = didSaveLocation
        vc.didCompleteUpdating = didUpdateLocation
        return vc
    }
    
}
