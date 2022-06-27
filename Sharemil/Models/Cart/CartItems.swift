

import Foundation
import ObjectMapper

struct CartItems : Mappable {
	var id : String?
	var createdAt : String?
	var cartId : String?
	var menuItemId : String?
	var quantity : Int?
	var options : [MenuItemOptionsModel]?

    init() {}
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		createdAt <- map["createdAt"]
		cartId <- map["cartId"]
		menuItemId <- map["menuItemId"]
		quantity <- map["quantity"]
		options <- map["options"]
	}

}
