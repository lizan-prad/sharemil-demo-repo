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
    func createPaymentMethod(_ model: CreditCardModel ,completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, Error>) -> ())
}

extension CustomStripeService {
    
    func getPaymentMethods(completion: @escaping (Result<BaseMappableModel<StripeCardModelContainer>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<StripeCardModelContainer>.self, urlExt: "payment/methods", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func createPaymentMethod(_ model: CreditCardModel ,completion: @escaping (Result<BaseMappableModel<ChefMenuContainerModel>, Error>) -> ()) {
        let param: [String: Any] = [
            "name": model.name,
            "cardNumber": model.cardNumber,
            "expMonth": model.expMonth,
            "expYear": model.expYear,
            "cvc": model.cvv
        ]
        NetworkManager.shared.request(BaseMappableModel<ChefMenuContainerModel>.self, urlExt: "payment/methods", method: .post, param: param, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
