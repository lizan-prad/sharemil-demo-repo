//
//  HelpService.swift
//  Sharemil
//
//  Created by Lizan on 11/10/2022.
//

import Foundation
import Alamofire

protocol HelpService {
    func getItemIssueList(_ category: String, completion: @escaping (Result<BaseMappableModel<SupportIssueContainer>, Error>) -> ())
}

extension HelpService {
    func getItemIssueList(_ category: String, completion: @escaping (Result<BaseMappableModel<SupportIssueContainer>, Error>) -> ()) {
        NetworkManager.shared.request(BaseMappableModel<SupportIssueContainer>.self, urlExt: "support/issues/category/\(category)", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            completion(result)
        }
    }
}
