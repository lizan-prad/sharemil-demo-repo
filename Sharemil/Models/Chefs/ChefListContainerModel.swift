//
//  ChefListContainerModel.swift
//  Sharemil
//
//  Created by lizan on 14/06/2022.
//

import Foundation
import ObjectMapper

class ChefListContainerModel: Mappable {
    
    var chefs: [ChefListModel]?
    var cuisines: [CusineListModel]?
    
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
        chefs <- map["chefs"]
        cuisines <- map["cuisines"]
    }
}
