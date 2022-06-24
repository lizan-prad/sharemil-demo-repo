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
}

extension CheckoutService {
    func getRoutes(_ origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping ([Routes]) -> ()) {
        GoogleMapsServices.shared.getRoutes(origin, destination: destination) { routes in
            completion(routes)
        }
    }
}
