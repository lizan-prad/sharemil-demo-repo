//
//  GoogleMapsServices.swift
//  Sharemil
//
//  Created by lizan on 18/06/2022.
//

import Foundation
import GooglePlaces
import GoogleMaps

class GoogleMapsServices {
    
    static let shared = GoogleMapsServices()
    
    func getAddress(_ location: LLocation, completion: @escaping (String) -> ()) {
        let geocoder = GMSGeocoder()
        guard let cordinates = location.location?.coordinate else {return}
        geocoder.reverseGeocodeCoordinate(cordinates) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]

                let address = lines.joined(separator: ",")
                completion(address)
            }
        }
    }
}
