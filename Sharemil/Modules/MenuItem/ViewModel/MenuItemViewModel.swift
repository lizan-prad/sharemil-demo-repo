//
//  MenuItemViewModel.swift
//  Sharemil
//
//  Created by lizan on 22/06/2022.
//

import Foundation

class MenuItemViewModel: MenuItemService {
    
    var menuItemModel: ChefMenuListModel?
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var itemModel: Observable<ChefMenuListModel> = Observable(nil)
    var cartList: Observable<CartListModel> = Observable(nil)
    
    func fetchChefMenuItem() {
        self.loading.value = true
        self.fetchChefMenuItem(self.menuItemModel?.id ?? "") { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.itemModel.value = model.data?.menuItem
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
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
    
    func addToCart(_ chefId: String, itemId: String, quantity: Int, options: [MenuItemOptionsModel]?) {
        self.loading.value = true
        self.addToCart(chefId, itemId: itemId, quantity: quantity, options: options) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.cartList.value = model.data
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
