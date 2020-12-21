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
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeHorizontally))
        swipeLeftGesture.direction = .left
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeHorizontally))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeLeftGesture)
        view.addGestureRecognizer(swipeRightGesture)
        
        
        let returnButton = UIButton(frame: CGRect(x: view.frame.width/2-40, y: view.frame.height-112, width: 80, height: 80))
        view.addSubview(returnButton)
        returnButton.setImage(UIImage(named: "cancel2"), for: .normal)
        returnButton.layer.cornerRadius = returnButton.frame.size.width / 2
        //returnButton.setBackgroundImage(UIImage(named: "cancel11"), for: .normal)
        returnButton.clipsToBounds = true
        returnButton.tintColor = .white
        returnButton.backgroundColor = .clear
        
        let returnTap = UITapGestureRecognizer(target: self, action: #selector(returnTapped))
        returnButton.addGestureRecognizer(returnTap)
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
        
        visibleVCs[0]?.view.clipsToBounds = true
        visibleVCs[1]?.view.clipsToBounds = true
        visibleVCs[2]?.view.clipsToBounds = true
        
        visibleVCs[0]?.view.isUserInteractionEnabled = true
        visibleVCs[1]?.view.isUserInteractionEnabled = false
        visibleVCs[2]?.view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.25, animations:  {
            self.visibleVCs[0]?.view.frame = CGRect(x: self.centerBox.minX, y: self.centerBox.minY, width: self.centerBox.width, height: self.centerBox.height)
            self.visibleVCs[1]?.view.frame = CGRect(x: self.leftBox.minX, y: self.leftBox.minY, width: self.leftBox.width, height: self.leftBox.height)
            self.visibleVCs[2]?.view.frame = CGRect(x: self.rightBox.minX, y: self.rightBox.minY, width: self.rightBox.width, height: self.rightBox.height)
        })
        
        print("cpv: visible vcs \(visibleVCs)")
    }
    
    
    func moveLeft() {
        print("cpv move left")
        if currentIndex! <= 0 {
            return
        }
        currentIndex! -= 1
        popRight(vc: visibleVCs[2])
        let vc = fetchLeft()
        visibleVCs[2] = visibleVCs[0]
        visibleVCs[0] = visibleVCs[1]
        visibleVCs[1] = vc
        setPositions()
        
    }
    
    
    func moveRight() {
        print("cpv move right")
        if currentIndex! >= viewControllers.count - 1 {
            return
        }
        currentIndex! += 1
        popLeft(vc: visibleVCs[1])
        let vc = fetchRight()
        visibleVCs[1] = visibleVCs[0]
        visibleVCs[0] = visibleVCs[2]
        visibleVCs[2] = vc
        setPositions()
        
    }
    
    func popLeft(vc: UIViewController?) {
        print("cpv pop left")
        
        UIView.animate(withDuration: 0.25, animations: {
            vc?.view.frame = CGRect(x: self.leftBox.minX - self.leftBox.width, y: self.leftBox.minY, width: self.leftBox.width, height: self.leftBox.height)
        }, completion: { _ in
            vc?.view.removeFromSuperview()
            vc?.removeFromParent()
        })
        
    }
    
    func popRight(vc: UIViewController?) {
        print("cpv pop right")
        
        UIView.animate(withDuration: 0.25, animations: {
            vc?.view.frame = CGRect(x: self.rightBox.maxX, y: self.rightBox.minY, width: self.rightBox.width, height: self.rightBox.height)
        }, completion: { _ in
            vc?.view.removeFromSuperview()
            vc?.removeFromParent()
        })
        
    }
    
    func fetchLeft() -> UIViewController? {
        print("cpv fetch left")
        if currentIndex == nil || currentIndex! <= 0 || currentIndex! - 1 >= viewControllers.count {
            return nil
        }
        
        let vc = viewControllers[currentIndex! - 1]
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.frame = CGRect(x: leftBox.minX - leftBox.width, y: leftBox.minY, width: leftBox.width, height: leftBox.height)
        
        return vc
    }
    
    func fetchRight() -> UIViewController? {
        print("cpv fetch right")
        if currentIndex == nil || currentIndex! + 1 < 0 || currentIndex! + 1 >= viewControllers.count {
            return nil
        }
        let vc = viewControllers[currentIndex! + 1]
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.frame = CGRect(x: rightBox.maxX, y: rightBox.minY, width: rightBox.width, height: rightBox.height)
        
        return vc
    }
    
    @objc func swipeHorizontally(_ sender: UISwipeGestureRecognizer) {
        
        print("cpv swipe \(sender.direction)")
        
        if sender.direction == .left {
            moveRight()
        }
        
        else if sender.direction == .right {
            moveLeft()
        }
    }
    
    @objc func returnTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
