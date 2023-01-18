//
//  PickUpViewController.swift
//  Sharemil
//
//  Created by Lizan on 18/01/2023.
//

import UIKit

class PickUpViewController: UIViewController, Storyboarded, UITextViewDelegate {

    @IBOutlet weak var arrivedBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    var viewModel: PickUpViewModel!
    var didDismiss: (() -> ())?
    var orderId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.bindViewModel()
    }
    
    private func setup() {
        self.arrivedBtn.disable()
        textView.text = "Please fill any necessary pickup details"
        textView.textColor = UIColor.lightGray
        self.textView.delegate = self
        self.textView.textContainer.lineFragmentPadding = 16
        self.textView.addBorder(.lightGray)
        self.textView.addCornerRadius(16)
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.success.bind { msg in
            self.showToastMsg(msg ?? "", state: .success, location: .bottom)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.dismiss(animated: true) {
                    self.didDismiss?()
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        ( textView.text == "" || textView.text == nil ) ? self.arrivedBtn.disable() : self.arrivedBtn.enable()
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please fill any necessary pickup details"
            textView.textColor = UIColor.lightGray
        }
    }

 
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func arrivedAction(_ sender: Any) {
        self.viewModel.setCustomerArrival(self.orderId ?? "", textView.text)
    }
}
