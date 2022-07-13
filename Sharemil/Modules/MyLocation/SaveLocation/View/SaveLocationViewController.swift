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
    var didCompleteUpdating: (() -> ())?
    var viewModel: SaveLocationViewModel!
    var model: MyLocationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
        if model != nil {
            self.setupDataFromModel()
        } else {
            setupData()
        }
    }
    
    private func setupDataFromModel() {
        self.showProgressHud()
         GoogleMapsServices.shared.getAddress(LLocation.init(location: CLLocation.init(latitude: model?.latitude ?? 0, longitude: model?.longitude ?? 0)), completion: { address in
             self.hideProgressHud()
             self.locationField.text = address
        })
        self.nameLabel.text = model?.name
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.success.bind { msg in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.dismissPopUp()
            }
        }
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
        self.smoke.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissPop)))
    }
    
    private func fogActivate() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear, animations: {
            self.smoke.alpha = 0.4
            
        }, completion: { _ in
            
        })
    }
    
    @objc private func dismissPop() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.smoke.alpha = 0.0
            
        }, completion: { _ in
            self.dismiss(animated: true) {
                
            }
        })
        
    }
    
    @objc private func dismissPopUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.smoke.alpha = 0.0
            
        }, completion: { _ in
            self.dismiss(animated: true) {
                if self.model == nil {
                    self.didCompleteSaving?()
                } else {
                    self.didCompleteUpdating?()
                }
            }
        })
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if model == nil {
        self.viewModel.saveUserLocation(nameLabel.text ?? "", location: LLocation.init(location: CLLocation.init(latitude: location?.coordinate.latitude ?? 0, longitude: location?.coordinate.longitude ?? 0)))
        } else {
            self.viewModel.updateLocation(nameLabel.text ?? "", id: model?.id ?? "", location: LLocation.init(location: CLLocation.init(latitude: model?.latitude ?? 0, longitude: model?.longitude ?? 0)))
        }
    }
    
}
