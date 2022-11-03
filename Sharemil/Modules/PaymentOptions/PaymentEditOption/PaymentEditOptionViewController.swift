//
//  PaymentEditOptionViewController.swift
//  Sharemil
//
//  Created by Lizan on 28/09/2022.
//

import UIKit

class PaymentEditOptionViewController: UIViewController, Storyboarded {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var smoke: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var defaultView: UIView!
    
    var didSelectDefault: ((String?) -> ())?
    var didSelectDelete: ((String?) -> ())?
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.deleteView.isHidden = id == nil
        deleteView.isUserInteractionEnabled = true
        deleteView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(deleteAction)))
        
        defaultView.isUserInteractionEnabled = true
        defaultView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(defaultAction)))
        self.container.addCornerRadius(16)
        smoke.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissPopUp)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.smoke.alpha = 0
        self.fogActivate()
    }
    
    @objc private func defaultAction() {
        self.didSelectDefault?(id)
        self.dismiss(animated: true)
    }
    
    @objc private func deleteAction() {
        self.didSelectDelete?(id)
        self.dismiss(animated: true)
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
}
