
import Foundation
import ObjectMapper

struct Cart : Mappable {
	var id : String?
	var createdAt : String?
	var chefId : String?
	var userId : String?
	var status : String?
    var cartItems: [CartItems]?
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		createdAt <- map["createdAt"]
		chefId <- map["chefId"]
		userId <- map["userId"]
		status <- map["status"]
        cartItems <- map["CartItems"]
	}

}
