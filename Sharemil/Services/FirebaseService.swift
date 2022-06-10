//
//  FirebaseService.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import Foundation
import FirebaseAuth
import FirebaseCore

class FirebaseService {
    
    static let shared = FirebaseService()
    
    func verifyPhone(_ phone: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
            if let error = error {
                failure(error)
                return
            }
            UserDefaults.standard.set(verificationID ?? "", forKey: StringConstants.verificationToken)
            success()
        }
    }
    
    func signInWith(_ otpCode: String, success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        guard let verificationID = UserDefaults.standard.string(forKey: StringConstants.verificationToken) else {return}
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: otpCode
        )
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                failure(error)
                return
            }
            guard let user = authResult?.user else {return}
            success(user)
        }
    }
}
