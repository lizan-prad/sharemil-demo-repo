//
//  FirebaseService.swift
//  Sharemil
//
//  Created by lizan on 10/06/2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseMessaging
import FirebaseFirestore
import FirebaseStorage

import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

func MD5(string: String) -> Data {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: length)
    
    _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
        messageData.withUnsafeBytes { messageBytes -> UInt8 in
            if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                let messageLength = CC_LONG(messageData.count)
                CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
            }
            return 0
        }
    }
    return digestData
}

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
    
    func uploadMedia(_ image: UIImage, name: String, completion: @escaping (_ url: String?) -> Void) {
        let md5Data = MD5(string:name)

        let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()

        let storageRef = Storage.storage().reference().child("\(md5Hex).jpg")
        if let uploadData = image.jpegData(compressionQuality: 1) {
            storageRef.putData(uploadData) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    storageRef.downloadURL { url, error in
                        guard let url = url else {return}
                        completion(url.absoluteString)
                    }
                }
           }
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
            user.getIDTokenForcingRefresh(true) { token, error in
                UserDefaults.standard.set(token ?? "", forKey: StringConstants.userIDToken)
                success(user)
            }
            
        }
    }
}
