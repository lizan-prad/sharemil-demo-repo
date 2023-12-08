//
//  SpecialInstructionViewController.swift
//  Sharemil
//
//  Created by Rojan on 05/12/2023.
//

import UIKit

protocol SpecialInstructionDelegate: AnyObject {
    func didSaveInstruction(txt:String)
}

class SpecialInstructionViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnInstructions: UIButton!
    @IBOutlet weak var txtView: UITextView!
    
    weak var delegate: SpecialInstructionDelegate?
    var selectedInstruction:String?{
        didSet{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {[weak self] in
                self?.txtView.text = self?.selectedInstruction != "" ? self?.selectedInstruction : StringConstants.intructionLabelPlaceholder
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupContainerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fogActivate()
    }
    
    private func setupView(){
        txtView.addStandardBorder()
        btnInstructions.rounded()
        setupContainerView()
        txtView.delegate = self
        txtView.textColor = UIColor.lightGray
        bgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapClose)))
    }
    
    func setupContainerView(){
        containerView.roundCorners(corners: [.topLeft,.topRight], radius: 20)
    }
    
    @objc func didTapClose(){
        dismissPopUp()
    }

    @IBAction func buttonInstructions(_ sender: Any) {
        delegate?.didSaveInstruction(txt: txtView.text)
        dismissPopUp()
    }
    
    private func fogActivate() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear, animations: {
            self.bgView.alpha = 0.4
            
        }, completion: { _ in
            
        })
    }
    
    
    @objc private func dismissPopUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.bgView.alpha = 0.0
            
        }, completion: { _ in
            self.dismiss(animated: true)
        })
    }
    
}

extension SpecialInstructionViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtView.text == StringConstants.intructionLabelPlaceholder {
            txtView.text = ""
            txtView.textColor = UIColor.black
        }
    }
    
}
