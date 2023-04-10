//
//  OtherHelpViewModel.swift
//  Sharemil
//
//  Created by Lizan on 16/02/2023.
//

import Foundation

class OtherHelpViewModel: OtherHelpService {
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var issues: Observable<String> = Observable(nil)

    
    func createSupportTicket(_ title: String, _ note: String) {
        loading.value = true
        self.createSupportTicket(title, note) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.issues.value = "Support ticket created."
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
