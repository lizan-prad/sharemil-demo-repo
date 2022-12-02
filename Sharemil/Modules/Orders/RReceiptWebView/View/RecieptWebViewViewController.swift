//
//  RecieptWebViewViewController.swift
//  Sharemil
//
//  Created by Lizan on 03/12/2022.
//

import UIKit
import WebKit

class RecieptWebViewViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var container: UIView!
    var webView: WKWebView!
    
    var recieptUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
       
    }

    private func setupWebView() {
        self.webView = WKWebView.init(frame: container.bounds)
        self.container.addSubview(self.webView)
        if let url = URL.init(string: recieptUrl ?? "") {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
