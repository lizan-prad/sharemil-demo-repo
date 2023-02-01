//
//  PaymentOptionsService.swift
//  Sharemil
//
//  Created by lizan on 01/07/2022.
//

import Foundation
import Alamofire

protocol PaymentOptionsService {
    func paymentIntent(_ cartId: String, completion: @escaping (Result<PaymentIntentModel, NSError>) -> ())
    
    func createPaymentIntent(_ cartId: String, paymentMethodId: String, _ orderId: String, completion: @escaping (Result<BaseMappableModel<CreatePaymentModel>, NSError>) -> ())
    
    func confirmPaymentIntent(_ paymentIntentId: String, completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, NSError>) -> ())
}

extension PaymentOptionsService {
    func paymentIntent(_ cartId: String, completion: @escaping (Result<PaymentIntentModel, NSError>) -> ()) {
        let param: [String: Any] = [
            "cartId": cartId
        ]
        NetworkManager.shared.request(PaymentIntentModel.self, urlExt: "payment/sheet", method: .post, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func createPaymentIntent(_ cartId: String, paymentMethodId: String, _ orderId: String, completion: @escaping (Result<BaseMappableModel<CreatePaymentModel>, NSError>) -> ()) {
        let param: [String: Any] = [
            "cartId": cartId,
            "orderId": orderId,
            "paymentMethodId": paymentMethodId
        ]
        NetworkManager.shared.request(BaseMappableModel<CreatePaymentModel>.self, urlExt: "payment/intents", method: .post, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func confirmPaymentIntent(_ paymentIntentId: String, completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, NSError>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<OrdersContainerModel>.self, urlExt: "payment/intents/\(paymentIntentId)/confirm", method: .post, param: nil, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
