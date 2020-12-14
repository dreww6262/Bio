//
//  CustomPageView.swift
//  Bio
//
//  Created by Andrew Williamson on 12/10/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class CustomPageView: UIViewController {
    var viewControllers: [UIViewController]?
    var currentIndex: Int?
    var frontViewQueue: [UIView]?
    var backViewQueue: [UIView]?
    
    var presentedViewControllers: [UIViewController?]?
    
    override func viewDidLoad() {
        // header
        // content spread
        // caption
    }
    
    func presentNextVC() {
        if (currentIndex != nil && currentIndex! < viewControllers?.count ?? 0) {
            viewControllers?[currentIndex!].view.removeFromSuperview()
            viewControllers?[currentIndex!].removeFromParent()
        }
    }
    
    func presentPreviousVC() {
        if (currentIndex != nil && currentIndex! < viewControllers?.count ?? 0) {
            viewControllers?[currentIndex!].view.removeFromSuperview()
            viewControllers?[currentIndex!].removeFromParent()
        }
        
    }
    
    func expandCurrentVC() {
        
    }
    
    func setPresentedViewControllers(vcIndex: Int) -> Bool {
        if viewControllers == nil {
            return false
        }
        else if vcIndex < 0 {
            return false
        }
        else if vcIndex > viewControllers!.count {
            return false
        }
        
        if presentedViewControllers != nil {
            for vc in presentedViewControllers! {
                vc?.view.removeFromSuperview()
                vc?.removeFromParent()
            }
            presentedViewControllers = nil
        }
        if vcIndex != 0 && vcIndex + 1 < viewControllers!.count {
            presentedViewControllers = [viewControllers![vcIndex], viewControllers![vcIndex - 1], viewControllers![vcIndex + 1]]
        }
        else if vcIndex != 0 {
            presentedViewControllers = [viewControllers![vcIndex], viewControllers![vcIndex - 1], nil]
        }
        else if vcIndex + 1 < viewControllers!.count {
            presentedViewControllers = [viewControllers![vcIndex], nil, viewControllers![vcIndex + 1]]
        }
        else {
            presentedViewControllers = [viewControllers![vcIndex], nil, nil]
        }
        
        
        return true
    }
}
