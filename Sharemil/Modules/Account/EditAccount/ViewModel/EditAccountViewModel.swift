//
//  EditAccountViewModel.swift
//  Sharemil
//
//  Created by Lizan on 06/07/2022.
//

import Foundation

class EditAccountViewModel: AccountService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var user: Observable<UserModel> = Observable(nil)
    
    func fetchUserProfile() {
        self.loading.value = true
        self.fetchProfile { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.user.value = model.data?.user
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    func updateUserProfile(param: [String:Any]) {
        self.loading.value = true
        self.updateProfile(param: param) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.user.value = model.data?.user
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
