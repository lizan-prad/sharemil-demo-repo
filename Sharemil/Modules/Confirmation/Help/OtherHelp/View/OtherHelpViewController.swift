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
