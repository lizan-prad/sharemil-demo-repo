//
//  OrdersViewModel.swift
//  Sharemil
//
//  Created by Lizan on 05/07/2022.
//

import Foundation

class OrdersViewModel: OrdersService {
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var orders: Observable<[OrderModel]> = Observable([])
    
    func fetchOrders() {
        self.loading.value = true
        self.fetchOrders { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.orders.value = model.data?.order
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
