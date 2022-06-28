
import Foundation
import ObjectMapper

struct CartListModel : Mappable {
	var cart : Cart?
    var carts: [Cart]?
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {
        carts <- map["carts"]
		cart <- map["cart"]
	}

}
