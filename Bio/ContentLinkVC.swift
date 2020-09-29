//
//  ContentLinkVC.swift
//  Bio
//
//  Created by Andrew Williamson on 9/28/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import WebKit

class ContentLinkVC: UIViewController, WKUIDelegate {

    var webHex: HexagonStructData?
    
    var navBarView: NavBarView?
    var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let link = webHex!.resource
        let backButton1 = UIButton()
        let webLabel = UILabel()
        
        let webConfig = WKWebViewConfiguration()
        navBarView = NavBarView()
        navBarView?.titleLabel.text = "Link"
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(backWebHandler))
        navBarView?.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        //navBarView?.backButton.addGestureRecognizer(tapBack)
        let rect = CGRect(x: 0, y: navBarView!.frame.maxY, width: view.frame.width, height: view.frame.height - navBarView!.frame.height)
        webView = WKWebView(frame: rect, configuration: webConfig)
        webView?.uiDelegate = self
        view.addSubview(navBarView!)
        navBarView?.addBehavior()
        navBarView?.backgroundColor = .systemGray6
        navBarView?.addSubview(backButton1)
        navBarView?.addSubview(webLabel)
        
        webLabel.text = "Link"
        webLabel.frame = CGRect(x: navBarView!.frame.midX - 50, y: navBarView!.frame.midY - 5, width: 100, height: 30)
        webLabel.textAlignment = .center
        webLabel.font = UIFont(name: "DINAlternate-Bold", size: 20)
        
        
        backButton1.isUserInteractionEnabled = true
        backButton1.addGestureRecognizer(tapBack)
        backButton1.setTitle("Back", for: .normal)
        backButton1.setTitleColor(.systemBlue, for: .normal)
        backButton1.frame = CGRect(x: 5, y: navBarView!.frame.midY - 20, width: navBarView!.frame.width/8, height: self.view.frame.height/12)
        
        
        view.addSubview(webView!)
        let myUrl = URL(string: link)
        if (myUrl != nil) {
            let myRequest = URLRequest(url: myUrl!)
            webView?.load(myRequest)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView?.uiDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.presentingViewController?.viewWillAppear(animated)
    }
    
    @objc func backWebHandler(_ sender: UITapGestureRecognizer) {
        //webView
        webView?.removeFromSuperview()
        navBarView?.removeFromSuperview()
        webView = nil
        navBarView = nil
        self.dismiss(animated: false, completion: nil)
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
