//
//  ChefListModel.swift
//  Sharemil
//
//  Created by lizan on 14/06/2022.
//

import Foundation
import ObjectMapper

class ChefListModel: Mappable {
    
    var id : String?
    var createdAt : String?
    var updatedAt : String?
    var isDeleted : Bool?
    var firsName : String?
    var lastName : String?
    var phoneNumber : String?
    var distance: Double?
    var email : String?
    var address : String?
    var suite : String?
    var city : String?
    var state : String?
    var hours : [HoursModel]?
    var postalCode : String?
    var countryCode : String?
    var cuisineId : String?
    var mainImageUrl : String?
    var preparationTime: String?
    var latitude: Double?
    var longitude: Double?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        isDeleted <- map["isDeleted"]
        firsName <- map["firsName"]
        lastName <- map["lastName"]
        phoneNumber <- map["phoneNumber"]
        email <- map["email"]
        distance <- map["distance"]
        address <- map["address"]
        suite <- map["suite"]
        city <- map["city"]
        state <- map["state"]
        postalCode <- map["postalCode"]
        countryCode <- map["countryCode"]
        cuisineId <- map["cuisineId"]
        mainImageUrl <- map["mainImageUrl"]
        preparationTime <- map["preparationTime"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        hours <- map["businessHours"]
    }
}
