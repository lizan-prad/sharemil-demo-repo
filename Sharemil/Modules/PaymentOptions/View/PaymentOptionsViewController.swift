//
//  PaymentOptionsViewController.swift
//  Sharemil
//
//  Created by lizan on 01/07/2022.
//

import UIKit

class PaymentOptionsViewController: UIViewController, Storyboarded {

    @IBOutlet weak var addCardView: UIView!
    var viewModel: PaymentOptionsViewModel!
    
    var cartId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        
    }
    
    private func setup() {
        addCardView.isUserInteractionEnabled = true
        addCardView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action:          #selector(openCardView)))
    }
  
    @objc private func openCardView() {
        self.viewModel.proceedPayment(cartId ?? "")
    }
}
