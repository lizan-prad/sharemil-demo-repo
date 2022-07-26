//
//  PaymentOptionsService.swift
//  Sharemil
//
//  Created by lizan on 01/07/2022.
//

import Foundation
import Alamofire

protocol PaymentOptionsService {
    func paymentIntent(_ cartId: String, completion: @escaping (Result<PaymentIntentModel, Error>) -> ())
    
    func createPaymentIntent(_ cartId: String, paymentMethodId: String, completion: @escaping (Result<BaseMappableModel<CreatePaymentModel>, Error>) -> ())
    
    func confirmPaymentIntent(_ paymentIntentId: String, completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, Error>) -> ())
}

extension PaymentOptionsService {
    func paymentIntent(_ cartId: String, completion: @escaping (Result<PaymentIntentModel, Error>) -> ()) {
        let param: [String: Any] = [
            "cartId": cartId
        ]
        NetworkManager.shared.request(PaymentIntentModel.self, urlExt: "payment/sheet", method: .post, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func createPaymentIntent(_ cartId: String, paymentMethodId: String, completion: @escaping (Result<BaseMappableModel<CreatePaymentModel>, Error>) -> ()) {
        let param: [String: Any] = [
            "cartId": cartId,
            "paymentMethodId": paymentMethodId
        ]
        NetworkManager.shared.request(BaseMappableModel<CreatePaymentModel>.self, urlExt: "payment/intents", method: .post, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func confirmPaymentIntent(_ paymentIntentId: String, completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<OrdersContainerModel>.self, urlExt: "payment/intents/\(paymentIntentId)/confirm", method: .post, param: nil, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
