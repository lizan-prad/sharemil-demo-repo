//
//  SaveLocationService.swift
//  Sharemil
//
//  Created by Lizan on 11/07/2022.
//

import Foundation
import Alamofire

protocol SaveLocationService {
    func saveLocation(_ param: [String: Any], completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, Error>) -> ())
    func updateLocation(_ id: String, param: [String: Any], completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, Error>) -> ())
}

extension SaveLocationService {
    func saveLocation(_ param: [String: Any], completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<OrdersContainerModel>.self, urlExt: "users/locations", method: .post, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func updateLocation(_ id: String, param: [String: Any], completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<OrdersContainerModel>.self, urlExt: "users/locations/\(id)", method: .put, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
