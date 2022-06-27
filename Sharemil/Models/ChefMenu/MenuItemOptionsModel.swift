
import Foundation
import ObjectMapper

struct MenuItemOptionsModel : Mappable {
	var title : String?
	var choices: [String]?
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
