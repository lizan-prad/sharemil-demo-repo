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
    var businessName: String?
    var hours : [HoursModel]?
    var deliveryHours: [HoursModel]?
    var deliverySettings: DeliverySettingsModel?
    var postalCode : String?
    var countryCode : String?
    var cuisineId : String?
    var mainImageUrl : String?
    var preparationTime: String?
    var latitude: Double?
    var longitude: Double?
    var isOpen: Bool?
    var note: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        isDeleted <- map["isDeleted"]
        firsName <- map["firstName"]
        lastName <- map["lastName"]
        businessName <- map["businessName"]
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
        deliveryHours <- map["deliveryHours"]
        deliverySettings <- map["deliverySettings"]
        note <- map["note"]
        isOpen = isOpenToday()
    }
    
    private func isOpenToday() -> Bool {
        let date            = Date()
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "EEE"
        let currentDay = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm:ss"
        let currentHour = hours?.filter({$0.day?.capitalized == currentDay}).first
        let today = dateFormatter.string(from: date)
        let origToday = dateFormatter.date(from: today) ?? Date()
        let start = dateFormatter.date(from: currentHour?.startTime ?? "") ?? Date()
        let end = dateFormatter.date(from: currentHour?.endTime ?? "") ?? Date()
        return (origToday > start) && (origToday < end)
    }
}



