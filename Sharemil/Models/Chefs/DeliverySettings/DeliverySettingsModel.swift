//
//  DeliverySettingsModel.swift
//  Sharemil
//
//  Created by Lizan on 10/05/2023.
//

import Foundation
import ObjectMapper

class DeliverySettingsModel: Mappable {
    
    var chefId: String?
    var id: String?
    var deliveryEnabled: Bool?
    var minOrderAmount: Int?
    var deliveryRadius: Int?
    var sameDayDelivery: Bool?
    var sameDayDeliveryOrderBy: String?
    
    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        chefId <- map["chefId"]
        id <- map["id"]
        deliveryEnabled <- map["deliveryEnabled"]
        minOrderAmount <- map["minOrderAmount"]
        deliveryRadius <- map["radius"]
        sameDayDelivery <- map["sameDayDelivery"]
        sameDayDeliveryOrderBy <- map["sameDayDeliveryOrderBy"]
    }
}
