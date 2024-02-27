//
//  StaticPageViewController.swift
//  Sharemil
//
//  Created by Rojan Shrestha on 2/19/24.
//

import UIKit
import WebKit
class StaticPageViewController: UIViewController {
    
    var urlLink = "https://sharemil.vercel.app/Terms%20Of%20Service.pdf"
    
    var pageTitle:String?{
        didSet{
            lblTitle.text = pageTitle ?? ""
        }
    }

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            setupWebView()
    }
    
    private func setupWebView() {
        
        if let url = URL.init(string: urlLink) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    @IBAction func buttonClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}

