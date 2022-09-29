//
//  CustomStripeService.swift
//  Sharemil
//
//  Created by Lizan on 17/07/2022.
//

import Foundation
import Alamofire

protocol CustomStripeService {
    func getPaymentMethods(completion: @escaping (Result<BaseMappableModel<StripeCardModelContainer>, Error>) -> ())
    func deletePaymentMethods(_ id: String, completion: @escaping (Result<BaseMappableModel<StripeCardModelContainer>, Error>) -> ())
    func setDefaultPaymentMethod(_ id: String, completion: @escaping (Result<BaseMappableModel<StripeCardModelContainer>, Error>) -> ())
    func createPaymentMethod(_ model: CreditCardModel ,completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, Error>) -> ())
}

extension CustomStripeService {
    
    func getPaymentMethods(completion: @escaping (Result<BaseMappableModel<StripeCardModelContainer>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<StripeCardModelContainer>.self, urlExt: "payment/methods", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func setDefaultPaymentMethod(_ id: String, completion: @escaping (Result<BaseMappableModel<StripeCardModelContainer>, Error>) -> ()) {
        let param: [String: Any] = [
            "default": true
            ]
        NetworkManager.shared.request(BaseMappableModel<StripeCardModelContainer>.self, urlExt: "payment/methods/\(id)", method: .put, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func deletePaymentMethods(_ id: String, completion: @escaping (Result<BaseMappableModel<StripeCardModelContainer>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<StripeCardModelContainer>.self, urlExt: "payment/methods/\(id)", method: .delete, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func createPaymentMethod(_ model: CreditCardModel ,completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, Error>) -> ()) {
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
