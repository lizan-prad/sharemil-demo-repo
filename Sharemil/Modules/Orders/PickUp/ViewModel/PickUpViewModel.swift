//
//  PickUpViewModel.swift
//  Sharemil
//
//  Created by Lizan on 18/01/2023.
//

import Foundation

class PickUpViewModel: PickUpService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var success: Observable<String> = Observable(nil)
    
    func setCustomerArrival(_ id: String, _ note: String) {
        self.loading.value = true
        self.hadArrivedWith(id, note) { result in
            self.loading.value = false
            switch result {
            case .success(let _):
                self.success.value = "Your chef has been notified about your arrival."
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
