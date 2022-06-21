//
//  SaveLocationViewController.swift
//  Sharemil
//
//  Created by lizan on 21/06/2022.
//

import UIKit
import GooglePlaces

class SaveLocationViewController: UIViewController, Storyboarded {

    @IBOutlet weak var smoke: UIView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var locationContainer: UIView!
    @IBOutlet weak var nameContainer: UIView!
    
    var location: GMSPlace?
    var didCompleteSaving: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupData()
    }
    
    private func setupData() {
        self.locationField.text = location?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fogActivate()
    }
    
    private func setup() {
        container.addCornerRadius(15)
        locationContainer.addBorder(.black)
        nameContainer.addBorder(.black)
        self.smoke.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissPopUp)))
    }
    
    private func fogActivate() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear, animations: {
            self.smoke.alpha = 0.4
            
        }, completion: { _ in
            
        })
    }
    
    @objc private func dismissPopUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                    self.smoke.alpha = 0.0
                    
                }, completion: { _ in
                    self.dismiss(animated: true)
                })
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        UserDefaults.standard.set("\(nameLabel.text ?? "")---\(locationField.text ?? "")", forKey: "SAVEDLOC")
        self.didCompleteSaving?()
        self.dismissPopUp()
    }
    
}
