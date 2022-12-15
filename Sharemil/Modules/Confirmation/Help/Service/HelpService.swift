//
//  HelpService.swift
//  Sharemil
//
//  Created by Lizan on 11/10/2022.
//

import Foundation
import Alamofire

protocol HelpService {
    func getItemIssueList(_ category: String, completion: @escaping (Result<BaseMappableModel<SupportIssueContainer>, NSError>) -> ())
    func createSupportTicket(_ model: SupportTicketStruct, completion: @escaping (Result<BaseMappableModel<SupportIssueContainer>, NSError>) -> ())
}

extension HelpService {
    func getItemIssueList(_ category: String, completion: @escaping (Result<BaseMappableModel<SupportIssueContainer>, NSError>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<SupportIssueContainer>.self, urlExt: "support/issues/category/\(category)", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    func createSupportTicket(_ model: SupportTicketStruct, completion: @escaping (Result<BaseMappableModel<SupportIssueContainer>, NSError>) -> ()) {
        
        let param: [String: Any] = [
            "orderNumber": model.orderNo ?? "",
            "issues": createIssueArray(model.issues, model.id),
            "note": model.note ?? "",
            "orderId": model.id ?? ""
        ]
        NetworkManager.shared.request(BaseMappableModel<SupportIssueContainer>.self, urlExt: "support/tickets", method: .post, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
    
    private func createIssueArray(_ list: [IssueListStruct]?, _ id: String?) -> [[String: Any]] {
        return list?.map({ m in
            return [
                "cartItem": m.item?.id ?? "",
                "supportCategory": m.issue?.id ?? ""
            ]
        }) ?? []
    }
}
