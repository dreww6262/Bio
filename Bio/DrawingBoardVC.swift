//
//  DrawingBoardVC.swift
//  Bio
//
//  Created by Ann McDonough on 6/15/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class DrawingBoardVC: UIViewController {
    
    var window: UIWindow?
    @objc var panGesture       = UIPanGestureRecognizer()
    var drawEnabled = false
    
    var invisibleTextFieldTracer = UITextField()
    
    @IBOutlet weak var creativeToolBar: CreativeToolBar!
    //, SettingsViewControllerDelegate {
//    func settingsViewControllerFinished(_ settingsViewController: SettingsViewController) {
//        var brushWidth = settingsViewController.brush
//         var opacity = settingsViewController.opacity
//         var color = UIColor(red: settingsViewController.red,
//                         green: settingsViewController.green,
//                         blue: settingsViewController.blue,
//                         alpha: opacity)
//         dismiss(animated: true)
//        return
//    }
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minimizeButton: UIButton!
    @IBOutlet weak var textBoxButton: UIButton!
    
    @IBOutlet weak var drawButton: UIButton!
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var lineButton: UIButton!
    
    @IBOutlet weak var shapeButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    
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
    
    @IBOutlet weak var navigatorSlider: Navigator!
      @IBOutlet weak var closeSliderButton: UIButton!
      @IBOutlet weak var expandSliderButton: UIButton!
    
  
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var tempImageView: UIImageView!
  
  var lastPoint = CGPoint.zero
  var color = UIColor.black
  var brushWidth: CGFloat = 10.0
  var opacity: CGFloat = 1.0
  var swiped = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        plusButton.isHidden = true
        navigatorSlider.isHidden = true
           expandSliderButton.isHidden = false

              let xPosition1 = view.frame.width
           //    let xPosition = navigatorSlider.frame.origin.x
           let yPosition1 = CGFloat(0.0)  // Slide Up - 20px

               let width1 = navigatorSlider.frame.size.width
               let height1 = navigatorSlider.frame.size.height

           UIView.animate(withDuration: 0.0, animations: {
                   self.navigatorSlider.frame = CGRect(x: xPosition1, y: yPosition1, width: width1, height: height1)
               })
        
        blackCrayon.isHidden = true
                  silverCrayon.isHidden = true
                  redCrayon.isHidden = true
                  blueCrayon.isHidden = true
                  skyBlueCrayon.isHidden = true
                  greenCrayon.isHidden = true
                  limeGreenCrayon.isHidden = true
                  brownCrayon.isHidden = true
                  orangeCrayon.isHidden = true
                  yellowCrayon.isHidden = true
                  eraser.isHidden = true
                  drawEnabled = false
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(DrawingBoardVC.draggedView(_:)))
           creativeToolBar.isUserInteractionEnabled = true
           creativeToolBar.addGestureRecognizer(panGesture)

        var panGestureForTextField = UIPanGestureRecognizer(target: self, action: #selector(DrawingBoardVC.draggedViewForTextField(_:)))
                 invisibleTextFieldTracer.isUserInteractionEnabled = true
                 invisibleTextFieldTracer.addGestureRecognizer(panGestureForTextField)
        
//
//        let panGestureForTextField = UIPanGestureRecognizer(target: self, action: #selector(DrawingBoardVC.draggedViewForTextField(_:)))
//                  invisibleTextFieldTracer.isUserInteractionEnabled = true
//                  invisibleTextFieldTracer.addGestureRecognizer(panGesture)
        
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.view.bringSubviewToFront(creativeToolBar)
        let translation = sender.translation(in: self.view)
        creativeToolBar.center = CGPoint(x: creativeToolBar.center.x + translation.x, y: creativeToolBar.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func draggedViewForTextField(_ sender:UIPanGestureRecognizer){
          self.view.bringSubviewToFront(invisibleTextFieldTracer)
          let translation = sender.translation(in: self.view)
          invisibleTextFieldTracer.center = CGPoint(x: invisibleTextFieldTracer.center.x + translation.x, y: invisibleTextFieldTracer.center.y + translation.y)
          sender.setTranslation(CGPoint.zero, in: self.view)
      }
    
    
    @IBAction func expandButtonPressed(_ sender: UIButton) {
        navigatorSlider.isHidden = false
        expandSliderButton.isHidden = true
      let xPosition = view.frame.width - navigatorSlider.frame.width
       //    let xPosition = navigatorSlider.frame.origin.x
           let yPosition = navigatorSlider.frame.origin.y  // Slide Up - 20px

           let width = navigatorSlider.frame.size.width
           let height = navigatorSlider.frame.size.height

           UIView.animate(withDuration: 1.0, animations: {
               self.navigatorSlider.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
           })
        
    }
    
    @IBAction func closeSliderButtonPressed(_ sender: UIButton) {
        
        //navigatorSlider.isHidden = true
     
          let xPosition = view.frame.width
      //    let xPosition = navigatorSlider.frame.origin.x
          let yPosition = 0.0  // Slide Up - 20px

          let width = navigatorSlider.frame.size.width
          let height = navigatorSlider.frame.size.height

          UIView.animate(withDuration: 1.0, animations: {
              self.navigatorSlider.frame = CGRect(x: xPosition, y: CGFloat(yPosition), width: width, height: height)
          })
         expandSliderButton.isHidden = false
    
    }
  
    @IBAction func myStoriesPressed(_ sender: UIButton) {
          print("1")
                     let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                     print("2")
                     let myTabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
                     print("3")
                       myTabBar.selectedIndex = 2   // or whatever you want
                     print("4")
                     window?.rootViewController = myTabBar
                     print("5")
          
      }
    
    
    
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    guard let navController = segue.destination as? UINavigationController,
//      let settingsController = navController.topViewController as? SettingsViewController else {
//        return
//    }
//    settingsController.delegate = self
//    settingsController.brush = brushWidth
//    settingsController.opacity = opacity
//    
//    var red: CGFloat = 0
//    var green: CGFloat = 0
//    var blue: CGFloat = 0
//    color.getRed(&red, green: &green, blue: &blue, alpha: nil)
//    settingsController.red = red
//    settingsController.green = green
//    settingsController.blue = blue
//  }
  
  // MARK: - Actions
  
  @IBAction func resetPressed(_ sender: Any) {
    mainImageView.image = nil
  }
  
  @IBAction func sharePressed(_ sender: Any) {
    guard let image = mainImageView.image else {
      return
    }
    let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    present(activity, animated: true)
  }
  
  @IBAction func pencilPressed(_ sender: UIButton) {
    guard let pencil = Pencil(tag: sender.tag) else {
      return
    }
    color = pencil.color
    if pencil == .eraser {
      opacity = 1.0
    }
  }
    
    
    
  
  func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
    UIGraphicsBeginImageContext(view.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    tempImageView.image?.draw(in: view.bounds)
    
    context.move(to: fromPoint)
    context.addLine(to: toPoint)
    
    context.setLineCap(.round)
    context.setBlendMode(.normal)
    context.setLineWidth(brushWidth)
    context.setStrokeColor(color.cgColor)
    
    context.strokePath()
    
    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    tempImageView.alpha = opacity
    
    UIGraphicsEndImageContext()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    swiped = false
    lastPoint = touch.location(in: view)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    swiped = true
    let currentPoint = touch.location(in: view)
    drawLine(from: lastPoint, to: currentPoint)
    
    lastPoint = currentPoint
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !swiped {
      // draw a single point
      drawLine(from: lastPoint, to: lastPoint)
    }
    
    // Merge tempImageView into mainImageView
    UIGraphicsBeginImageContext(mainImageView.frame.size)
    mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
    tempImageView?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
    mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    tempImageView.image = nil
  }
    
    @IBAction func drawButtonPressed(_ sender: UIButton) {
        if drawEnabled == true {
            blackCrayon.isHidden = true
            silverCrayon.isHidden = true
            redCrayon.isHidden = true
            blueCrayon.isHidden = true
            skyBlueCrayon.isHidden = true
            greenCrayon.isHidden = true
            limeGreenCrayon.isHidden = true
            brownCrayon.isHidden = true
            orangeCrayon.isHidden = true
            yellowCrayon.isHidden = true
            eraser.isHidden = true
            drawEnabled = false
        
        } else {
            blackCrayon.isHidden = false
                     silverCrayon.isHidden = false
                     redCrayon.isHidden = false
                     blueCrayon.isHidden = false
                     skyBlueCrayon.isHidden = false
                     greenCrayon.isHidden = false
                     limeGreenCrayon.isHidden = false
                     brownCrayon.isHidden = false
                     orangeCrayon.isHidden = false
                     yellowCrayon.isHidden = false
                     eraser.isHidden = false
            drawEnabled = true
        }
    }
    
    
    @IBAction func addTextBoxPressed(_ sender: UIButton) {
        let newTextField =  UITextField(frame: CGRect(x: 0, y: 100, width: 200, height: 21))
        //var gesture = UIPanGestureRecognizer(target: self, action: Selector("userDragged:"))
       //   newTextField.addGestureRecognizer(gesture)
        newTextField.isUserInteractionEnabled = true
  newTextField.addGestureRecognizer(panGesture)
        newTextField.center = CGPoint(x: 160, y: 285)
        newTextField.textAlignment = .center
        newTextField.text = "Click To Edit"
        self.view.addSubview(newTextField)
       
           invisibleTextFieldTracer =  UITextField(frame: CGRect(x: 0, y: 140, width: 200, height: 21))
              //var gesture = UIPanGestureRecognizer(target: self, action: Selector("userDragged:"))
             //   newTextField.addGestureRecognizer(gesture)
         //     invisibleTextFieldTracer.isUserInteractionEnabled = true
      //  invisibleTextFieldTracer.addGestureRecognizer(panGesture)
              invisibleTextFieldTracer.center = CGPoint(x: 160, y: 285)
              invisibleTextFieldTracer.textAlignment = .center
              invisibleTextFieldTracer.text = "MEMEMEMEMEMEMEM"
              self.view.addSubview(invisibleTextFieldTracer)
        
        
        
       
//        func userDragged(gesture: UIPanGestureRecognizer){
//              var loc = gesture.location(in: self.view)
//              newTextField.center = loc
//          }
        
        
    }
    
    func userDragged(gesture: UIPanGestureRecognizer){
        var loc = gesture.location(in: self.view)
       invisibleTextFieldTracer.center = loc
    }
    
  
    
    @IBAction func addPhotoPressed(_ sender: UIButton) {
        let newImage = UIImageView(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        newImage.image = UIImage(named: "the_starry_night-t2")
        newImage.contentMode = .scaleToFill
        newImage.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector( getter: self.panGesture))
        newImage.addGestureRecognizer(panGesture)

      //  newImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: Selector("handlePan:")))

        self.view.addSubview(newImage)
    }
    
    @objc func panGesture(sender: UIPanGestureRecognizer) {
    var relativePosition: CGPoint?
    if sender.state == UIGestureRecognizer.State.began {
        let locationInView = sender.location(in: super.view)
        relativePosition = CGPoint(x: locationInView.x - (sender.view?.center.x ?? 0.0), y: locationInView.y - (sender.view?.center.y ?? 0.0))
        return
    }
    if sender.state == UIGestureRecognizer.State.ended {
        relativePosition = nil
        return
    }
    let locationInView = sender.location(in: super.view)
    guard let pos = relativePosition else {
        return
    }
    sender.view?.center = CGPoint(x: locationInView.x - pos.x,
                                  y: locationInView.y - pos.y)

    }
    
    
    @IBAction func minimizeButtonPressed(_ sender: UIButton) {
        creativeToolBar.isHidden = true
        plusButton.isHidden = false
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        creativeToolBar.isHidden = false
        plusButton.isHidden = true
    }
    
    
    
}

// MARK: - SettingsViewControllerDelegate

//extension ViewController: SettingsViewControllerDelegate {
//  func settingsViewControllerFinished(_ settingsViewController: SettingsViewController) {
//    var brushWidth = settingsViewController.brush
//    var opacity = settingsViewController.opacity
//    var color = UIColor(red: settingsViewController.red,
//                    green: settingsViewController.green,
//                    blue: settingsViewController.blue,
//                    alpha: opacity)
//    dismiss(animated: true)
//  }
//}

