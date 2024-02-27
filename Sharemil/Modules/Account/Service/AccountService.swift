//
//  AccountService.swift
//  Sharemil
//
//  Created by Lizan on 06/07/2022.
//
import Foundation
import Alamofire

protocol AccountService {
    func fetchProfile(completion: @escaping (Result<BaseMappableModel<UserContainerModel>, NSError>) -> ())
    func updateProfile(param: [String: Any], completion: @escaping (Result<BaseMappableModel<UserContainerModel>, NSError>) -> ())
    func deleteProfile(completion: @escaping (Result<BaseMappableModel<UserContainerModel>, NSError>) -> ())
}

extension AccountService {
    
    func deleteProfile(completion: @escaping (Result<BaseMappableModel<UserContainerModel>, NSError>) -> ()){
        NetworkManager.shared.request(BaseMappableModel<UserContainerModel>.self, urlExt: "users/me", method: .delete, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    
    func fetchProfile(completion: @escaping (Result<BaseMappableModel<UserContainerModel>, NSError>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<UserContainerModel>.self, urlExt: "users/me", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func updateProfile(param: [String: Any], completion: @escaping (Result<BaseMappableModel<UserContainerModel>, NSError>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<UserContainerModel>.self, urlExt: "users/me", method: .put, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
