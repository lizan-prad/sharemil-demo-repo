//
//  CartViewModel.swift
//  Sharemil
//
//  Created by lizan on 27/06/2022.
//

import Foundation

class CartViewModel: CartService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var carts: Observable<CartListModel> = Observable(nil)
    var deleteState: Observable<String> = Observable(nil)
    
    func fetchCarts() {
        self.loading.value = true
        self.fetchCarts { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.carts.value = model.data
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    func deleteCart(_ id: String) {
        self.loading.value = true
        self.deleteCart(id) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.deleteState.value = model.status
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
