//
//  PDFViewer.swift
//  Bio
//
//  Created by Ann McDonough on 1/18/21.
//  Copyright © 2021 Patrick McDonough. All rights reserved.
//

import UIKit
import WebKit
import PDFKit

class PDFViewer: UIViewController {
var navBarView = NavBarView()
var webView = WKWebView()
var pdfString = "Bio Beta Terms of Service"
var titleString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        setUpNavBarView()
setUpPDF2()
    }
    
    func setUpNavBarView() {
        var statusBarHeight = UIApplication.shared.statusBarFrame.height
        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        var navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
       // navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
        navBarView.backButton.setTitleColor(.black, for: .normal)
        self.navBarView.backgroundColor = .clear//.systemGray6
//        self.navBarView.addSubview(toSettingsButton)
//        self.navBarView.addSubview(toSearchButton)
//
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        backTap.numberOfTapsRequired = 1
        navBarView.backButton.isUserInteractionEnabled = true
        navBarView.backButton.addGestureRecognizer(backTap)

        navBarView.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 34, height: 34)

        let yOffset = navBarView.frame.maxY
    //    self.webView.frame = CGRect(x: 0, y: yOffset, width: self.view.frame.width, height: self.view.frame.height - yOffset)
      //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = titleString
        self.navBarView.titleLabel.textColor = .black
        print("This is navBarView.")
  //      self.navBarView.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 34, height: 34)
        self.navBarView.postButton.frame = CGRect(x: navBarView.frame.width - 50, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 40, height: 34)
        self.navBarView.postButton.titleLabel?.sizeToFit()
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: self.navBarView.postButton.frame.minY, width: 200, height: 25)
        
     //   self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: self.navBarView.backButton.frame.minY, width: 200, height: 25)
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            navBarView.backButton.setImage(UIImage(named: "blackChevron"), for: .normal)
            navBarView.titleLabel.textColor = .black
            navBarView.backgroundColor = .systemGray6
        case .dark:
            navBarView.backButton.setImage(UIImage(named: "whiteChevron"), for: .normal)
            navBarView.backgroundColor = .black
            navBarView.titleLabel.textColor = .white
        }

    }
    
    @objc func backButtonpressed() {
        print("It should dismiss here")
        self.dismiss(animated: true)
    }
    
    func setUpPDF2() {
        let pdfView = PDFView(frame: self.view.bounds)
          pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
          self.view.addSubview(pdfView)
        pdfView.frame = CGRect(x: 0, y: self.navBarView.frame.maxY, width: view.frame.width, height: view.frame.height - self.navBarView.frame.maxY)
          
          // Fit content in PDFView.
          pdfView.autoScales = true
          
          // Load Sample.pdf file from app bundle.
          let fileURL = Bundle.main.url(forResource: pdfString, withExtension: "pdf")
        print("This is file URL \(fileURL)")
          pdfView.document = PDFDocument(url: fileURL!)
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
