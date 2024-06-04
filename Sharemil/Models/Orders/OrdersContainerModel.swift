

import Foundation
import ObjectMapper

struct OrdersContainerModel : Mappable {
	var order : [OrderModel]?
    var orders : OrderModel?
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {
        orders <- map["order"]
		order <- map["order"]
	}

}
