//
//  AcknowledgementsVC.swift
//  Bio
//
//  Created by Ann McDonough on 1/22/21.
//  Copyright © 2021 Patrick McDonough. All rights reserved.
//
import UIKit
import Firebase
import QuickTableViewController
import FirebaseFirestore

class AcknowledgementsVC: QuickTableViewController {
    
    var navBarView = NavBarView()
    
    
    //var tabController = NavigationMenuBaseController()
    var userDataVM: UserDataVM?
    //var menuView = MenuView()
    var myAccountArray = ["Name",
                          "Username",
                          "Birthday", "Followers", "Following",
                          "Country",
                          "Phone Number",
                          "Email",
                          "Password",
                          "Two-Factor Authentication"]
    var supportArray: [String] = ["FAQs",
                                  "I spotted a bug",
                                  "I have a Suggestion",
                                  "Privacy Policy",
                                  "Terms and Conditions",
                                  "Report User"]
    var accountActionsArray = ["Log Out"]
    
   var mitLicenseArray = ["This software uses QuickTableView - See License", "This software uses SDWebImage - See License", "This software uses YPImagePicker - See License", "This software uses MRCountryPicker - See License", "This software uses MapKit - See License", "This software uses PDFKit - See License", "This software uses IQKeyboardManagerSwift - See License"]
   var mitLicensePDFTitleArray = ["MIT License - QuickTableView","MIT License - SDWebImage","MIT License - YPImagePicker","MIT License - MRCountryPicker","MIT License - MapKit","MIT License - PDFKit","MIT License - IQKeyboardManagerSwift"]

    
    var settingsTitleArray: [String] = ["Name",
                                        "Username",
                                        "Birthday",
                                        "Country",
                                        "Phone Number",
                                        "Email",
                                        "CHange Password",
                                        "Two-Factor Authentication", "FAQs",
                                        "I spotted a bug",
                                        "I have a Suggestion",
                                        "Privacy Policy",
                                        "Terms and Conditions",
                                        "Report User", "Log Out"]
    
    var user = "\(Auth.auth().currentUser?.email ?? "")"
    var name = "\(Auth.auth().currentUser?.displayName ?? "")"
    var birthday = "1/1/2020"
 //   var country = Auth.auth().currentUser?.
    var phoneNumber = "xxx-xxx-xxxx"
    var email = "\(Auth.auth().currentUser?.email ?? "")"
    var password = "xxxxxxxxxxxxxx"
    var twoFactorAuth = "false"
    var myAccountUserData: [String] = []
    var myAccountArraySupportArrayCombined: [String] = []
    var userDataCombinedArray: [String] = []
    var backButton1 = UIButton()
    var titleLabel1 = UILabel()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var bio = ""
    
    override func viewDidLoad() {
  
        super.viewDidLoad()
        let userData = userDataVM?.userData.value
        setUpNavBarView()
        navBarView.backgroundColor = .systemGray6
        var myBirthday = userData?.birthday
        //
        tableContents = [
            Section(title: "Acknowlegements", rows: [
                        NavigationRow(text: mitLicenseArray[0], detailText: .value1(name)!, icon: .named("gear"), action: didToggleSelection()),
                        NavigationRow(text: mitLicenseArray[1], detailText: .value1(email)!, icon: .named("globe"), action: didToggleSelection()), NavigationRow(text: mitLicenseArray[2], detailText: .none, icon: .none, action: didToggleSelection()),
                        NavigationRow(text: mitLicenseArray[3], detailText: .none, icon: .none, action: didToggleSelection()),
                        NavigationRow(text: mitLicenseArray[4], detailText: .value1(myBirthday ?? ""), icon: .none, action: didToggleSelection()),
                        NavigationRow(text: mitLicenseArray[5], detailText: .value1(userData?.country ?? ""), action: didToggleSelection()), NavigationRow(text: mitLicenseArray[6], detailText: .value1(userData?.bio ?? ""), action: didToggleSelection())])]
                       
        
        
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
        self.tableView.frame = CGRect(x: 0, y: yOffset, width: self.view.frame.width, height: self.view.frame.height - yOffset)
      //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Acknowledgements"
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
        case .dark:
            navBarView.backButton.setImage(UIImage(named: "whiteChevron"), for: .normal)
            navBarView.titleLabel.textColor = .white
        }

    }
    
    
    @objc func backButtonpressed() {
        print("It should dismiss here")
        self.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // tap to dismissSettings
        //        let dismissTap = UITapGestureRecognizer(target: backButton1, action: #selector(self.backButtonpressed))
        //                dismissTap.numberOfTapsRequired = 1
        //                self.backButton1.isUserInteractionEnabled = true
        //                self.backButton1.addGestureRecognizer(dismissTap)
        
        
        
        //        menuView.tabController = tabBarController as! NavigationMenuBaseController
        //        menuView.userData = userData
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // Alter the cells created by QuickTableViewController
//        print("This is cell \(cell)")
        return cell
    }
    
    
    //    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
    ////        menuView.homeButtonClicked(sender)
    //    dismiss(animated: false, completion: nil)
    //    }
    
    
    
    
    
    private func showAlert(_ sender: Row) {
        // ...
    }
    
    var blurEffectView: UIVisualEffectView?

    
    private func didToggleSelection() -> (Row) -> Void {
        return { [weak self] row in
            print("toggled row: \(row.text)")
            
            if row.text == self!.mitLicenseArray[0] {
                let pdfVC = self?.storyboard?.instantiateViewController(identifier: "pdfViewer") as! PDFViewer
                pdfVC.pdfString = self!.mitLicensePDFTitleArray[0]
            pdfVC.titleString = "MIT License"
            pdfVC.navBarView.titleLabel.text = "MIT License"
                pdfVC.modalPresentationStyle = .fullScreen
                self!.present(pdfVC, animated: false)
            }
            else if row.text == self!.mitLicenseArray[1] {
                let pdfVC = self?.storyboard?.instantiateViewController(identifier: "pdfViewer") as! PDFViewer
                pdfVC.pdfString = self!.mitLicensePDFTitleArray[0]
            pdfVC.titleString = "MIT License"
            pdfVC.navBarView.titleLabel.text = "MIT License"
                pdfVC.modalPresentationStyle = .fullScreen
                self!.present(pdfVC, animated: false)
            }
            else if row.text == self!.mitLicenseArray[2] {
                let pdfVC = self?.storyboard?.instantiateViewController(identifier: "pdfViewer") as! PDFViewer
                pdfVC.pdfString = self!.mitLicensePDFTitleArray[2]
            pdfVC.titleString = "MIT License"
            pdfVC.navBarView.titleLabel.text = "MIT License"
                pdfVC.modalPresentationStyle = .fullScreen
                self!.present(pdfVC, animated: false)
            }
            else if row.text == self!.mitLicenseArray[3] {
                let pdfVC = self?.storyboard?.instantiateViewController(identifier: "pdfViewer") as! PDFViewer
                pdfVC.pdfString = self!.mitLicensePDFTitleArray[3]
            pdfVC.titleString = "MIT License"
            pdfVC.navBarView.titleLabel.text = "MIT License"
                pdfVC.modalPresentationStyle = .fullScreen
                self!.present(pdfVC, animated: false)
            }
            else if row.text == self!.mitLicenseArray[4] {
                let pdfVC = self?.storyboard?.instantiateViewController(identifier: "pdfViewer") as! PDFViewer
                pdfVC.pdfString = self!.mitLicensePDFTitleArray[4]
            pdfVC.titleString = "MIT License"
            pdfVC.navBarView.titleLabel.text = "MIT License"
                pdfVC.modalPresentationStyle = .fullScreen
                self!.present(pdfVC, animated: false)
            }
            else if row.text == self!.mitLicenseArray[5] {
                let pdfVC = self?.storyboard?.instantiateViewController(identifier: "pdfViewer") as! PDFViewer
                pdfVC.pdfString = self!.mitLicensePDFTitleArray[5]
            pdfVC.titleString = "MIT License"
            pdfVC.navBarView.titleLabel.text = "MIT License"
                pdfVC.modalPresentationStyle = .fullScreen
                self!.present(pdfVC, animated: false)
            }
            else if row.text == self!.mitLicenseArray[6] {
                let pdfVC = self?.storyboard?.instantiateViewController(identifier: "pdfViewer") as! PDFViewer
                pdfVC.pdfString = self!.mitLicensePDFTitleArray[6]
            pdfVC.titleString = "MIT License"
            pdfVC.navBarView.titleLabel.text = "MIT License"
                pdfVC.modalPresentationStyle = .fullScreen
                self!.present(pdfVC, animated: false)
            }
     
        }
            
        }
    
    @objc func performSignout() {
        userDataVM?.kill()
        self.performSegue(withIdentifier: "rewindSignOut", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //empty for now.  Used for signout
    }
    
}
