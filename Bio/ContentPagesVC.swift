//
//  ContentPagesVC.swift
//  Bio
//
//  Created by Andrew Williamson on 9/28/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class ContentPagesVC: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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
        topBar.backgroundColor = .darkGray
        topBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
        let backButton = UIButton()
        view.addSubview(backButton)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = .clear
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        backButton.addGestureRecognizer(backTap)
        backButton.sizeToFit()
        backButton.frame = CGRect(x: 5, y: (topBar.frame.height - backButton.frame.height) / 2 + 10, width: backButton.frame.width, height: backButton.frame.height)
        
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
        //print("currentVC \(currentIndex) \(currentVC)")
    }
    
    @objc func backTapped(_ sender: UITapGestureRecognizer) {
        for v in view.subviews {
            v.isHidden = true
        }
        self.dismiss(animated: false, completion: nil)
    }
    
}
