//
//  HelpIssuePageViewModel.swift
//  Sharemil
//
//  Created by Lizan on 18/10/2022.
//

import Foundation

struct SupportTicketStruct {
    
    var issues: [IssueListStruct]?
    var orderNo: String?
    var note: String?
}

class HelpIssuePageViewModel: HelpService {
    
    var loading: Observable<Bool> = Observable(nil)
    var error: Observable<String> = Observable(nil)
    var issues: Observable<String> = Observable(nil)

    
    func createSupportTicket(_ model: SupportTicketStruct) {
        loading.value = true
        self.createSupportTicket(model) { result in
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
