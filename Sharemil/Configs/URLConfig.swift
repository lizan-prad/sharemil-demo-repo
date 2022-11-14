//
//  URLConfig.swift
//  VenueFinder
//
//  Created by Lizan on 08/06/2022.
//

import Foundation
import CoreData

enum URLConfig {
    
    static var baseUrl: String {
        return UserDefaults.standard.string(forKey: "ENV") == "P" ? "https://api.sharemil.com:443/" : "https://stage-api.sharemil.com:443/"
    }
    
}
