//
//  MyLocationContainerModel.swift
//  Sharemil
//
//  Created by Lizan on 11/07/2022.
//

import Foundation
import ObjectMapper

struct MyLocationContainerModel : Mappable {
    
    var locations : [MyLocationModel]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        locations <- map["locations"]
    }

}

