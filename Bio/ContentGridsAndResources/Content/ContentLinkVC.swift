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
    let webConfig = WKWebViewConfiguration()
    
    var myRequest: URLRequest?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        view.addSubview(webView)
        loadLink()
        
        if webHex?.text != "" {
            self.captionTextField.isHidden = false
            print("This is web hex text \(webHex?.text)")
            setUpCaption()
        }
        else {
           self.captionTextField.isHidden = true
            print("This is web hex text \(webHex?.text)")
            webView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 66)
        }
        
        
        print("This is webView.frame \(webView.frame)")
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if myRequest != nil {
//            webView.load(myRequest!)
//        }
    }
    
    func loadLink() {
        let link = webHex!.resource
        let myUrl = URL(string: link)
        if (myUrl != nil) {
            myRequest = URLRequest(url: myUrl!)
            print("should be loading url!")
            webView.load(myRequest!)
        }
    }
    

    func setUpCaption() {
        view.addSubview(self.captionTextField)
        var captionText = webHex?.text
        self.captionTextField.text = captionText
        let captionFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 66)
        self.captionTextField.font = UIFont(name: "DINAlternate-Bold", size: 28)
        self.captionTextField.textAlignment = .center
        self.captionTextField.isUserInteractionEnabled = false
        self.captionTextField.backgroundColor = .black
        print("This is caption text \(captionText)")
        print("This is text field text \(captionTextField.text)")
        self.captionTextField.textColor = .white
            self.captionTextField.frame = captionFrame
            let webFrame = CGRect(x: 0, y: self.captionTextField.frame.maxY, width: view.frame.width, height: view.frame.height - 65 - 66)
        self.webView.frame = webFrame
        print("This is webView.frame \(self.webView.frame)")
    }


}
