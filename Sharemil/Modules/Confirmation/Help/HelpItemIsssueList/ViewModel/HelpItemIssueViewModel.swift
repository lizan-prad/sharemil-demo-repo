//
//  HelpItemIssueViewModel.swift
//  Sharemil
//
//  Created by Lizan on 12/10/2022.
//

import Foundation

class HelpItemIssueViewModel: HelpService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var issues: Observable<SupportIssueContainer> = Observable(nil)

    
    func getIssueList(_ supportType: String) {
        loading.value = true
        self.getItemIssueList(supportType) { result in
            self.loading.value = false
            switch result {
            case .success(let model):
                self.issues.value = model.data
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
