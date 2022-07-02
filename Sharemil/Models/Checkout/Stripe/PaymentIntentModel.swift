

import Foundation
import ObjectMapper

struct PaymentIntentModel : Mappable {
	var publishableKey : String?
	var customer : String?
	var ephemeralKey : String?
	var paymentIntent : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		publishableKey <- map["publishableKey"]
		customer <- map["customer"]
		ephemeralKey <- map["ephemeralKey"]
		paymentIntent <- map["paymentIntent"]
	}

}
