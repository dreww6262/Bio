//
//  CustomPageView.swift
//  Bio
//
//  Created by Andrew Williamson on 12/10/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class CustomPageView: UIViewController {
    var userDataVM: UserDataVM?
    var viewControllers = [UIViewController]()
    var currentIndex: Int?
    
    var visibleVCs: [UIViewController?] = [nil, nil, nil]
    
    var showBool = false
    
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
                            vc.userDataVM = userDataVM
                            showBool = false
                            vc.showOpenAppButton = false
                            viewControllers.append(vc)
                        case "video":
                            let vc = ContentVideoVC()
                            vc.videoHex = data
                            vc.userDataVM = userDataVM
                            vc.showOpenAppButton = false
                            showBool = false
                            viewControllers.append(vc)
                        case "link":
                            let vc = ContentLinkVC()
                            vc.userDataVM = userDataVM
                            vc.webHex = data
                            vc.showOpenAppButton = false
                            showBool = false
                            vc.viewDidLoad()
                            viewControllers.append(vc)
                        default:
                            let vc = ContentLinkVC()
                            vc.webHex = data
                            vc.userDataVM = userDataVM
                            vc.showOpenAppButton = true
                            showBool = true
                            vc.viewDidLoad()
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
    
    private var leftBox = CGRect()
    private var rightBox = CGRect()
    private var centerBox = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBoxes()
        
        view.backgroundColor = .gray
        
        if currentIndex == nil {
            if (!setPresentedViewControllers(vcIndex: 0)) {
                return
            }
        }
        
        setPositions()
        
//        let leftView = UIView(frame: leftBox)
//        let rightView = UIView(frame: rightBox)
//        let centerView = UIView(frame: centerBox)
//
//        view.addSubview(leftView)
//        view.addSubview(rightView)
//        view.addSubview(centerView)
//
//        leftView.backgroundColor = .black
//        rightView.backgroundColor = .black
//        centerView.backgroundColor = .black
    }
    
    
    private func setBoxes() {
        let smallWidth = 7/12 * self.view.frame.width
        let smallHeight = 7/12 * self.view.frame.height
        leftBox = CGRect(x: -1/2 * self.view.frame.width, y: self.view.frame.midY - smallHeight / 2, width: smallWidth, height: smallHeight)
        rightBox = CGRect(x: 11/12 * self.view.frame.width, y: leftBox.minY, width: smallWidth, height: smallHeight)
        
        let largeWidth = view.frame.width * 3/4
        let largeHeight = view.frame.height * 3/4
        
        centerBox = CGRect(x: view.frame.midX - largeWidth / 2, y: view.frame.midY - largeHeight / 2, width: largeWidth, height: largeHeight)
    }
    
    
    func expandCurrentVC() {
        
    }
    
    func setPresentedViewControllers(vcIndex: Int) -> Bool {
        if viewControllers.isEmpty {
            return false
        }
        else if vcIndex < 0 {
            return false
        }
        else if vcIndex > viewControllers.count {
            return false
        }
        
        currentIndex = vcIndex
        
        for vc in visibleVCs {
            vc?.view.removeFromSuperview()
            vc?.removeFromParent()
        }
        visibleVCs = [nil, nil, nil]
        
        
        if vcIndex != 0 && vcIndex + 1 < viewControllers.count {
            visibleVCs = [viewControllers[vcIndex], viewControllers[vcIndex - 1], viewControllers[vcIndex + 1]]
        }
        else if vcIndex != 0 {
            visibleVCs = [viewControllers[vcIndex], viewControllers[vcIndex - 1], nil]
        }
        else if vcIndex + 1 < viewControllers.count {
            visibleVCs = [viewControllers[vcIndex], nil, viewControllers[vcIndex + 1]]
        }
        else {
            visibleVCs = [viewControllers[vcIndex], nil, nil]
        }
        
        for vc in visibleVCs {
            if vc == nil {
                continue
            }
            addChild(vc!)
            view.addSubview(vc!.view)
        }
        
        setPositions()
        
        return true
    }
    
    func setPositions() {
        visibleVCs[0]?.view.frame = centerBox
        visibleVCs[1]?.view.frame = leftBox
        visibleVCs[2]?.view.frame = rightBox
        
        visibleVCs[0]?.view.clipsToBounds = true
        visibleVCs[1]?.view.clipsToBounds = true
        visibleVCs[2]?.view.clipsToBounds = true
    }
    
    
    func moveLeft() {
        popLeft()
        let vc = fetchRight()
        visibleVCs[1] = visibleVCs[0]
        visibleVCs[0] = visibleVCs[2]
        visibleVCs[2] = vc
        setPositions()
    }
    
    
    func moveRight() {
        popRight()
        let vc = fetchLeft()
        visibleVCs[2] = visibleVCs[0]
        visibleVCs[0] = visibleVCs[1]
        visibleVCs[1] = vc
        setPositions()
    }
    
    func popLeft() {
        visibleVCs[1]?.view.removeFromSuperview()
        visibleVCs[1]?.removeFromParent()
    }
    
    func popRight() {
        visibleVCs[2]?.view.removeFromSuperview()
        visibleVCs[2]?.removeFromParent()
    }
    
    func fetchLeft() -> UIViewController? {
        
        if currentIndex == nil || currentIndex! <= 0 || currentIndex! - 1 >= viewControllers.count {
            return nil
        }
        
        let vc = viewControllers[currentIndex! - 1]
        addChild(vc)
        view.addSubview(vc.view)
        
        return vc
    }
    
    func fetchRight() -> UIViewController? {
        if currentIndex == nil || currentIndex! + 1 < 0 || currentIndex! + 1 >= viewControllers.count {
            return nil
        }
        let vc = viewControllers[currentIndex! + 1]
        addChild(vc)
        view.addSubview(vc.view)
        
        return vc
    }
    
    
}
