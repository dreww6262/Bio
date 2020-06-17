//
//  SettingsVC.swift
//  Bio
//
//  Created by Ann McDonough on 6/14/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    var window: UIWindow?
    
    var firstWordOfPublicity = "Public"
    @IBOutlet weak var settingsLabel: UILabel!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var publicityLabel: UILabel!
    
    @IBOutlet weak var navigatorSlider: Navigator!
    @IBOutlet weak var closeSliderButton: UIButton!
    @IBOutlet weak var expandSliderButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigatorSlider.isHidden = true
           expandSliderButton.isHidden = false

              let xPosition1 = view.frame.width
           //    let xPosition = navigatorSlider.frame.origin.x
           let yPosition1 = CGFloat(0.0)  // Slide Up - 20px

               let width1 = navigatorSlider.frame.size.width
               let height1 = navigatorSlider.frame.size.height

           UIView.animate(withDuration: 0.0, animations: {
                   self.navigatorSlider.frame = CGRect(x: xPosition1, y: yPosition1, width: width1, height: height1)
               })
        
        
        
        if let idx = selectedPublicity.firstIndex(of: " ") {
             firstWordOfPublicity = selectedPublicity.substring(to: idx)
            print(firstWordOfPublicity)
        }
        
        
        publicityLabel.text = firstWordOfPublicity
        

        // Do any additional setup after loading the view.
    }
    
    
//    @IBAction func slideRight(sender: UIButton) {
//        let xPosition = view.frame.width
//    //    let xPosition = navigatorSlider.frame.origin.x
//        let yPosition = 0.0  // Slide Up - 20px
//
//        let width = navigatorSlider.frame.size.width
//        let height = navigatorSlider.frame.size.height
//
//        UIView.animate(withDuration: 1.0, animations: {
//            self.navigatorSlider.frame = CGRect(x: xPosition, y: CGFloat(yPosition), width: width, height: height)
//        })
//    }
    
    @IBAction func expandButtonPressed(_ sender: UIButton) {
          navigatorSlider.isHidden = false
          expandSliderButton.isHidden = true
        let xPosition = view.frame.width - navigatorSlider.frame.width
         //    let xPosition = navigatorSlider.frame.origin.x
             let yPosition = navigatorSlider.frame.origin.y  // Slide Up - 20px

             let width = navigatorSlider.frame.size.width
             let height = navigatorSlider.frame.size.height

             UIView.animate(withDuration: 1.0, animations: {
                 self.navigatorSlider.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
             })
          
      }
      
      @IBAction func closeSliderButtonPressed(_ sender: UIButton) {
          
          //navigatorSlider.isHidden = true
       
            let xPosition = view.frame.width
        //    let xPosition = navigatorSlider.frame.origin.x
            let yPosition = 0.0  // Slide Up - 20px

            let width = navigatorSlider.frame.size.width
            let height = navigatorSlider.frame.size.height

            UIView.animate(withDuration: 1.0, animations: {
                self.navigatorSlider.frame = CGRect(x: xPosition, y: CGFloat(yPosition), width: width, height: height)
            })
           expandSliderButton.isHidden = false
      
      }
    
//    @IBAction func slideLeft(sender: UIButton) {
//           let xPosition = view.frame.width - navigatorSlider.frame.width
//       //    let xPosition = navigatorSlider.frame.origin.x
//           let yPosition = navigatorSlider.frame.origin.y  // Slide Up - 20px
//
//           let width = navigatorSlider.frame.size.width
//           let height = navigatorSlider.frame.size.height
//
//           UIView.animate(withDuration: 1.0, animations: {
//               self.navigatorSlider.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
//           })
//       }
    
    @IBAction func myStoriesPressed(_ sender: UIButton) {
          print("1")
                     let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                     print("2")
                     let myTabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
                     print("3")
                       myTabBar.selectedIndex = 2   // or whatever you want
                     print("4")
                     window?.rootViewController = myTabBar
                     print("5")
          
      }


}
