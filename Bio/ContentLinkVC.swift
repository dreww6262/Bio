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

    var webHex: HexagonStructData?
    
    var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var newSafeArea = UIEdgeInsets()
        newSafeArea.bottom = 10
        newSafeArea.top = 50
        newSafeArea.right = 0
        newSafeArea.left = 0
        self.additionalSafeAreaInsets = newSafeArea
        
        let webConfig = WKWebViewConfiguration()

        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 65)
        webView = WKWebView(frame: frame, configuration: webConfig)
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        webView?.allowsBackForwardNavigationGestures = false
        view.addSubview(webView!)
        
        
        let link = webHex!.resource
        let myUrl = URL(string: link)
        if (myUrl != nil) {
            let myRequest = URLRequest(url: myUrl!)
            webView?.load(myRequest)
        }
        // Do any additional setup after loading the view.
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
