//
//  CartService.swift
//  Sharemil
//
//  Created by lizan on 27/06/2022.
//

import Foundation
import Alamofire

protocol CartService {
    func fetchCarts(completion: @escaping (Result<BaseMappableModel<CartListModel>, Error>) -> ())
    func deleteCart(_ id: String, completion: @escaping (Result<BaseMappableModel<CartListModel>, Error>) -> ())
}

extension CartService {
    func fetchCarts(completion: @escaping (Result<BaseMappableModel<CartListModel>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<CartListModel>.self, urlExt: "carts", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func deleteCart(_ id: String, completion: @escaping (Result<BaseMappableModel<CartListModel>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<CartListModel>.self, urlExt: "carts/\(id)", method: .delete, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
