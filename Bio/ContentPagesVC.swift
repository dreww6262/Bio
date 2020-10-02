//
//  ContentPagesVC.swift
//  Bio
//
//  Created by Andrew Williamson on 9/28/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class ContentPagesVC: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    let backImage = UIImage(named: "whiteBack")
    let shareImage = UIImage(named: "whiteShare")
    let commentImage = UIImage(named: "whiteComment")
    let reportImage = UIImage(named: "whiteShield")
    
    
    var viewControllers = [UIViewController]()
    var pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    var currentIndex: Int = 0
    
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
                            viewControllers.append(vc)
                        case "video":
                            let vc = ContentVideoVC()
                            vc.videoHex = data
                            viewControllers.append(vc)
                        case "link":
                            let vc = ContentLinkVC()
                            vc.webHex = data
                            viewControllers.append(vc)
                        default:
                            let vc = ContentLinkVC()
                            vc.webHex = data
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
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
    
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
        currentIndex = previousIndex
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
        currentIndex = nextIndex
        return viewControllers[nextIndex]
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let topBar = UIView()
        view.addSubview(topBar)
        topBar.backgroundColor = .clear
        topBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
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
        backButton.sizeToFit()
        backButton.frame = CGRect(x: 5, y: (topBar.frame.height - backButton.frame.height) / 2 + 10, width: backButton.frame.width, height: backButton.frame.height)
        backButton.imageView?.frame = backButton.frame
        backButton.imageView?.image = UIImage(named: "whiteBack")
        let commentButton = UIButton()
        topBar.addSubview(commentButton)
        commentButton.setTitleColor(.white, for: .normal)
        commentButton.backgroundColor = .black
        commentButton.imageView?.image?.withTintColor(.white)
    //    commentButton.setTitle("Comment", for: .normal)
       
        commentButton.tintColor = .white
        commentButton.imageView?.tintColor = white
      //  backButton.imageView.col
       // let commentTap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        commentButton.addGestureRecognizer(backTap)
        commentButton.sizeToFit()
        commentButton.frame = CGRect(x: self.view.frame.width-150, y: (topBar.frame.height - commentButton.frame.height) / 2 + 10, width: commentButton.frame.width, height: commentButton.frame.height)
        commentButton.imageView?.frame = commentButton.frame
        commentButton.imageView?.image = commentImage
        
        let shareButton = UIButton()
        topBar.addSubview(shareButton)
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.backgroundColor = .black
        shareButton.imageView?.image?.withTintColor(.white)
       // shareButton.setTitle("Share", for: .normal)
       
        shareButton.tintColor = .white
        shareButton.imageView?.tintColor = white
      //  backButton.imageView.col
    //    let shareTap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        shareButton.addGestureRecognizer(backTap)
        shareButton.sizeToFit()
        shareButton.frame = CGRect(x: self.view.frame.width-150+commentButton.frame.width, y: (topBar.frame.height - shareButton.frame.height) / 2 + 10, width: shareButton.frame.width, height: shareButton.frame.height)
        shareButton.imageView?.frame = shareButton.frame
        shareButton.imageView?.image = shareImage
        
        let reportButton = UIButton()
        topBar.addSubview(reportButton)
        reportButton.setTitleColor(.white, for: .normal)
        reportButton.backgroundColor = .black
        reportButton.imageView?.image?.withTintColor(.white)
    //    reportButton.setTitle("Report", for: .normal)
        
        
        reportButton.tintColor = .white
        reportButton.imageView?.tintColor = white
      //  backButton.imageView.col
    //    let shareTap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
       // reportButton.addGestureRecognizer(backTap)
        reportButton.sizeToFit()
        reportButton.frame = CGRect(x: self.view.frame.width-150+commentButton.frame.width + 5+shareButton.frame.width, y: (topBar.frame.height - reportButton.frame.height) / 2 + 10, width: reportButton.frame.width, height: reportButton.frame.height)
        reportButton.imageView?.frame = reportButton.frame
        reportButton.imageView?.image = reportImage
        print("This is topBar frame \(topBar.frame)")
        print("This is backButton.image.frame \(backButton.imageView?.frame)")
        print("This is commentButton.image.frame \(commentButton.imageView?.frame)")
        print("This is shareButton.image.frame \(shareButton.imageView?.frame)")
        print("This is reportButton.image.frame \(reportButton.imageView?.frame)")
      //  print("This is backButton.image.frame \(backButton.imageView?.frame)")
        backButton.setBackgroundImage(UIImage(named: "whiteBack"), for: .normal)
        commentButton.setBackgroundImage(UIImage(named: "whiteComment"), for: .normal)
        shareButton.setBackgroundImage(UIImage(named: "whiteShare"), for: .normal)
        reportButton.setBackgroundImage(UIImage(named: "whiteShield"), for: .normal)
        reportButton.frame = CGRect(x: self.view.frame.width-reportButton.frame.width, y: (topBar.frame.height - reportButton.frame.height) / 2, width: reportButton.frame.width, height: reportButton.frame.height)
        shareButton.frame = CGRect(x: self.view.frame.width-reportButton.frame.width-5-shareButton.frame.width, y: (topBar.frame.height - shareButton.frame.height) / 2, width: shareButton.frame.width, height: shareButton.frame.height)
        commentButton.frame = CGRect(x: (self.view.frame.width)-(reportButton.frame.width)-5-(shareButton.frame.width)-(commentButton.frame.width)-5, y: (topBar.frame.height - commentButton.frame.height) / 2, width: commentButton.frame.width, height: commentButton.frame.height)
        backButton.frame = CGRect(x: 0, y: (topBar.frame.height - backButton.frame.height) / 2, width: backButton.frame.width, height: backButton.frame.height)
        
        
        
        pageView.view.frame = CGRect(x: 0, y: topBar.frame.maxY, width: view.frame.width, height: view.frame.height - topBar.frame.height)

        addChild(pageView)
        view.addSubview(pageView.view)
        pageView.didMove(toParent: self)
        
        pageView.dataSource = self
        pageView.delegate = self
        view.backgroundColor = .black
        
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
    
}
