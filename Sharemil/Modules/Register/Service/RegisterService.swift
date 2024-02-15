//
//  RegisterService.swift
//  Sharemil
//
//  Created by Rojan Shrestha on 2/15/24.
//

import Foundation
import Alamofire

protocol RegisterService {
    func checkInvitation(_ phone: String, completion: @escaping (Result<BaseMappableModel<CheckInvitation>, NSError>) -> () )
}

extension RegisterService {
    
    func checkInvitation(_ phone: String, completion: @escaping (Result<BaseMappableModel<CheckInvitation>, NSError>) -> () ) {
        let param:[String:String] = [
            "phoneNumber":phone
        ]
        NetworkManager.shared.request(BaseMappableModel<CheckInvitation>.self, urlExt: "config/check-invitation", method: .post, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
}



