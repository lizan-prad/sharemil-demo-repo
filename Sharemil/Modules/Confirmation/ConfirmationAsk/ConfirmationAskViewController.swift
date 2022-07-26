//
//  ConfirmationAskViewController.swift
//  Sharemil
//
//  Created by Lizan on 26/07/2022.
//

import UIKit

class ConfirmationAskViewController: UIViewController {
    
    @IBOutlet weak var margin: UIView!
    @IBOutlet weak var chooseNetworkTitle: UILabel!
    @IBOutlet weak var smoke: UIView!
    
    @IBOutlet weak var container: UIView!

    var didApprove: (() -> ())?
    var didCancel: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @IBAction func yesAction(_ sender: Any) {
        self.didApprove?()
        self.dismissPopUp()
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        self.didCancel?()
        self.dismissPopUp()
    }
    
    @objc func dismissPopUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                    self.smoke.alpha = 0.0
                    
                }, completion: { _ in
                    self.dismiss(animated: true)
                })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.smoke.alpha = 0
        self.fogActivate()
    }

    private func setup() {
        self.container.addCornerRadius(16)
        smoke.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissPopUp)))
    }
    
    private func fogActivate() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear, animations: {
                    self.smoke.alpha = 0.4
                    
                }, completion: { _ in
                    
                })
    }
}
