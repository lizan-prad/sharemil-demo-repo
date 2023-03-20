//
//  File.swift
//  Sharemil
//
//  Created by Lizan on 17/07/2022.
//

import Foundation

class CustomStripeViewModel: CustomStripeService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var success: Observable<String> = Observable(nil)
    
    func addPaymentMethod(_ card: CreditCardModel) {
        loading.value = true
        self.createPaymentMethod(card) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.success.value = model.status
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
