

import Foundation
import ObjectMapper

struct ChefMenuListModel : Mappable {
	var currency : String?
	var chefId : String?
	var description : String?
	var imageUri : String?
	var name : String?
	var id : String?
	var createdAt : String?
	var price : Double?
    var options: [MenuItemOptionsModel]?
    var dailySalesLimit: Int?
    init() {}
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		currency <- map["currency"]
		chefId <- map["chefId"]
		description <- map["description"]
		imageUri <- map["imageUri"]
		name <- map["name"]
		id <- map["id"]
		options <- map["options"]
		createdAt <- map["createdAt"]
		price <- map["price"]
        dailySalesLimit <- map["dailySaleLimit"]
	}

}
