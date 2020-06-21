//
//  DrawingBoardVC2.swift
//  Bio
//
//  Created by Ann McDonough on 6/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import UIKit

class DrawingBoardVC2: UIViewController {

    var panGesture  = UIPanGestureRecognizer()
     var panGestureForNewImage  = UIPanGestureRecognizer()
    var panGestureForTextField = UIPanGestureRecognizer()
    var panGestureForNewTextField = UIPanGestureRecognizer()
    
    @IBOutlet weak var premadeImageView: UIImageView!
    
    @IBOutlet weak var premadeTextField: UITextField!
    
    @IBOutlet weak var creativeToolBar: CreativeToolBar!
    
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var expandSliderButton: UIButton!
    
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var addTextFieldPressed: UIButton!
    
    
    @IBOutlet weak var blackCrayon: UIButton!
      
      @IBOutlet weak var silverCrayon: UIButton!
      
      @IBOutlet weak var redCrayon: UIButton!
      @IBOutlet weak var blueCrayon: UIButton!
      @IBOutlet weak var skyBlueCrayon: UIButton!
      
      @IBOutlet weak var greenCrayon: UIButton!
      
      @IBOutlet weak var limeGreenCrayon: UIButton!
      
      @IBOutlet weak var brownCrayon: UIButton!
      @IBOutlet weak var orangeCrayon: UIButton!
      
      @IBOutlet weak var yellowCrayon: UIButton!

      @IBOutlet weak var eraser: UIButton!
      
    
    
    
    
    
    
    
    
    
     override func viewDidLoad() {
          super.viewDidLoad()
          plusButton.isHidden = true
             expandSliderButton.isHidden = false

                let xPosition1 = view.frame.width
             //    let xPosition = navigatorSlider.frame.origin.x
             let yPosition1 = CGFloat(0.0)  // Slide Up - 20px
//make premade image draggable
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(DrawingBoardVC2.dragImg(_:)))
        premadeImageView.isUserInteractionEnabled = true
        premadeImageView.addGestureRecognizer(panGesture)
//make premade text Field Draggable
        panGestureForTextField = UIPanGestureRecognizer(target: self, action: #selector(DrawingBoardVC2.dragTextField(_:)))
               premadeTextField.isUserInteractionEnabled = true
               premadeTextField.addGestureRecognizer(panGestureForTextField)
        
        panGestureForNewImage = UIPanGestureRecognizer(target: self, action: #selector(DrawingBoardVC2.dragNewImg(_:)))
         panGestureForNewTextField = UIPanGestureRecognizer(target: self, action: #selector(DrawingBoardVC2.dragNewImg(_:)))
        
      }
    
    @IBAction func addTextFieldButtonPressed(_ sender: UIButton) {
        let newTextField = UITextField(frame: CGRect(x: 100, y: 150, width: 50, height: 50))
        newTextField.text = "New Text Field"
                  newTextField.contentMode = .scaleToFill
                  newTextField.isUserInteractionEnabled = true
          //    newImage.addGestureRecognizer(panGesture)
                  self.view.addSubview(newTextField)
        newTextField.isUserInteractionEnabled = true
            newTextField.addGestureRecognizer(panGestureForNewImage)
    }
    
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        let newImage = UIImageView(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
             newImage.image = UIImage(named: "the_starry_night-t2")
             newImage.contentMode = .scaleToFill
             newImage.isUserInteractionEnabled = true
     //    newImage.addGestureRecognizer(panGesture)
             self.view.addSubview(newImage)
        
        newImage.isUserInteractionEnabled = true
            newImage.addGestureRecognizer(panGestureForNewImage)
        
    }
    

    @objc func dragImg(_ sender:UIPanGestureRecognizer){
            let translation = sender.translation(in: self.view)
            premadeImageView.center = CGPoint(x: premadeImageView.center.x + translation.x, y: premadeImageView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
    
    @objc func dragNewImg(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: self.view)
        sender.view?.center = CGPoint(x: (sender.view?.center.x)! + translation.x, y: (sender.view?.center.y)! + translation.y)
             sender.setTranslation(CGPoint.zero, in: self.view)
         }
    

    @objc func dragTextField(_ sender:UIPanGestureRecognizer){
              let translation = sender.translation(in: self.view)
              premadeTextField.center = CGPoint(x: premadeTextField.center.x + translation.x, y: premadeTextField.center.y + translation.y)
              sender.setTranslation(CGPoint.zero, in: self.view)
          }
    
    
    
    
}
