//
//  ContentPagesVC.swift
//  Bio
//
//  Created by Andrew Williamson on 9/28/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Foundation

class ContentPagesVC: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    var currentIndexLabel = UILabel()
    let backImage = UIImage(named: "whiteBack")
    let shareImage = UIImage(named: "whiteShare1")
    let commentImage = UIImage(named: "whiteComment")
    let reportImage = UIImage(named: "whiteShield")
    let openAppImage = UIImage(named: "bioBlue")
    
    var showBool = false
    
    var viewControllers = [UIViewController]()
    var pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    var currentIndex: Int = 0 {
        didSet{
            currentIndexLabel.text = "\(currentIndex + 1)/\(viewControllers.count)"
        }
    }
    
    var hexData: [HexagonStructData?]? {
        didSet {
            viewControllers.removeAll()
            if (hexData != nil) {
                for data in hexData! {
                    if (data != nil) {
                        switch data!.type {
                        case "photo":
                            let vc = ContentImageVC()
                            vc.photoHex = data
                            showBool = false
                            vc.showOpenAppButton = false
                            viewControllers.append(vc)
                        case "video":
                            let vc = ContentVideoVC()
                            vc.videoHex = data
                            vc.showOpenAppButton = false
                            showBool = false
                            viewControllers.append(vc)
                        case "link":
                            let vc = ContentLinkVC()
                            vc.webHex = data
                            vc.showOpenAppButton = false
                            showBool = false
                            viewControllers.append(vc)
                        default:
                            let vc = ContentLinkVC()
                            vc.webHex = data
                            vc.showOpenAppButton = true
                            showBool = true
                            viewControllers.append(vc)
                        }
                        //pageView.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
                    }
                    else {
                        print("hexdata list has a nil value")
                    }
                }
            }
        }
    }
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return viewControllers.count
//    }
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return self.currentIndex
//    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllers.firstIndex(of: viewController) else {return nil}
        
        let previousIndex  = vcIndex - 1
        
//        guard previousIndex >= 0 else {
//            print("0 > previndex = \(previousIndex)")
//            currentIndex = viewControllers.count - 1
//            return viewControllers.last
//        }
//        guard viewControllers.count > previousIndex else {
//            print("bad viewcontrollers.count <= previndex = \(previousIndex)")
//            return nil
//        }
        if previousIndex < 0 {
            return nil
        }
        if previousIndex >= viewControllers.count {
            return nil
        }
        
        print("viewcontroller: \(previousIndex)")
        
        return viewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllers.firstIndex(of: viewController) else {return nil}
        
        let nextIndex  = vcIndex + 1
        
//        guard viewControllers.count != nextIndex else {
//            print("viewcontrollers.count = nextindex = \(nextIndex)")
//            currentIndex = 0
//            return viewControllers.first
//        }
//        guard viewControllers.count > nextIndex else {
//            print(" bad viewcontrollers.count <= nextIndex = \(nextIndex)")
//            return nil
//        }
        if nextIndex >= viewControllers.count {
            return nil
        }
        if nextIndex < 0 {
            return nil
        }
        
        print("viewcontroller: \(nextIndex)")
        
      //  viewControllers[nextIndex].
      //  viewControllers[nextIndex].showOpenAppButton = showBool
        
        return viewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if (pendingViewControllers.count > 0) {
            guard let vcIndex = viewControllers.firstIndex(of: pendingViewControllers[0]) else {return}
            currentIndex = vcIndex
        }

    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            guard let vcIndex = viewControllers.firstIndex(of: previousViewControllers[0]) else {return}
            currentIndex = vcIndex
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        let topBar = UIView()
        view.addSubview(topBar)
        topBar.backgroundColor = .clear
        topBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/11)
        
        let bottomBar = UIView()
        view.addSubview(bottomBar)
        bottomBar.backgroundColor = .clear
       // bottomBar.frame = CGRect(x: 0, y: self.view.frame.height*(14/15), width: view.frame.width, height: self.view.frame.height/15)
        // hide Bottom bar by pushing it off screen
        bottomBar.frame = CGRect(x: 0, y: self.view.frame.height*(15/15), width: view.frame.width, height: self.view.frame.height/15)
        
        let backButton = UIButton()
        topBar.addSubview(backButton)
     //  backButton.setTitle("Back", for: .normal)
    //    backButton.setTitleColor(.white, for: .normal)
     //   backButton.backgroundColor = .black
        backButton.imageView?.image?.withTintColor(.white)
        backButton.tintColor = .white
        backButton.imageView?.tintColor = white
      //  backButton.imageView.col
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        backButton.addGestureRecognizer(backTap)
        //backButton.sizeToFit()
        backButton.frame = CGRect(x: 5, y: topBar.frame.maxY - 30, width: 25, height: 25)
        backButton.setBackgroundImage(UIImage(named:"whiteChevron"), for: .normal)
       
        topBar.addSubview(currentIndexLabel)
        currentIndexLabel.frame = CGRect(x: (view.frame.width/2) - 40, y: topBar.frame.maxY - 30, width: 80, height: 25)
        currentIndexLabel.text = "\(currentIndex + 1)/\(viewControllers.count)"
        currentIndexLabel.textColor = white
        currentIndexLabel.font.withSize(25)
        currentIndexLabel.textAlignment = .center

       // backButton.imageView?.frame = backButton.frame
       // backButton.imageView?.image = UIImage(named: "whiteChevron")
        let commentButton = UIButton()
        //bottomBar.addSubview(commentButton)
        commentButton.setTitleColor(.white, for: .normal)
        commentButton.backgroundColor = .clear
        commentButton.imageView?.image?.withTintColor(.white)
    //    commentButton.setTitle("Comment", for: .normal)
       
        commentButton.tintColor = .white
        commentButton.imageView?.tintColor = white
      //  backButton.imageView.col
       // let commentTap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
       // commentButton.addGestureRecognizer(backTap)
        commentButton.sizeToFit()
        //1
        commentButton.frame = CGRect(x:5, y: bottomBar.frame.height/4, width: bottomBar.frame.height/2, height: bottomBar.frame.height/2)
        commentButton.imageView?.frame = commentButton.frame
        commentButton.imageView?.image = commentImage
        var spacingForButton = bottomBar.frame.height/4
        
        let shareButton = UIButton()
        //bottomBar.addSubview(shareButton)
        bottomBar.backgroundColor = .black
        //view.bringSubviewToFront(bottomBar)
        bottomBar.bringSubviewToFront(commentButton)
       // bottomBar.isHidden = true
        
        
        print("This is bottm bar frame \(bottomBar.frame) and view.frame \(view.frame)")
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.backgroundColor = .clear
        shareButton.imageView?.image?.withTintColor(.white)
       // shareButton.setTitle("Share", for: .normal)
       
        shareButton.tintColor = .white
        shareButton.imageView?.tintColor = white
      //  backButton.imageView.col
    //    let shareTap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        //shareButton.addGestureRecognizer(backTap)
        shareButton.sizeToFit()
        //1
        shareButton.frame = CGRect(x: commentButton.frame.maxX + spacingForButton, y: bottomBar.frame.height/4, width: bottomBar.frame.height/2, height: bottomBar.frame.height/2)
        shareButton.imageView?.frame = shareButton.frame
        shareButton.imageView?.image = shareImage
        bottomBar.bringSubviewToFront(shareButton)
        
        let reportButton = UIButton()
        topBar.addSubview(reportButton)
        reportButton.setTitleColor(.white, for: .normal)
        reportButton.backgroundColor = .clear
        reportButton.imageView?.image?.withTintColor(.white)
        
        let reportTapped = UITapGestureRecognizer(target: self, action: #selector(reportButtonPressed))
        reportButton.addGestureRecognizer(reportTapped)
    //    reportButton.setTitle("Report", for: .normal)
        
        
        reportButton.tintColor = .white
        reportButton.imageView?.tintColor = white
      //  backButton.imageView.col
    //    let shareTap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
       // reportButton.addGestureRecognizer(backTap)
        reportButton.sizeToFit()
       // reportButton.frame = CGRect(x: self.view.frame.width-150+commentButton.frame.width + spacingForButton + shareButton.frame.width, y: (topBar.frame.height - reportButton.frame.height) / 2 + 10, width: reportButton.frame.width, height: reportButton.frame.height)
      //  reportButton.imageView?.frame = reportButton.frame
      //  reportButton.imageView?.image = reportImage
        print("This is topBar frame \(topBar.frame)")
        print("This is backButton.image.frame \(backButton.imageView?.frame)")
        print("This is commentButton.image.frame \(commentButton.imageView?.frame)")
        print("This is shareButton.image.frame \(shareButton.imageView?.frame)")
        print("This is reportButton.image.frame \(reportButton.imageView?.frame)")
      //  print("This is backButton.image.frame \(backButton.imageView?.frame)")
        //backButton.setBackgroundImage(UIImage(named: "whiteBack"), for: .normal)
        commentButton.setBackgroundImage(UIImage(named: "whiteComment"), for: .normal)
        shareButton.setBackgroundImage(UIImage(named: "whiteShare1"), for: .normal)
        reportButton.setBackgroundImage(UIImage(named: "whiteShield"), for: .normal)
        reportButton.frame = CGRect(x: self.view.frame.width-30, y: (topBar.frame.maxY) -  30, width: 25, height: 25)
     //   shareButton.frame = CGRect(x: self.view.frame.width-reportButton.frame.width-5-shareButton.frame.width, y: (topBar.frame.height - shareButton.frame.height) / 2, width: shareButton.frame.width, height: shareButton.frame.height)
      //  commentButton.frame = CGRect(x: (self.view.frame.width)-(reportButton.frame.width)-5-(shareButton.frame.width)-(commentButton.frame.width)-5, y: (topBar.frame.height - commentButton.frame.height) / 2, width: commentButton.frame.width, height: commentButton.frame.height)
       // backButton.frame = CGRect(x: 0, y: (topBar.frame.height - backButton.frame.height) / 2, width: backButton.frame.width, height: backButton.frame.height)
        
  
        let goToAppButton = UIButton()
        bottomBar.addSubview(goToAppButton)
        
        if showBool == true {
            goToAppButton.isHidden = false
        }
        else {
            goToAppButton.isHidden = true
        }
        
        
        let openInAppWidth = (7/4)*bottomBar.frame.height
        goToAppButton.setTitle("Open App", for: .normal)
        goToAppButton.sizeToFit()
        goToAppButton.frame = CGRect(x: (bottomBar.frame.width/2)-((openInAppWidth + 8)/2), y: bottomBar.frame.height/2 - (goToAppButton.frame.height + 3) / 2, width: goToAppButton.frame.width + 8, height: goToAppButton.frame.height + 3)
        
      //  goToAppButton.setBackgroundImage(UIImage(named: "bioBlue"), for: .normal)
        goToAppButton.backgroundColor = .clear
        
        goToAppButton.setTitleColor(.white, for: .normal)
        goToAppButton.titleLabel?.textAlignment = .center
        goToAppButton.layer.cornerRadius = goToAppButton.frame.width/20
        goToAppButton.layer.borderWidth = 0.4
        goToAppButton.layer.borderColor = white.cgColor
        
        
        
//        pageView.view.frame = CGRect(x: 0, y: topBar.frame.maxY, width: view.frame.width, height: view.frame.height - topBar.frame.height - bottomBar.frame.height)
        //adjust height for removing bottom bar
        
        pageView.view.frame = CGRect(x: 0, y: topBar.frame.maxY, width: view.frame.width, height: view.frame.height - topBar.frame.height)

        addChild(pageView)
        view.addSubview(pageView.view)
        pageView.didMove(toParent: self)
        
        pageView.dataSource = self
        pageView.delegate = self
        view.backgroundColor = .black
        pageView.view.backgroundColor = .clear
       // pageView.presentationController.
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for v in view.subviews {
            v.isHidden = false
        }
        pageView.dataSource = nil
        pageView.dataSource = self
        
        if (currentIndex < viewControllers.count && currentIndex >= 0) {
            let currentVC = viewControllers[currentIndex]
            pageView.setViewControllers([currentVC], direction: .forward, animated: false, completion: nil)
        }
        else if (viewControllers.first != nil) {
            pageView.setViewControllers([viewControllers.first!], direction: .forward, animated: false, completion: nil)
            currentIndex = 0
        }
    }
    
    @objc func backTapped(_ sender: UITapGestureRecognizer) {
        print("back hit!")
        for v in view.subviews {
            v.isHidden = true
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func reportButtonPressed(_ sender: UITapGestureRecognizer) {
        let reportVC = storyboard?.instantiateViewController(withIdentifier: "reportVC") as! ReportPostTableView
        let currentVC = viewControllers[currentIndex]
        if currentVC is ContentLinkVC {
            let linkVC = currentVC as! ContentLinkVC
            reportVC.hexData = linkVC.webHex
        }
        else if currentVC is ContentImageVC {
            let imageVC = currentVC as! ContentImageVC
            reportVC.hexData = imageVC.photoHex
        }
        else if currentVC is ContentVideoVC {
            let videoVC = currentVC as! ContentVideoVC
            reportVC.hexData = videoVC.videoHex
        }
        present(reportVC, animated: false, completion: nil)
        
    }
    
    
}
