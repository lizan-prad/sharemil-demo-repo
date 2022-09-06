//
//  TabbarControllerViewModel.swift
//  Sharemil
//
//  Created by Lizan on 06/09/2022.
//

import Foundation

class TabbarControllerViewModel: CartService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var carts: Observable<CartListModel> = Observable(nil)
   
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
}
