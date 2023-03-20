//
//  ChefListContainerModel.swift
//  Sharemil
//
//  Created by lizan on 14/06/2022.
//

import Foundation
import ObjectMapper

class ChefListContainerModel: Mappable {
    var chef: ChefListModel?
    var chefs: [ChefListModel]?
    var cuisines: [CusineListModel]?
    
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
        chef <- map["chef"]
        chefs <- map["chefs"]
        cuisines <- map["cuisines"]
    }
}
