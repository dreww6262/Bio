//
//  ReportPostTableView.swift
//  Bio
//
//  Created by Ann McDonough on 10/5/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//
import UIKit
import FirebaseAuth
import QuickTableViewController

class ReportPostTableView: QuickTableViewController {
    
    var navBarView = NavBarView()
    
    
    //var tabController = NavigationMenuBaseController()
    var userData: UserData? = nil
    //var menuView = MenuView()
    var reportOptions = ["Nudity or sexual activity", "Hate speech or symbols", "Violence or dangerous organizations", "Sale of illegal or regulated goods", "Bullying or harassment", "Intellectual property violation", "Suicide, self-injury or eating disorders", "Scam or fraud", "false information", "Other"]
    var titleLabel1 = UILabel()
    var backButton1 = UIButton()
    
    override func viewDidLoad() {
//        view.addSubview(navBarView)
//
        setUpNavBarView()
        
        // Do any additional setup after loading the view.
       
        //menuView.isHidden = true
        tableContents = [
            Section(title: "Report Post", rows: [
                        NavigationRow(text: "Nudity or sexual activity", detailText: .none, icon: .none), NavigationRow(text: "Hate speech of symbols", detailText: .none, icon: .none), NavigationRow(text: "Violence or dangerous organizations", detailText: .none, icon: .none), NavigationRow(text: "Sale of illegal or regulated goods", detailText: .none, icon: .none),NavigationRow(text: "Bullying or harassment", detailText: .none, icon: .none), NavigationRow(text: "Intellectual property violation", detailText: .none, icon: .none), NavigationRow(text: "Suicide, self-injury or eating disorders", detailText: .none, icon: .none), NavigationRow(text: "Scam or fraud", detailText: .none, icon: .none), NavigationRow(text: "False information", detailText: .none, icon: .none), NavigationRow(text: "Other", detailText: .none, icon: .none)])]
      
        
        }
    
    func setUpNavBarView() {
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(titleLabel1)
        self.navBarView.addSubview(backButton1)
        self.navBarView.addBehavior()
        
        // tap to dismissSettings
let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        dismissTap.numberOfTapsRequired = 1
        self.backButton1.isUserInteractionEnabled = true
        self.backButton1.addGestureRecognizer(dismissTap)

        
        self.backButton1.setTitle("Back", for: .normal)
        self.backButton1.setTitleColor(.systemBlue, for: .normal)
        self.titleLabel1.text = "Report Post"
        self.navBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12)
        self.tableView.frame = CGRect(x: 0, y: self.view.frame.height/20, width: self.view.frame.width, height: self.view.frame.height)
        self.titleLabel1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/12)
        self.backButton1.frame = CGRect(x: 0, y: 0, width: navBarView.frame.width/8, height: titleLabel1.frame.height)
        self.titleLabel1.textAlignment = .center
        self.backButton1.titleLabel?.textAlignment = .left
        self.titleLabel1.font = UIFont(name: "DINAlternate-Bold", size: 20)
        self.navBarView.backgroundColor = .systemGray6
    }
    
    @objc func backButtonpressed() {
        print("It should dismiss here")
        self.dismiss(animated: true)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        

    }

    
   // override fun
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = super.tableView(tableView, cellForRowAt: indexPath)
          // Alter the cells created by QuickTableViewController
            print("This is cell \(cell)")
          return cell
        }

        
//    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
////        menuView.homeButtonClicked(sender)
//    dismiss(animated: false, completion: nil)
//    }
    
        
        
    

     private func showAlert(_ sender: Row) {
       // ...
     }

     private func didToggleSelection() -> (Row) -> Void {
       return { [weak self] row in
        if row.text == "Log Out" {
            let alert = UIAlertController(title: "Are You Sure?", message: "We will miss you <3", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "Yeah :/", style: UIAlertAction.Style.cancel, handler: {_ in
                self?.performSignout()
            })
            let nah = UIAlertAction(title: "I'll Stay", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(ok)
            alert.addAction(nah)
            self!.present(alert, animated: true, completion: nil)
        }
         // ...
       }
     }
    
    @objc func performSignout() {
        self.performSegue(withIdentifier: "rewindSignOut", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //empty for now.  Used for signout
    }
   
}

