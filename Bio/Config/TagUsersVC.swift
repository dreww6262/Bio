//
//  TagUsersVC.swift
//  Bio
//
//  Created by Ann McDonough on 10/13/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import YPImagePicker

class TagUsersVC: UIViewController {
    
    @IBOutlet weak var tagImage: UIImageView!
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    var doneButton = UIButton()
    var cancelButton = UIButton()
    var userDataVM: UserDataVM?
    var item: YPMediaItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //     view.backgroundColor = .black
        setUpNavBarView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapTagImage))
       // let tapGesture = UITapGestureRecognizer(

        self.tagImage.isUserInteractionEnabled = true
           self.tagImage.addGestureRecognizer(tapGestureRecognizer)
        
        tagImage.frame = CGRect(x: 0, y: navBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.width)
        
        switch item {
        case .photo(let photo):
            tagImage.image = photo.image
        case .video(let video):
            tagImage.image = video.thumbnail
        default:
            print("bade")
        }
       // tagImage.setupHexagonMask(lineWidth: tagImage.frame.width/15, color: myOrange, cornerRadius: tagImage.frame.width/15)
       
    }
    
    @objc func tapTagImage(sender: UITapGestureRecognizer) {

        let touchPoint = sender.location(in: self.tagImage) // Change to whatever view you want the point for
        print("This is touchPoint \(touchPoint)")
        let tagUserTableView = storyboard?.instantiateViewController(identifier: "tagUserTableView") as! TagUserTableView
       // let currentUsernameText : String = userData!.publicID
        tagUserTableView.userDataVM = self.userDataVM
        tagUserTableView.tagCGPoint = touchPoint
        tagUserTableView.scaleCGPoint = CGPoint(x: self.tagImage.frame.width, y: self.tagImage.frame.height)
        let percentWidthX = touchPoint.x/tagUserTableView.scaleCGPoint!.x
        let percentHeightY = touchPoint.y/tagUserTableView.scaleCGPoint!.y
        tagUserTableView.percentWidthX = Double(percentWidthX)
        tagUserTableView.percentHeightY = Double(percentHeightY)
        present(tagUserTableView, animated: false)
        
    }
    
    @objc func donePressed() {
        print("done pressed")
        print("It should tag users here")
        self.dismiss(animated: true, completion: nil)
     }
    
    @objc func cancelPressed() {
        print("canceled pressed")
        print("It should dismiss here")
        self.dismiss(animated: true)
     }
    
    @objc func imageTapped() {
        print("imageTapped pressed")
        print("It should open up search user table view here")
        print("This is coordinate of tap: ")
     }
    
    
    func setUpNavBarView() {
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(titleLabel1)
        self.navBarView.addSubview(doneButton)
        self.navBarView.addSubview(cancelButton)
        self.navBarView.addBehavior()
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        self.navBarView.backgroundColor = UIColor(cgColor: CGColor(gray: 0.05, alpha: 1.0))
        self.navBarView.layer.borderWidth = 0.25
        self.navBarView.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
        self.titleLabel1.text = "Tag People"
    //    self.navBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/15)
       // self.tableiew.frame = CGRect(x: 0, y: self.view.frame.height/12, width: self.view.frame.width, height: self.view.frame.height*(11/12))
        self.titleLabel1.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.navBarView.frame.height-10)
        self.titleLabel1.textAlignment = .center
       
        self.titleLabel1.font = UIFont(name: "DINAlternate-Bold", size: 20)
        self.titleLabel1.textColor = .white
      //  self.navBarView.backgroundColor = .clear
        let buttonWidth = CGFloat(20)
        let buttonHeight = CGFloat(20)
        cancelButton.sizeToFit()
  //      cancelButton.frame = CGRect(x: 5, y: navBarView.frame.height/4 + 10, width: buttonWidth height: buttonHeight)
        cancelButton.frame = CGRect(x: 5, y: (navBarView.frame.height - buttonHeight)/2 + 5, width: buttonWidth, height: buttonHeight)
    //    backButton.setBackgroundImage(UIImage(named: "whiteBack"), for: .normal)
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(self.cancelPressed))
        let doneTap = UITapGestureRecognizer(target: self, action: #selector(self.donePressed))
                                                
        
        view.bringSubviewToFront(cancelButton)
        doneButton.sizeToFit()
        doneButton.addGestureRecognizer(doneTap)
        cancelButton.addGestureRecognizer(cancelTap)
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.textAlignment = .right
        doneButton.titleLabel?.font = UIFont(name: "DINAlternate-Bold", size: 17)
        cancelButton.setBackgroundImage(UIImage(systemName: "chevron.left"), for: .normal)
        doneButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.tintColor = white
        
        doneButton.frame = CGRect(x: self.view.frame.width - 88, y: (navBarView.frame.height/4) + 5, width: 88, height: navBarView.frame.height/2)
        doneButton.titleLabel?.textAlignment = .right
       // doneButton.frame = CGRect(x: view.frame.width - cancelButton.frame.width - 10, y: navBarView.frame.midY - cancelButton.frame.height/2 + 10, width: cancelButton.frame.width, height: cancelButton.frame.height)
        view.bringSubviewToFront(doneButton)
//        doneButton.titleLabel!.font = UIFont(name: "DINAlternate-Bold", size: 20)
    }
    
    


}
