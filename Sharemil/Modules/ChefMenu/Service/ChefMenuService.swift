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
}

extension ChefMenuService {
    func fetchChefMenu(_ id: String, completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<ChefMenuContainerModel>.self, urlExt: "menus/chef/\(id)", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
