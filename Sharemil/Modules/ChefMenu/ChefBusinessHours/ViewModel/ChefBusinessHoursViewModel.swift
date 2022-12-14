//
//  ChefBusinessHoursViewModel.swift
//  Sharemil
//
//  Created by Lizan on 13/12/2022.
//

import Foundation
import CoreLocation
import GoogleMaps
class ChefBusinessHoursViewModel: CheckoutService {
    
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
