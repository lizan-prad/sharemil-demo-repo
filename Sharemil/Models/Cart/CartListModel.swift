
import Foundation
import ObjectMapper

struct CartListModel : Mappable {
	var cart : Cart?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		cart <- map["cart"]
	}

}
