//
//  RecieptWebViewViewController.swift
//  Sharemil
//
//  Created by Lizan on 03/12/2022.
//

import UIKit
import WebKit

class RecieptWebViewViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var webView: WKWebView!
   
    
    var recieptUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
        
        closeBtn.rounded()
    }

    private func setupWebView() {
        
        if let url = URL.init(string: recieptUrl ?? "") {
            let request = URLRequest(url: url)
            self.webView.load(request)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.webView.scrollView.setZoomScale(3.0, animated: true)
            }
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
