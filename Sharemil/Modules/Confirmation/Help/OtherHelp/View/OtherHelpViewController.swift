//
//  OtherHelpViewController.swift
//  Sharemil
//
//  Created by Lizan on 16/02/2023.
//

import UIKit

class OtherHelpViewController: UIViewController, Storyboarded, UITextViewDelegate {
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var titelField: UITextField!
    
    var viewModel: OtherHelpViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
 
    private func setup() {
        validate()
        bindViewModel()
        titelField.addTarget(self, action: #selector(titleChanged), for: .editingChanged)
        titelField.addCornerRadius(8)
        detailsTextView.text = "Please describe in details (Optional)"
        detailsTextView.textColor = UIColor.lightGray
        self.detailsTextView.delegate = self
        self.detailsTextView.textContainer.lineFragmentPadding = 16
        self.detailsTextView.addCornerRadius(16)
    }
    
    @objc func titleChanged() {
        self.validate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        self.viewModel.createSupportTicket(self.titelField.text ?? "", self.detailsTextView.text)
    }
    
    private func bindViewModel() {
        self.viewModel.loading.bind { status in
            status ?? true ? self.showProgressHud() : self.hideProgressHud()
        }
        self.viewModel.error.bind { msg in
            self.showToastMsg(msg ?? "", state: .error, location: .bottom)
        }
        self.viewModel.issues.bind { msg in
            self.showToastMsg(msg ?? "", state: .success, location: .bottom)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.dismiss(animated: true) {
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please describe in details (Optional)"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        validate()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func validate() {
        (self.detailsTextView.text != "Please describe in details (Optional)" || self.detailsTextView.text != "") && (titelField.text != "" || titelField.text != nil) ? continueBtn.enable() : continueBtn.disable()
    }
}
