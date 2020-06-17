//
//  Navigator.swift
//  Bio
//
//  Created by Ann McDonough on 6/14/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class Navigator: UIView {

    
   func rightSlide(gestureRecognizer: UISwipeGestureRecognizer) {
       let xPosition = self.frame.width
   //    let xPosition = navigatorSlider.frame.origin.x
       let yPosition = 0.0  // Slide Up - 20px

       let width = self.frame.size.width
       let height = self.frame.size.height

       UIView.animate(withDuration: 1.0, animations: {
           self.frame = CGRect(x: xPosition, y: CGFloat(yPosition), width: width, height: height)
       })
   }

}
