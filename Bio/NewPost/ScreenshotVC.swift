//
//  ScreenshotVC.swift
//  Bio
//
//  Created by Ann McDonough on 11/11/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import FMPhotoPicker
import YPImagePicker



class ScreenshotVC: UIViewController { //, FMPhotoPickerViewControllerDelegate {
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    var titleFontSize = CGFloat(20)
   var toSearchButton = UIButton()
    var toSettingsButton = UIButton()
    
    @IBOutlet weak var view1: UIView!
    

    
    @IBOutlet weak var pic1: UIButton!
    

    
    var customTabBar: TabNavigationMenu!
    
    let config = FMPhotoPickerConfig()
    
    var userData: UserData?
    
    let menuView = MenuView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        addMenuButtons()

 formatPicturesAndLabelsFinal()
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
    }
 
    


    
    
  
    
    func addMenuButtons() {
        view.addSubview(menuView)
        menuView.currentTab = 4
        menuView.addBehavior()
    }
    
    
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    
    
    func formatPicturesAndLabelsFinal() {
        var height = self.view.frame.width*(8/12)
        var frame1 = CGRect(x: self.view.frame.width*(2/12), y: (self.view.frame.height - height)/2, width: (self.view.frame.width)*(8/12), height: self.view.frame.width*(8/12))
        view1.frame = frame1
     
     //   pic1.center = view1.center
        var picHeight = CGFloat(120.0)
        var picWidth = CGFloat(120.0)
//        pic1.frame = CGRect(x: (self.view.frame.width - picWidth)/2, y: (self.view.frame.height - picHeight)/2, width: picWidth, height: picHeight)
//
        pic1.frame = CGRect(x: (view1.frame.width - picWidth)/2, y: (view1.frame.height - picWidth)/2, width: picWidth, height: picHeight)
        
    
    

        
    }
    
    

}

   
