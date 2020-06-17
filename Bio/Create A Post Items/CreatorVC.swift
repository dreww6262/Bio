//
//  CreatorVC.swift
//  Dart1
//
//  Created by Ann McDonough on 6/11/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//
import UIKit
import CoreGraphics

class CreatorVC: UIViewController {

@IBOutlet weak var drawingPlace: UIImageView!

var startTouch : CGPoint?
var secondTouch : CGPoint?
var currentContext : CGContext?
var prevImage : UIImage?
  @IBOutlet weak var bottomTextView: UITextField!


override func viewDidLoad() {
    super.viewDidLoad()
    //Draggable textfields
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(userDragged(gesture:)))

    bottomTextView.addGestureRecognizer(gesture)
            bottomTextView.isUserInteractionEnabled = true
}


override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
    startTouch = touch?.location(in: drawingPlace)
}

override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    for touch in touches{
        secondTouch = touch.location(in: drawingPlace)

        if(self.currentContext == nil){
            UIGraphicsBeginImageContext(drawingPlace.frame.size)
            self.currentContext = UIGraphicsGetCurrentContext()
        }else{
            self.currentContext?.clear(CGRect(x: 0, y: 0, width: drawingPlace.frame.width, height: drawingPlace.frame.height))
        }

        self.prevImage?.draw(in: self.drawingPlace.bounds)

        let bezier = UIBezierPath()

        bezier.move(to: startTouch!)
        bezier.addLine(to: secondTouch!)
        bezier.close()

        UIColor.blue.set()

        self.currentContext?.setLineWidth(4)
        self.currentContext?.addPath(bezier.cgPath)
        self.currentContext?.strokePath()
        let img2 = self.currentContext?.makeImage()
        drawingPlace.image = UIImage.init(cgImage: img2!)

    }
}


override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    self.currentContext = nil
    self.prevImage = self.drawingPlace.image
}

    @objc func userDragged(gesture: UIPanGestureRecognizer){
         let loc = gesture.location(in: self.view)
         self.bottomTextView.center = loc

     }
    
    
    
    
}
