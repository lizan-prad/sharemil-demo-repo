/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct HoursModel : Mappable {
	var createdAt : String?
	var updatedAt : String?
	var id : String?
	var isDeleted : Bool?
	var chefId : String?
	var day : String?
	var startTime : String?
	var endTime : String?
    var endTimeGmt: String?
    var startTimeGmt: String?
	var isOpen : Bool?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		createdAt <- map["createdAt"]
		updatedAt <- map["updatedAt"]
		id <- map["id"]
		isDeleted <- map["isDeleted"]
		chefId <- map["chefId"]
		day <- map["day"]
		startTime <- map["startTime"]
		endTime <- map["endTime"]
        startTimeGmt = "\(startTime ?? "") GMT"
        endTimeGmt = "\(endTime ?? "") GMT"
		isOpen <- map["isOpen"]
	}

}
