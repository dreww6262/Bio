//
//  ContentLinkVC.swift
//  Bio
//
//  Created by Andrew Williamson on 9/28/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import WebKit

class ContentLinkVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var captionTextField = UITextField()
    var webHex: HexagonStructData?
    var userDataVM: UserDataVM?
    var linkType = "link"
    var webView = WKWebView()
    var showOpenAppButton = false
    
    var myRequest: URLRequest?
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        DispatchQueue.main.async {

            let wkWebConfig = WKWebViewConfiguration()
            self.webView = WKWebView(frame: self.view.bounds, configuration: wkWebConfig)
            self.view.addSubview(self.webView)
            self.webView.uiDelegate = self
            self.webView.navigationDelegate = self
            self.webView.allowsBackForwardNavigationGestures = false
            self.webView.autoresizesSubviews = true
            self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            let topConstraint = NSLayoutConstraint(item: self.webView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
//            let leftConstraint = NSLayoutConstraint(item: self.webView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
//            let widthConstraint = NSLayoutConstraint(item: self.webView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0)
//            let heightConstraint = NSLayoutConstraint(item: self.webView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1, constant: 0)
//            NSLayoutConstraint.activate([topConstraint, leftConstraint, widthConstraint, heightConstraint])
            self.loadLink()
        }
        
        //view.addSubview(webView)
        
        
//        if webHex?.text != "" {
//            self.captionTextField.isHidden = false
//            print("This is web hex text \(webHex?.text)")
//            setUpCaption()
//        }
//        else {
//           self.captionTextField.isHidden = true
//            print("This is web hex text \(webHex?.text)")
//            webView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 66)
//        }
        
        
//        print("This is webView.frame \(webView.frame)")
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.contentMode = .scaleAspectFit
    }
    
    func loadLink() {
        let link = self.webHex!.resource
        let myUrl = URL(string: link)
        if (myUrl != nil) {
            self.myRequest = URLRequest(url: myUrl!)
            self.webView.load(self.myRequest!)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }

//    func setUpCaption() {
//        view.addSubview(self.captionTextField)
//        var captionText = webHex?.text
//        self.captionTextField.text = captionText
//        let captionFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 66)
//        self.captionTextField.font = UIFont(name: "DINAlternate-Bold", size: 28)
//        self.captionTextField.textAlignment = .center
//        self.captionTextField.isUserInteractionEnabled = false
//        self.captionTextField.backgroundColor = .black
//        print("This is caption text \(captionText)")
//        print("This is text field text \(captionTextField.text)")
//        self.captionTextField.textColor = .white
//            self.captionTextField.frame = captionFrame
//            let webFrame = CGRect(x: 0, y: self.captionTextField.frame.maxY, width: view.frame.width, height: view.frame.height - 65 - 66)
//        self.webView.frame = webFrame
//        print("This is webView.frame \(self.webView.frame)")
//    }


}
