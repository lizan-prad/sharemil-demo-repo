//
//  HomeService.swift
//  Sharemil
//
//  Created by lizan on 14/06/2022.
//

import Foundation
import Alamofire

protocol HomeService {
    func fetchChefs(_ location: LLocation, with chefName: String?, completion: @escaping (Result<BaseMappableModel<ChefListContainerModel>, NSError>) -> () )
    func fetchChefBy(_ id: String, completion: @escaping (Result<BaseMappableModel<ChefListContainerModel>, NSError>) -> () )
}

extension HomeService {
    func fetchChefs(_ location: LLocation, with chefName: String?, completion: @escaping (Result<BaseMappableModel<ChefListContainerModel>, NSError>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<ChefListContainerModel>.self, urlExt: "chefs/location/lat/\(location.location?.coordinate.latitude ?? 0)/lon/\(location.location?.coordinate.longitude ?? 0)/radius/25.0?search=\(chefName ?? "")", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func fetchChefBy(_ id: String, completion: @escaping (Result<BaseMappableModel<ChefListContainerModel>, NSError>) -> () ) {
        NetworkManager.shared.request(BaseMappableModel<ChefListContainerModel>.self, urlExt: "chefs/\(id)", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
