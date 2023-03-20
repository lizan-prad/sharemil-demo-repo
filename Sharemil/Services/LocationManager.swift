//
//  LocationManager.swift
//  Sharemil
//
//  Created by Lizan on 13/06/2022.
//

import CoreLocation
import UIKit

protocol LocationManagerDelegate {
    
    func didUpdateLocation(_ manager: LocationManager, currentLocation location: LLocation?)
    func locationManager(_ manager: LocationManager, needsToPresentAlertController alert: UIAlertController)
    func didAuthorizeAccess(_ manager: LocationManager)
}

class LLocation: NSObject {
    
    var location: CLLocation?
    
    init(location: CLLocation?) {
        self.location = location
    }
}

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    var currentLocation: CLLocation?
    var locationManager: CLLocationManager?
    var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {return}
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.delegate?.didUpdateLocation(self, currentLocation: LLocation.init(location: locations.last))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            self.locationManager?.requestWhenInUseAuthorization()
            self.locationManager?.requestAlwaysAuthorization()
            break
        case .restricted, .denied:
            let alert = AlertServices.showAlertWithOkAction(title: nil, message: StringConstants.alertLocationAccess) { [weak self] _ in
                self?.locationManager?.requestWhenInUseAuthorization()
            }
            self.delegate?.locationManager(self, needsToPresentAlertController: alert)
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            self.delegate?.didAuthorizeAccess(self)
        @unknown default:
            let alert = AlertServices.showAlertWithOkAction(title: nil, message: StringConstants.alertLocationAccess) { [weak self] _ in
                self?.locationManager?.requestWhenInUseAuthorization()
            }
            self.delegate?.locationManager(self, needsToPresentAlertController: alert)
        }
    }
}
