//
//  ChefMenuService.swift
//  Sharemil
//
//  Created by lizan on 19/06/2022.
//

import Foundation
import Alamofire

protocol ChefMenuService {
    func fetchChefMenu(_ id: String, completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, Error>) -> ())
    func fetchCartList(_ id: String, completion: @escaping (Result<BaseMappableModel<CartListModel>, Error>) -> ())
}

extension ChefMenuService {
    func fetchChefMenu(_ id: String, completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<ChefMenuContainerModel>.self, urlExt: "menus/chef/\(id)", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func fetchCartList(_ id: String, completion: @escaping (Result<BaseMappableModel<CartListModel>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<CartListModel>.self, urlExt: "carts/\(id)", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
