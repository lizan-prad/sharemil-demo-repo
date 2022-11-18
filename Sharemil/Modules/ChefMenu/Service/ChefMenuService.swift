//
//  ChefMenuService.swift
//  Sharemil
//
//  Created by lizan on 19/06/2022.
//

import Foundation
import Alamofire

protocol ChefMenuService {
    func fetchChefMenu(_ id: String, completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, NSError>) -> ())
    func fetchCartList(_ id: String, completion: @escaping (Result<BaseMappableModel<CartListModel>, NSError>) -> ())
}

extension ChefMenuService {
    func fetchChefMenu(_ id: String, completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, NSError>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<ChefMenuContainerModel>.self, urlExt: "menus/chef/\(id)", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func fetchCartList(_ id: String, completion: @escaping (Result<BaseMappableModel<CartListModel>, NSError>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<CartListModel>.self, urlExt: "carts/\(id)", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
