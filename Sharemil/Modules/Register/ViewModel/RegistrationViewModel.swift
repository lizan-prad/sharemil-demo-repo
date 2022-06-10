//
//  RegistrationViewModel.swift
//  Sharemil
//
//  Created by Macbook Pro on 09/06/2022.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

class RegistrationViewModel {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var signInSuccess: Observable<String> = Observable(nil)
    
    
    internal func verifyPhone(_ phone: String) {
        self.loading.value = true
        FirebaseService.shared.verifyPhone(phone) {
            self.loading.value = false
            self.signInSuccess.value = StringConstants.SuccessMessages.userOtp
        } failure: { error in
            self.loading.value = false
            self.error.value = error.localizedDescription
        }
    }
}
