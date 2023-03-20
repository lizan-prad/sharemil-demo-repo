//
//  OrdersViewModel.swift
//  Sharemil
//
//  Created by Lizan on 05/07/2022.
//

import Foundation

class OrdersViewModel: OrdersService, HomeService {
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var orders: Observable<[OrderModel]> = Observable([])
    var chefs:Observable<[ChefListModel]> = Observable([])
    var cusines: Observable<[CusineListModel]> = Observable([])
    
    func fetchChefBy(location: LLocation, name: String?) {
        self.loading.value = true
        self.fetchChefs(location, with: name) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.chefs.value = model.data?.chefs
                self.cusines.value = model.data?.cuisines
            case .failure(let error):
                
                self.error.value = error.localizedDescription
                
            }
        }
    }
    
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
