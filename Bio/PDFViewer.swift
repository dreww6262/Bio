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
var pdfString = "Bio Beta Terms and Conditions"
var titleString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        setUpNavBarView()
        setUpPDF2()
    }
    
    func setUpNavBarView() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        //        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        let navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        // navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
        navBarView.backButton.setTitleColor(.black, for: .normal)
        self.navBarView.backgroundColor = .clear//UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00).cgColor


        //        self.navBarView.addSubview(toSettingsButton)
        //        self.navBarView.addSubview(toSearchButton)
        //
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        backTap.numberOfTapsRequired = 1
        navBarView.backButton.isUserInteractionEnabled = true
        navBarView.backButton.addGestureRecognizer(backTap)
        
        navBarView.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 34, height: 34)
        
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = titleString
        self.navBarView.titleLabel.textColor = .black
        self.navBarView.postButton.frame = CGRect(x: navBarView.frame.width - 50, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 40, height: 34)
        self.navBarView.postButton.titleLabel?.sizeToFit()
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: self.navBarView.postButton.frame.minY, width: 200, height: 25)
        
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            navBarView.backButton.setImage(UIImage(named: "blackChevron"), for: .normal)
            navBarView.titleLabel.textColor = .black
            navBarView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
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
        guard let fileURL = Bundle.main.url(forResource: pdfString, withExtension: "pdf") else {
            let alert = UIAlertController(title: "File Unavailable", message: "Try again later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        //print("This is file URL \(fileURL)")
        pdfView.document = PDFDocument(url: fileURL)
    }
}
