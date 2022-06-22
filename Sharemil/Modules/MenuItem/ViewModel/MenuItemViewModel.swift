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
}
