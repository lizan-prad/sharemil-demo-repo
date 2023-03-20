//
//  MyLocationViewModel.swift
//  Sharemil
//
//  Created by lizan on 18/06/2022.
//

import Foundation

class MyLocationViewModel: MyLocationService {
    
    var currentLocation: String?
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var success: Observable<String> = Observable(nil)
    var locations: Observable<[MyLocationModel]> = Observable([])
    
    func getLocations() {
        
        self.loading.value = true
        self.getSavedLocations() { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.locations.value = model.data?.locations
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    func deleteLocation(_ id: String) {
        self.loading.value = true
        self.deleteLocation(id) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.success.value = "Location deleted successfully!"
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
