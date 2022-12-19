//
//  RecieptWebViewViewController.swift
//  Sharemil
//
//  Created by Lizan on 03/12/2022.
//

import UIKit
import WebKit

class RecieptWebViewViewController: UIViewController, Storyboarded, WKNavigationDelegate {
    
    @IBOutlet weak var download: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var webView: WKWebView!
   
    
    var recieptUrl: String?
    var downloadUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
        webView.navigationDelegate = self
        closeBtn.rounded()
        self.download.isHidden = true
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
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        if navigationAction.request.url?.absoluteString.contains("https://dashboard.stripe.com/receipts/invoices/") ?? false {
            self.download.isHidden = false
            self.downloadUrl = navigationAction.request.url?.absoluteString
        }
        decisionHandler(.allow)
    }

    @IBAction func downlaodBtn(_ sender: Any) {
        let config = WKPDFConfiguration.init()
        
        //Set the page size (this can match the html{} size in your CSS
        
        if #available(iOS 14.0, *) {
            config.rect = CGRect(x: 0, y: 0, width: 792, height: 612)
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 14.0, *) {
            webView.createPDF(configuration: config){ result in
                switch result{
                case .success(let data):
                    var docURL = (FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)).last
                    
                    var new = (docURL?.absoluteString ?? "") + "invoice-\(Date().timeIntervalSince1970).pdf"
                    if #available(iOS 16.0, *) {
                        do {
                            try data.write(to: URL.init(filePath: new))
                            DispatchQueue.main.async {
                                self.showToastMsg("Saved!!", state: .success, location: .bottom)
                            }
                        } catch {
                            print(error)
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        //Render the PDF
          
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
