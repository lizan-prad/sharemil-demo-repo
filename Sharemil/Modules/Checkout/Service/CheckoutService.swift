//
//  CheckoutService.swift
//  Sharemil
//
//  Created by lizan on 24/06/2022.
//

import Foundation
import GoogleMaps
import Alamofire

protocol CheckoutService {
    func getRoutes(_ origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping ([Routes]) -> ())
    func createOrder(_ paymentMethodId: String, _ cartId: String, completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, NSError>) -> ())
}

extension CheckoutService {
    func getRoutes(_ origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping ([Routes]) -> ()) {
        GoogleMapsServices.shared.getRoutes(origin, destination: destination) { routes in
            completion(routes)
        }
    }
    
    func createOrder(_ paymentMethodId: String, _ cartId: String, completion: @escaping (Result<BaseMappableModel<OrdersContainerModel>, NSError>) -> ()) {
        let param: [String: Any] = [
            "cartId": cartId,
            "paymentMethodId": paymentMethodId
        ]
        NetworkManager.shared.request(BaseMappableModel<OrdersContainerModel>.self, urlExt: "orders", method: .post, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }

}
