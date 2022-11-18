//
//  CustomStripeService.swift
//  Sharemil
//
//  Created by Lizan on 17/07/2022.
//

import Foundation
import Alamofire

protocol CustomStripeService {
    func getPaymentMethods(completion: @escaping (Result<BaseMappableModel<StripeCardModelContainer>, NSError>) -> ())
    func deletePaymentMethods(_ id: String, completion: @escaping (Result<BaseMappableModel<StripeCardModelContainer>, NSError>) -> ())
    func setDefaultPaymentMethod(_ id: String, completion: @escaping (Result<BaseMappableModel<StripeCardModelContainer>, NSError>) -> ())
    func setDefaultPaymentMethodAppe(completion: @escaping (Result<BaseMappableModel<StripeCardModelContainer>, NSError>) -> ())
    func createPaymentMethod(_ model: CreditCardModel ,completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, NSError>) -> ())
}

extension CustomStripeService {
    
    func setDefaultPaymentMethodAppe(completion: @escaping (Result<BaseMappableModel<StripeCardModelContainer>, NSError>) -> ()) {
        let param: [String: Any] = [
            "default": true
            ]
        NetworkManager.shared.request(BaseMappableModel<StripeCardModelContainer>.self, urlExt: "payment/methods/apple-pay", method: .post, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func getPaymentMethods(completion: @escaping (Result<BaseMappableModel<StripeCardModelContainer>, NSError>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<StripeCardModelContainer>.self, urlExt: "payment/methods", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func setDefaultPaymentMethod(_ id: String, completion: @escaping (Result<BaseMappableModel<StripeCardModelContainer>, NSError>) -> ()) {
        let param: [String: Any] = [
            "default": true
            ]
        NetworkManager.shared.request(BaseMappableModel<StripeCardModelContainer>.self, urlExt: "payment/methods/\(id)", method: .put, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func deletePaymentMethods(_ id: String, completion: @escaping (Result<BaseMappableModel<StripeCardModelContainer>, NSError>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<StripeCardModelContainer>.self, urlExt: "payment/methods/\(id)", method: .delete, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func createPaymentMethod(_ model: CreditCardModel ,completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, NSError>) -> ()) {
        let param: [String: Any] = [
            "name": model.name,
            "cardNumber": model.cardNumber,
            "expMonth": model.expMonth,
            "expYear": model.expYear,
            "cvc": model.cvv,
            "default": model.isDefault
        ]
        NetworkManager.shared.request(BaseMappableModel<ChefMenuContainerModel>.self, urlExt: "payment/methods", method: .post, param: param, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
