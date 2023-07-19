
import Foundation
import ObjectMapper

struct OrderModel : Mappable {
	var id : String?
	var createdAt : String?
	var cartId : String?
	var subTotal : Double?
	var tax : Int?
	var total : Double?
	var currency : String?
    var pickupTime: String?
	var status : String?
    var receiptUrl: String?
	var cart : Cart?
    var orderNumber: Int?
    var customerIsHere: Bool?
    var customerNote: String?
    var deliverAddress: String?
    var deliverTime: String?
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {
        deliverAddress <- map["deliveryAddress"]
		id <- map["id"]
		createdAt <- map["createdAt"]
		cartId <- map["cartId"]
		subTotal <- map["subTotal"]
		tax <- map["tax"]
		total <- map["total"]
		currency <- map["currency"]
        customerIsHere <- map["customerIsHere"]
        customerNote <- map["customerNote"]
		status <- map["status"]
        receiptUrl <- map["receiptUrl"]
		cart <- map["Cart"]
        pickupTime <- map["pickupTime"]
        orderNumber <- map["orderNumber"]
        deliverTime <- map["deliveryTime"]
	}

}
