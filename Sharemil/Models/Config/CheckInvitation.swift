//
//  CheckInvitation.swift
//  Sharemil
//
//  Created by Rojan Shrestha on 2/15/24.
//

import Foundation
import ObjectMapper

struct CheckInvitation : Mappable {
    
    var data:CheckInvitationData?
    
    init?(map: ObjectMapper.Map) {
    
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        data <- map["data.invitation"]
    }

}


struct CheckInvitationData : Mappable {
    
    var id:String?
    var createdAt:String?
    var name:String?
    var phoneNumber:String?
    
    init?(map: ObjectMapper.Map) {
        
    }

    mutating func mapping(map: ObjectMapper.Map) {
        id <- map["id"]
        createdAt <- map["createdAt"]
        name <- map["name"]
        phoneNumber <- map["phoneNumber"]
    }

}
