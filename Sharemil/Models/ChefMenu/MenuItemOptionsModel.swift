
import Foundation
import ObjectMapper

struct MenuItemOptionsModel : Mappable {
	var title : String?
	var choices: [ChoicesModel]?
	var multipleChoice : Bool?
    
    init() {}

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		title <- map["title"]
		choices <- map["choices:"]
        if choices == nil {
            choices <- map["choices"]
        }
		multipleChoice <- map["multipleChoice"]
	}

}

struct ChoicesModel : Mappable {
    
    var name : String?
    var price: Double?
    
    init() {}

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        name <- map["name"]
        price <- map["price:"]
        if price == nil {
            price <- map["price"]
        }
        
    }

}
