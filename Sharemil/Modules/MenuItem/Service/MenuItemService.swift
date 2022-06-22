//
//  MenuItemService.swift
//  Sharemil
//
//  Created by lizan on 22/06/2022.
//

import Foundation
import Alamofire

protocol MenuItemService {
    func fetchChefMenuItem(_ id: String, completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, Error>) -> ())
}

extension MenuItemService {
    func fetchChefMenuItem(_ id: String, completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<ChefMenuContainerModel>.self, urlExt: "menus/\(id)", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
