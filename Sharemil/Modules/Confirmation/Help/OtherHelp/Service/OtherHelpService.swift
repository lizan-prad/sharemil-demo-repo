//
//  OtherHelpService.swift
//  Sharemil
//
//  Created by Lizan on 16/02/2023.
//

import Foundation
import Alamofire

protocol OtherHelpService {
    
    func createSupportTicket(_ title: String, _ message: String, completion: @escaping (Result<BaseMappableModel<SupportIssueContainer>, NSError>) -> ())
}

extension OtherHelpService {
    
    func createSupportTicket(_ title: String, _ message: String, completion: @escaping (Result<BaseMappableModel<SupportIssueContainer>, NSError>) -> ()) {
        
        let param: [String: Any] = [
            
            "title": title,
            "note": message
            
        ]
        NetworkManager.shared.request(BaseMappableModel<SupportIssueContainer>.self, urlExt: "support/tickets", method: .post, param: param, encoding: JSONEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
