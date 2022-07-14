//
//  MyLocationModel.swift
//  Sharemil
//
//  Created by Lizan on 11/07/2022.
//


import Foundation
import ObjectMapper

struct MyLocationModel : Mappable {
    var createdAt : String?
    var updatedAt : String?
    var id : String?
    var isDeleted : Bool?
    var userId : String?
    var name : String?
    var latitude : Double?
    var longitude : Double?
    
    init() {}

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        id <- map["id"]
        isDeleted <- map["isDeleted"]
        userId <- map["userId"]
        name <- map["name"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }

}
