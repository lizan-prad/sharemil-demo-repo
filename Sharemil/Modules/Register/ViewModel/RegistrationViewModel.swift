//
//  RegistrationViewModel.swift
//  Sharemil
//
//  Created by Macbook Pro on 09/06/2022.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

class RegistrationViewModel: RegisterService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var signInSuccess: Observable<String> = Observable(nil)
    
    internal func verifyPhone(_ phone: String) {
       let validation = UserDefaults.standard.value(forKey: "LoginValidationCheck") as! Bool
        if validation {
            // check phone number from api
            self.checkInvitation(phone) { result in
                switch result {
                case .success( _):
                    self.login(phone: phone)
                case .failure( _):
                    self.loading.value = false
                    self.error.value = "The app is still in development we will be releasing shortly."
                }
            }
        }else {
            login(phone: phone)
        }
    }
    
    func login(phone:String){
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
