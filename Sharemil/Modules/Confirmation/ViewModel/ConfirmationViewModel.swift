//
//  ConfirmationViewModel.swift
//  Sharemil
//
//  Created by Lizan on 14/07/2022.
//

import Foundation
import GoogleMaps

class ConfirmationViewModel: CheckoutService {
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
