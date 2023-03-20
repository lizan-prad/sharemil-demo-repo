

import Foundation
import ObjectMapper

struct UserContainerModel : Mappable {
	var user : UserModel?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		user <- map["user"]
	}

}
