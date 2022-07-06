//
//  AccountService.swift
//  Sharemil
//
//  Created by Lizan on 06/07/2022.
//
import Foundation
import Alamofire

protocol AccountService {
    func fetchProfile(completion: @escaping (Result<BaseMappableModel<UserContainerModel>, Error>) -> ())
}

extension AccountService {
    func fetchProfile(completion: @escaping (Result<BaseMappableModel<UserContainerModel>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<UserContainerModel>.self, urlExt: "users/me", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
