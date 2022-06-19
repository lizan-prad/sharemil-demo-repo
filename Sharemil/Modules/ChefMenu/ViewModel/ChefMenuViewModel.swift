//
//  ChefMenuViewModel.swift
//  Sharemil
//
//  Created by lizan on 19/06/2022.
//

import Foundation

class ChefMenuViewModel: ChefMenuService {
    
    var chef: ChefListModel?
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var menuItems: Observable<[ChefMenuListModel]> = Observable([])
    
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
}
