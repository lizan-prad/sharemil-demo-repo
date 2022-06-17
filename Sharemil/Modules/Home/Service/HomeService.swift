//
//  HomeService.swift
//  Sharemil
//
//  Created by lizan on 14/06/2022.
//

import Foundation
import Alamofire

protocol HomeService {
    func fetchChefs(_ location: LLocation, with chefName: String?, completion: @escaping (Result<BaseMappableModel<ChefListContainerModel>, Error>) -> () )
}

extension HomeService {
    func fetchChefs(_ location: LLocation, with chefName: String?, completion: @escaping (Result<BaseMappableModel<ChefListContainerModel>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<ChefListContainerModel>.self, urlExt: "chefs/location/lat/34.062469/lon/-118.305718/radius/5.0?search=\(chefName ?? "")", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
