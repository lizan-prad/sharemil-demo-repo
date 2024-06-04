//
//  PaymentOptionsViewModle.swift
//  Sharemil
//
//  Created by lizan on 01/07/2022.
//

import Foundation

class PaymentOptionsViewModel: PaymentOptionsService, CustomStripeService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var success: Observable<String> = Observable(nil)
    var methods: Observable<[PaymentMethods]> = Observable([])
    
    func proceedPayment(_ cartId: String) {
        self.loading.value = true
        self.paymentIntent(cartId) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.payment.value = model
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    func makeDefaultApplePay() {
        self.loading.value = true
        self.setDefaultPaymentMethodAppe() { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.success.value = model.status
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    func makeDefaultPaymentMethod(_ id: String) {
        self.loading.value = true
        self.setDefaultPaymentMethod(id) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.success.value = model.status
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    
    func deletePaymentMethod(_ id: String) {
        self.loading.value = true
        self.deletePaymentMethods(id) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.success.value = model.status
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    func getPaymentMethods() {
        self.loading.value = true
        self.getPaymentMethods { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.methods.value = model.data?.paymentMethods
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
