//
//  ConfirmationViewModel.swift
//  Sharemil
//
//  Created by Lizan on 14/07/2022.
//

import Foundation
import GoogleMaps

class ConfirmationViewModel: CheckoutService, OrdersService {
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var polylines: Observable<[GMSPath]> = Observable([])
    var order: Observable<OrderModel> = Observable(nil)
    
    func getOrder(_ id: String) {
        loading.value = true
        self.fetchOrder(id) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.order.value = model.data?.orders
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
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
