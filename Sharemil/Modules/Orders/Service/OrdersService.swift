//
//  OrdersService.swift
//  Sharemil
//
//  Created by Lizan on 05/07/2022.
//
import Foundation
import Alamofire

protocol OrdersService {
    func fetchOrders(completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, NSError>) -> ())
    
    func fetchOrder(_ id: String, completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, NSError>) -> ())
}

extension OrdersService {
    func fetchOrders(completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, NSError>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<OrdersContainerModel>.self, urlExt: "orders", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func fetchOrder(_ id: String, completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, NSError>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<OrdersContainerModel>.self, urlExt: "orders/\(id)", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
