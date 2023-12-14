//
//  CartViewModel.swift
//  Sharemil
//
//  Created by lizan on 27/06/2022.
//

import Foundation

class CartViewModel: CartService, HomeService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var carts: Observable<CartListModel> = Observable(nil)
    var chefs: Observable<[ChefListModel]> = Observable([])
    var deleteState: Observable<String> = Observable(nil)
    var refresh: Observable<String> = Observable(nil)
    
    func fetchChefBy(location: LLocation, name: String?) {
        self.loading.value = true
        self.fetchChefs(location, with: name) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.chefs.value = model.data?.chefs
            case .failure(let error):
                if error.code == 401 {
                    self.refresh.value = error.localizedDescription
                } else {
                    self.error.value = error.localizedDescription
                }
            }
        }
    }
    
    func fetchCarts() {
        self.loading.value = true
        self.fetchCarts { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.carts.value = model.data
            case .failure(let error):
                if error.code == 401 {
                    self.refresh.value = error.localizedDescription
                } else {
                    self.error.value = error.localizedDescription
                }
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
                if error.code == 401 {
                    self.refresh.value = error.localizedDescription
                } else {
                    self.error.value = error.localizedDescription
                }
            }
        }
    }
}
