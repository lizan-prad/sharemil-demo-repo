//
//  MyLocationService.swift
//  Sharemil
//
//  Created by Lizan on 11/07/2022.
//
import Foundation
import Alamofire

protocol MyLocationService {
    func getSavedLocations(completion: @escaping (Result<BaseMappableModel<MyLocationContainerModel>, Error>) -> ())
    func deleteLocation(_ id: String, completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, Error>) -> ())
}

extension MyLocationService {
    func getSavedLocations(completion: @escaping (Result<BaseMappableModel<MyLocationContainerModel>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<MyLocationContainerModel>.self, urlExt: "users/locations", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func deleteLocation(_ id: String, completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<OrdersContainerModel>.self, urlExt: "users/locations/\(id)", method: .delete, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}