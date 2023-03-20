//
//  OtpVerificationViewModel.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import Foundation
import FirebaseAuth

class OtpVerificationViewModel {
    
    var phoneNumber: String?
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var otpSuccess: Observable<User> = Observable(nil)
    var resendSuccess: Observable<String> = Observable(nil)
    
    internal func verifyOTP(_ pin: String) {
        self.loading.value = true
        FirebaseService.shared.signInWith(pin) { user in
            self.loading.value = false
            self.otpSuccess.value = user
        } failure: { error in
            self.loading.value = false
            self.error.value = error.localizedDescription
        }
    }
    
    internal func resendOTP() {
        self.loading.value = true
        FirebaseService.shared.verifyPhone(phoneNumber ?? "") {
            self.loading.value = false
            self.resendSuccess.value = "success"
        } failure: { error in
            self.loading.value = false
            self.error.value = error.localizedDescription
        }
    }
}
