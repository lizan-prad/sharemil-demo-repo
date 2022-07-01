//
//  PaymentOptionsService.swift
//  Sharemil
//
//  Created by lizan on 01/07/2022.
//

import Foundation
import Alamofire

protocol PaymentOptionsService {
    func paymentIntent(_ cartId: String, completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, Error>) -> ())
}

extension PaymentOptionsService {
    func paymentIntent(_ cartId: String, completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, Error>) -> ()) {
        let param: [String: Any] = [
            "cartId": cartId
        ]
        NetworkManager.shared.request(BaseMappableModel<ChefMenuContainerModel>.self, urlExt: "payment/sheet", method: .post, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
