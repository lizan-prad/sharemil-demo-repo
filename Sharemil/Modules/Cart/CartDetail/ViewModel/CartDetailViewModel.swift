//
//  CartDetailViewModel.swift
//  Sharemil
//
//  Created by lizan on 23/06/2022.
//

import Foundation

class CartDetailViewModel: MenuItemService, CartService, HomeService, ChefMenuService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var cartList: Observable<CartListModel> = Observable(nil)
    var upDateList: Observable<CartListModel> = Observable(nil)
    var deleteState: Observable<String> = Observable(nil)
    var refresh: Observable<String> = Observable(nil)
    var chef: Observable<ChefListModel> = Observable(nil)
    var menuItems: Observable<[ChefMenuListModel]> = Observable([])
    var recommended: Observable<[ChefMenuListModel]> = Observable([])
    
    func fetchCartRecommendedItems(_ id: String) {
        self.loading.value = true
        self.fetchRecommendedItem(id) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.recommended.value = model.data?.menu
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    
    func fetchChefMenu(_ id: String) {
        self.loading.value = true
        self.fetchChefMenu(id) { result in
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
                self.cartList.value = model.data
            case .failure(let error):
                if error.code == 401 {
                    self.refresh.value = error.localizedDescription
                } else {
                    self.error.value = error.localizedDescription
                }
            }
        }
    }
    
    func fetchChefBy(_ id: String) {
        self.loading.value = true
        self.fetchChefBy(id) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.chef.value = model.data?.chef
            case .failure(let error):
                if error.code == 401 {
                    self.refresh.value = error.localizedDescription
                } else {
                    self.error.value = error.localizedDescription
                }
            }
        }
    }
    
    func updateToCart(_ chefId: String,cartModels: [CartItems]) {
        self.loading.value = true
        self.updateCart(chefId,cartItems: cartModels) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.upDateList.value = model.data
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
