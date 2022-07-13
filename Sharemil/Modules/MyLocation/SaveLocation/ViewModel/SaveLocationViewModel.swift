//
//  SaveLocationViewModel.swift
//  Sharemil
//
//  Created by Lizan on 11/07/2022.
//

import Foundation

class SaveLocationViewModel: SaveLocationService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var success: Observable<String> = Observable(nil)
    
    func saveUserLocation(_ name: String, location: LLocation?) {
        let param: [String: Any] = [
            "name": name,
            "latitude": location?.location?.coordinate.latitude ?? 0,
            "longitude": location?.location?.coordinate.longitude ?? 0
        ]
        self.loading.value = true
        self.saveLocation(param) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.success.value = "Location added successfully!"
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    func updateLocation(_ name: String, id: String, location: LLocation?) {
        let param: [String: Any] = [
            "name": name,
            "latitude": location?.location?.coordinate.latitude ?? 0,
            "longitude": location?.location?.coordinate.longitude ?? 0
        ]
        self.loading.value = true
        self.updateLocation(id, param: param) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.success.value = "Location updated successfully!"
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
