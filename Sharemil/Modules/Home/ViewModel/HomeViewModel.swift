//
//  HomeViewModel.swift
//  Sharemil
//
//  Created by lizan on 13/06/2022.
//

import Foundation

class HomeViewModel: HomeService, AccountService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var success: Observable<[ChefListModel]> = Observable([])
    var cusines: Observable<[CusineListModel]> = Observable([])
    var address: Observable<String> = Observable(nil)
    var user: Observable<UserModel> = Observable(nil)
    var refresh: Observable<String> = Observable(nil)
    
    func fetchChefBy(location: LLocation, name: String?) {
        self.loading.value = true
        self.fetchChefs(location, with: name) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.success.value = model.data?.chefs
                self.cusines.value = model.data?.cuisines
            case .failure(let error):
                if error.code == 401 {
                    self.refresh.value = error.localizedDescription
                } else {
                    self.error.value = error.localizedDescription
                }
            }
        }
    }
    
    
    
    func fetchUserProfile() {
        self.loading.value = true
        self.fetchProfile { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.user.value = model.data?.user
            case .failure(let error):
                if error.code == 401 {
                    self.refresh.value = error.localizedDescription
                } else {
                    self.error.value = error.localizedDescription
                }
            }
        }
    }
    
    func getCurrentAddress(_ location: LLocation) {
        GoogleMapsServices.shared.getAddress(location) { address in
            self.address.value = address
        }
    }
}
