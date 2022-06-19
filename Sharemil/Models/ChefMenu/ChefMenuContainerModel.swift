

import Foundation
import ObjectMapper

struct ChefMenuContainerModel : Mappable {
	var menu : [ChefMenuListModel]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		menu <- map["menu"]
	}

}
