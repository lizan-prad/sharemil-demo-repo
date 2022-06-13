//
//  HomeService.swift
//  Sharemil
//
//  Created by lizan on 14/06/2022.
//

import Foundation
import Alamofire

protocol HomeService {
    func fetchChefs(_ location: LLocation, with chefName: String?)
}

extension HomeService {
    func fetchChefs(_ location: LLocation, with chefName: String?) {
        
    }
}
