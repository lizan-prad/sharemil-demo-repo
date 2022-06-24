//
//  CheckoutViewModel.swift
//  Sharemil
//
//  Created by lizan on 24/06/2022.
//

import UIKit
import GoogleMaps

class CheckoutViewModel: CheckoutService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var polylines: Observable<[GMSPath]> = Observable([])
    
    func getRoute(_ origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        loading.value = true
        self.getRoutes(origin, destination: destination) { routes in
            self.loading.value = false
            var poly = [GMSPath]()
            for route in routes
            {
                if let path = GMSPath.init(fromEncodedPath: route.overview_polyline?.points ?? "") {
                    poly.append(path)
                }
            }
            self.polylines.value = poly
        }
    }
}
