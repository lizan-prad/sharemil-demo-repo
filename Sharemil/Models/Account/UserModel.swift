

import Foundation
import ObjectMapper

struct UserModel : Mappable {
	var id : String?
	var firstName : String?
	var lastName : String?
	var phoneNumber : String?
	var email : String?
    var profileImage: String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		firstName <- map["firstName"]
		lastName <- map["lastName"]
		phoneNumber <- map["phoneNumber"]
		email <- map["email"]
        profileImage <- map["profileImage"]
	}
    
    func isValid() -> Bool {
        return (firstName != "" || firstName != nil) && (lastName != nil || lastName != "") && (phoneNumber != nil || phoneNumber != "") && (email != nil || email != "")
    }

}
