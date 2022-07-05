

import Foundation
import ObjectMapper

struct OrdersContainerModel : Mappable {
	var order : [OrderModel]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		order <- map["order"]
	}

}
