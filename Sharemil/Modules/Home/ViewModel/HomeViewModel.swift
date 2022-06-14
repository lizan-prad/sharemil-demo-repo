//
//  HomeViewModel.swift
//  Sharemil
//
//  Created by lizan on 13/06/2022.
//

import Foundation

class HomeViewModel: HomeService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var success: Observable<[ChefListModel]> = Observable([])
    
    func fetchChefBy(location: LLocation, name: String?) {
        self.loading.value = true
        self.fetchChefs(location, with: name) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.success.value = model.data?.chefs
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
