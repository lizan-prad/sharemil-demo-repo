//
//  ConfigModel.swift
//  Sharemil
//
//  Created by Rojan Shrestha on 2/15/24.
//

import Foundation
import ObjectMapper

struct ConfigModel : Mappable {
    
    var data:ConfigData?
    
    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        data <- map["data"]
    }
   

}

struct ConfigData: Mappable {
    var isValidationEnabled: Bool?
    var skipRegistration: Bool?
    
    init?(map: ObjectMapper.Map) {
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        isValidationEnabled <- map["isValidationEnabled"]
        skipRegistration <- map["skipRegistration"]
    }
}
