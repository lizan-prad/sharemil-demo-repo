//
//  ShowDirectionViewController.swift
//  Sharemil
//
//  Created by Lizan on 17/08/2022.
//

import UIKit
import MapKit

class ShowDirectionViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var smoke: UIView!
    @IBOutlet weak var chooseNetworkTitle: UILabel!
    
    @IBOutlet weak var container: UIView!
    var chef: ChefListModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        googleView.isUserInteractionEnabled = true
        googleView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openGoogleMaps)))
        
        appleView.isUserInteractionEnabled = true
        appleView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openAppleMaps)))
        self.container.addCornerRadius(16)
        smoke.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissPopUp)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.smoke.alpha = 0
        self.fogActivate()
    }
    
    private func fogActivate() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear, animations: {
                    self.smoke.alpha = 0.4
                    
                }, completion: { _ in
                    
                })
    }
    
    @objc func dismissPopUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                    self.smoke.alpha = 0.0
                    
                }, completion: { _ in
                    self.dismiss(animated: true)
                })
        
    }
    
    @objc private func openGoogleMaps() {
        
        guard let lat = chef?.latitude else {return }
        guard let long = chef?.longitude else {return }
        
        if let url = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(lat),\(long)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            UIApplication.shared.open(url, options: [:])
        }
        
    }
        
//        self.dismissPopUp()
    
    @objc private func openAppleMaps() {
        guard let lat = chef?.latitude else {return }
        guard let long = chef?.longitude else {return }
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: loc?.location?.coordinate.latitude ?? 0, longitude: loc?.location?.coordinate.longitude ?? 0)))
        source.name = "Source"
                
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long)))
        destination.name = "Destination"
                
        MKMapItem.openMaps(
          with: [source, destination],
          launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        )
//        self.dismissPopUp()
    }

}
