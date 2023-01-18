//
//  PickUpViewController.swift
//  Sharemil
//
//  Created by Lizan on 18/01/2023.
//

import UIKit

class PickUpViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var arrivedBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    var viewModel: PickUpViewModel!
    var didDismiss: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
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
        
    }
    
    @IBAction func arrivedAction(_ sender: Any) {
        
    }
}
