//
//  ChefMenuViewModel.swift
//  Sharemil
//
//  Created by lizan on 19/06/2022.
//

import Foundation

class ChefMenuViewModel: ChefMenuService, CartService {
    
    var chef: ChefListModel?
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var menuItems: Observable<[ChefMenuListModel]> = Observable([])
    var cartList: Observable<[CartItems]> = Observable([])
    
    func fetchChefMenu() {
        self.loading.value = true
        self.fetchChefMenu(self.chef?.id ?? "") { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.menuItems.value = model.data?.menu
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    func fetchCarts() {
        self.loading.value = true
        self.fetchCarts { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                model.data?.carts?.forEach({ cart in
                    if cart.chefId == self.chef?.id {
                        self.fetchCarts(cart.id ?? "")
                    } else {
                        self.cartList.value = []
                    }
                })
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    func fetchCarts(_ id: String) {
        self.loading.value = true
        self.fetchCartList(id) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.cartList.value = model.data?.cart?.cartItems
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
