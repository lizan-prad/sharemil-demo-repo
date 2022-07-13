//
//  GoogleMapsServices.swift
//  Sharemil
//
//  Created by lizan on 18/06/2022.
//

import Foundation
import GooglePlaces
import GoogleMaps
import Alamofire
import SwiftyJSON
import ObjectMapper

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

    func getRoutes(_ origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping ([Routes]) -> ()) {
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=34.062469,-118.305718&destination=\(34.06915277223104),\(-118.2931372947856)&mode=driving&key=AIzaSyDSiFR_IXzPLoKoQnzDcPavcAGThhmW55M"
        AF.request(url).responseJSON { response in
            if let data = response.value {
                if let model = Mapper<GoogleDirectionBaseModel>().map(JSONObject: data), let routes = model.routes {
                    completion(routes)
                }
            }

        }
    }
}
