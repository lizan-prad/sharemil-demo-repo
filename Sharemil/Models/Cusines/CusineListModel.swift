//
//  CusineListModel.swift
//  Sharemil
//
//  Created by lizan on 17/06/2022.
//

import Foundation
import ObjectMapper

class CusineListModel: Mappable {
    
    var id : String?
    var createdAt : String?
    var updatedAt : String?
    var isDeleted : Bool?
    var name : String?
    var imageUrl : String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        isDeleted <- map["isDeleted"]
        name <- map["name"]
        imageUrl <- map["imageUri"]
    }
    
}
