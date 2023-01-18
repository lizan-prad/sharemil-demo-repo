//
//  PickUpService.swift
//  Sharemil
//
//  Created by Lizan on 18/01/2023.
//

import Foundation
import Alamofire

protocol PickUpService {
    func hadArrivedWith(_ orderId: String, _ note: String, completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, NSError>) -> ())
}

extension PickUpService {
    func hadArrivedWith(_ orderId: String, _ note: String, completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, NSError>) -> ()) {
        
        let param: [String: Any] = [
            "note": note,
            "isArrived": true
        ]
        NetworkManager.shared.request(BaseMappableModel<OrdersContainerModel>.self, urlExt: "orders/\(orderId)/customer/arrived", method: .put, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
