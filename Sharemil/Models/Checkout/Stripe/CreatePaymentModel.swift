//
//  CreatePaymentModel.swift
//  Sharemil
//
//  Created by Lizan on 26/07/2022.
//

import Foundation
import ObjectMapper

class CreatePaymentModel: Mappable {
    
    var paymentIntentId: String?
    var requireAction: Int?
    var subTotal: String?
    var tax: String?
    var total: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        paymentIntentId <- map["payment_intent_client_secret"]
        requireAction <- map["requires_action"]
        subTotal <- map["subTotal"]
        tax <- map["tax"]
        total <- map["total"]
    }
}
