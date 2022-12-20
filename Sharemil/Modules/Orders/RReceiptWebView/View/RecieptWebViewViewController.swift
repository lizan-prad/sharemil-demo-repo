//
//  RecieptWebViewViewController.swift
//  Sharemil
//
//  Created by Lizan on 03/12/2022.
//

import UIKit
import WebKit

class RecieptWebViewViewController: UIViewController, Storyboarded, WKNavigationDelegate, UIDocumentPickerDelegate {
    
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
        if #available(iOS 14.0, *) {
            let documentPicker =
            UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
            documentPicker.delegate = self

            // Set the initial directory.

            // Present the document picker.
            present(documentPicker, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
        
        
        //Render the PDF
          
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let render = UIPrintPageRenderer()
            render.addPrintFormatter(webView.viewPrintFormatter(), startingAtPageAt: 0);


            let page = CGRect(x: 0, y: 10, width: webView.frame.size.width, height: webView.frame.size.height) // take the size of the webView
            let printable = page.insetBy(dx: 0, dy: 0)
            render.setValue(NSValue(cgRect: page), forKey: "paperRect")
            render.setValue(NSValue(cgRect: printable), forKey: "printableRect")

            // 4. Create PDF context and draw
            let pdfData = NSMutableData()
            UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
            for i in 1...render.numberOfPages {

                UIGraphicsBeginPDFPage();
                let bounds = UIGraphicsGetPDFContextBounds()
                render.drawPage(at: i - 1, in: bounds)
            }
            UIGraphicsEndPDFContext();
        guard let url = urls.first?.startAccessingSecurityScopedResource() else {return}

        pdfData.write(toFile: "\(urls.first?.absoluteString ?? "")/invoice-\(Date().timeIntervalSince1970).pdf", atomically: true)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
