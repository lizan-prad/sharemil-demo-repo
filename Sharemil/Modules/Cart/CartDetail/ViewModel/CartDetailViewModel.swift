//
//  CartDetailViewModel.swift
//  Sharemil
//
//  Created by lizan on 23/06/2022.
//

import Foundation

class CartDetailViewModel: MenuItemService, CartService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var cartList: Observable<CartListModel> = Observable(nil)
    var deleteState: Observable<String> = Observable(nil)
    
    func updateToCart(_ chefId: String, cartModels: [CartItems]) {
        self.loading.value = true
        self.updateCart(chefId, cartItems: cartModels) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.cartList.value = model.data
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
