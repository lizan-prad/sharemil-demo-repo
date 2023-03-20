//
//  BaseMappableModel.swift
//  Sharemil
//
//  Created by lizan on 14/06/2022.
//

import Foundation
import ObjectMapper

class BaseMappableModel<T: Mappable>: Mappable {
    var data: T?
    var status: String?
    
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        status <- map["status"]
    }
}
