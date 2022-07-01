//
//  PaymentOptionsViewModle.swift
//  Sharemil
//
//  Created by lizan on 01/07/2022.
//

import Foundation

class PaymentOptionsViewModel: PaymentOptionsService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    
    func proceedPayment(_ cartId: String) {
        self.loading.value = true
        self.paymentIntent(cartId) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
