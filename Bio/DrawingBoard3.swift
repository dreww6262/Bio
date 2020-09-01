//
//  DrawingBoard3.swift
//  Bio
//
//  Created by Ann McDonough on 6/21/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class DrawingBoard3: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var videoLink = ""
    var videoCode = ""
    
  //  @IBOutlet weak var videoWebView: UIWebView!
    
    @IBOutlet weak var shapeView: UIView!
    @IBOutlet weak var circleButton: UIButton!
    @IBOutlet weak var triangleButton: UIButton!
    @IBOutlet weak var squareButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var hexagonButton: UIButton!
    
    @IBOutlet weak var youtubeLinkField: UITextField!
    
    @IBOutlet weak var youtubeSearchButton: UIButton!
    
    @IBOutlet weak var textBoxButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
       var panGesture  = UIPanGestureRecognizer()
    @IBOutlet weak var premadeImageView: UIImageView!
    var pinchGesture = UIPinchGestureRecognizer()
    var selected: UIView? = nil
    var scrollViewPinchGesture = UIPinchGestureRecognizer()
     var imagePicker = UIImagePickerController()
    var chosenImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        youtubeSearchButton.isHidden = true
        youtubeLinkField.isHidden = true
   //     videoWebView.isHidden = true
        
        shapeView.isHidden = true
        //create a panGesture for dragging Items
//         panGesture = UIPanGestureRecognizer(target: self, action: #selector(DrawingBoard3.dragItem(_:)))
//        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(DrawingBoard3.pinchText(sender:)))
        print("im in view did load")
         scrollViewPinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(DrawingBoard3.scrollViewPinched(sender:)))
       // scrollView.addGestureRecognizer(scrollViewPinchGesture)
        
    
    }
    
    @IBAction func createTextBoxButtonPressed(_ sender: UIButton) {
      panGesture = UIPanGestureRecognizer(target: self, action: #selector(DrawingBoard3.dragItem(_:)))
         pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(DrawingBoard3.pinchText(sender:)))
        var blankView = UIView(frame: CGRect(x: 0, y: 150, width: self.view.frame.width*0.6, height: 100))
        blankView.backgroundColor = .red
        self.view.addSubview(blankView)
        var newTextView = UITextView(frame: CGRect(x: blankView.frame.width/8, y: blankView.frame.height/8 + 10, width: blankView.frame.width*0.75, height: 60))
        newTextView.backgroundColor = .blue
        newTextView.isScrollEnabled = false
        
    newTextView.text = "New Text Field"
        newTextView.textAlignment = .center
//        newTextView.centerVertically()
        newTextView.contentMode = .scaleToFill
              newTextView.isUserInteractionEnabled = true

        blankView.addSubview(newTextView)
    newTextView.isUserInteractionEnabled = true
    //these are my old gestures
    //newTextView.addGestureRecognizer(panGesture)
    // newTextView.addGestureRecognizer(pinchGesture)
    selected = newTextView
        
        // copied from online
    //add pan gesture
           let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
           gestureRecognizer.delegate = self
         //  newTextView.addGestureRecognizer(gestureRecognizer)
         blankView.addGestureRecognizer(gestureRecognizer)

           //Enable multiple touch and user interaction for textfield
           newTextView.isUserInteractionEnabled = true
           newTextView.isMultipleTouchEnabled = true

           //add pinch gesture
           let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinchRecognized(pinch:)))
           pinchGesture.delegate = self
//           newTextView.addGestureRecognizer(pinchGesture)
         blankView.addGestureRecognizer(pinchGesture)

           //add rotate gesture.
           let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotate(recognizer:)))
           rotate.delegate = self
          // newTextView.addGestureRecognizer(rotate)
        blankView.addGestureRecognizer(rotate)
    }
    
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//          self.dismiss(animated: true, completion: { () -> Void in
//
//          })
//
//     //    newImage.image = image
//      }
//
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
          chosenImage = image
               self.dismiss(animated: true, completion: { () -> Void in

               })

//          chosenImage = image
     
         }
    @IBAction func minimizeShapesPressed(_ sender: Any) {
        shapeView.isHidden = true
        print("minimize shape view")
    }
    
    @IBAction func createShapeButtonPressed(_ sender: UIButton) {
        shapeView.isHidden = false
        shapeView.layer.borderColor = UIColor.blue.cgColor
        shapeView.layer.borderWidth = 1
        print("Shape view should be showing")
        
    }
    
    @IBAction func addYoutubeVideoPressed(_ sender: UIButton) {
        if youtubeLinkField.isHidden == true {
            youtubeLinkField.isHidden = false
            youtubeSearchButton.isHidden = false
            print("it should be showing")
        }
      else {
            youtubeLinkField.isHidden = true
            youtubeSearchButton.isHidden = true
            print("time to hide youtube stuff")
                }
    
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(DrawingBoard3.dragItem(_:)))
//                pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(DrawingBoard3.pinchText(sender:)))
//        let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotate(recognizer:)))
//        rotate.delegate = self
//
//        let newWebView = UIWebView(frame: CGRect(x: 15, y: 550, width: self.view.frame.width*0.8, height: 200))
//         self.view.addSubview(newWebView)
//        newWebView.addGestureRecognizer(pinchGesture)
//        newWebView.addGestureRecognizer(panGesture)
//        newWebView.addGestureRecognizer(rotate)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        videoLink = youtubeLinkField.text!
      //   let url = URL(string: "https://www.youtube.com/embed/\(videoKey)")
        videoCode = String(videoLink.suffix(11))
        print("\(videoLink) is videoLink")
         print("\(videoCode) is the video code")
        var url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        print("\(url) is url")
      ///\  videoWebView.isHidden = false
      //   getVideo(videoKey: videoCode)

    panGesture = UIPanGestureRecognizer(target: self, action: #selector(DrawingBoard3.dragItem(_:)))
            pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(DrawingBoard3.pinchText(sender:)))
    let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotate(recognizer:)))
    rotate.delegate = self
    
    let newWebView = UIWebView(frame: CGRect(x: 15, y: 550, width: self.view.frame.width*0.8, height: 200))
     self.view.addSubview(newWebView)
    newWebView.isHidden = true
    //newWebView.addGestureRecognizer(pinchGesture)
    newWebView.addGestureRecognizer(panGesture)
    newWebView.addGestureRecognizer(rotate)
    //url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        url = URL(string: "https://www.youtube.com/watch?v=\(videoCode)")
        
    newWebView.loadRequest(URLRequest(url: url!))
        newWebView.isHidden = false 
        
    }
    
    func getVideo(videoKey:String) {
         
         let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        
       //  videoWebView.loadRequest(URLRequest(url: url!))
         
     }
    
    
    
    @IBAction func createImageButtonPressed(_ sender: UIButton) {
        //choose an image
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                  print("Button capture")

                  imagePicker.delegate = self
                  imagePicker.sourceType = .savedPhotosAlbum
                  imagePicker.allowsEditing = false
                  present(imagePicker, animated: true, completion: nil)
              }
        
//        func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//              self.dismiss(animated: true, completion: { () -> Void in
//
//              })
//
//         chosenImage = image
//
//        }
        
        
        let seconds = 5.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
     print("🎱🎱🎱🎱🎱🎱🎱🎱🎱🎱🎱🎱 I just chose image")
            self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(DrawingBoard3.dragItem(_:)))
            self.pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(DrawingBoard3.pinchText(sender:)))
            var blankView = UIView(frame: CGRect(x: 0, y: 150, width: self.view.frame.width*0.6, height: 100))
            blankView.backgroundColor = .green
            self.view.addSubview(blankView)
         //  var newImage = UIImageView(frame: CGRect(x: blankView.frame.width/8, y: blankView.frame.height/8 + 10, width: blankView.frame.width*0.75, height: 60))
           var newImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            print("This is before putting chosenImage in \(newImage.image)")
            newImage.image = self.chosenImage
          //  newImage.image = self.chosenImgage
           //  newImage.image = UIImage(named: "the_starry_night-t2")
            self.premadeImageView.image = self.chosenImage
          // self.premadeImageView.image = UIImage(named: "the_starry_night-t2")
            newImage.setNeedsDisplay()
            self.premadeImageView.setNeedsDisplay()
            self.premadeImageView.setNeedsLayout()
            newImage.setNeedsLayout()
            print("This is after putting in premadeImageView \(self.premadeImageView.image!)")
        print(newImage.image!)
        print("Right above me is newimage.image 🚴🏻‍♀️🚴🏻‍♀️🚴🏻‍♀️🚴🏻‍♀️🚴🏻‍♀️🚴🏻‍♀️🚴🏻‍♀️")
        newImage.isUserInteractionEnabled = true

        blankView.addSubview(newImage)
        newImage.image = self.chosenImage
         
            self.selected = newImage
            
            // copied from online
        //add pan gesture
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan))
               gestureRecognizer.delegate = self
             //  newTextView.addGestureRecognizer(gestureRecognizer)
             blankView.addGestureRecognizer(gestureRecognizer)

               //Enable multiple touch and user interaction for textfield
               newImage.isUserInteractionEnabled = true
               newImage.isMultipleTouchEnabled = true

               //add pinch gesture
            let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(self.pinchRecognized(pinch:)))
               pinchGesture.delegate = self
    //           newTextView.addGestureRecognizer(pinchGesture)
             blankView.addGestureRecognizer(pinchGesture)

               //add rotate gesture.
            let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(self.handleRotate(recognizer:)))
               rotate.delegate = self
              // newTextView.addGestureRecognizer(rotate)
            blankView.addGestureRecognizer(rotate)
        }
    }
    

    
    
    
    
    
    
    @objc func dragItem(_ sender: UIPanGestureRecognizer){
        selected = sender.view
        print("calling dragItem \(sender.hashValue)")
           let translation = sender.translation(in: self.view)
           sender.view?.center = CGPoint(x: (sender.view?.center.x)! + translation.x, y: (sender.view?.center.y)! + translation.y)
                sender.setTranslation(CGPoint.zero, in: self.view)
        
        //try to pan over image grid
//        self.view.center = CGPoint(x: (self.view.center.x) + translation.x, y: (self.view.center.y) + translation.y)
        ///sender.setTranslation(CGPoint.zero, in: self.view)
        
            }
    
    
    func adjustUITextViewHeight(textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
    
    @objc func pinchText(sender: UIPinchGestureRecognizer) {
        print("Im in pinch gesture \(sender.hashValue)")
        selected = sender.view
        var pointSize = CGFloat(UserDefaults.standard.float(forKey: "fontSize"))
        pointSize = ((sender.velocity > 0) ? 1 : -1) * 1 + pointSize
        UserDefaults.standard.set(pointSize, forKey: "fontSize")
        UserDefaults.standard.synchronize()

        let formattedText = NSMutableAttributedString.init(attributedString: (selected as! UITextView).attributedText)
        formattedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: pointSize), range: NSRange(location: 0, length: formattedText.length))
        (selected as! UITextView).attributedText = formattedText
         adjustUITextViewHeight(textView: selected as! UITextView)
        print("this is the frame height: \(selected!.frame.height)")
    
    }
    
    @objc func scrollViewPinched(sender: UIPinchGestureRecognizer) {
        print("\(selected) is selected")
        
        if selected is UITextView {
            
    
        print("Im in scroll view pinch gesture \(sender.hashValue)")
      //   selected = sender.view
         var pointSize = CGFloat(UserDefaults.standard.float(forKey: "fontSize"))
         pointSize = ((sender.velocity > 0) ? 1 : -1) * 1 + pointSize
         UserDefaults.standard.set(pointSize, forKey: "fontSize")
         UserDefaults.standard.synchronize()

         let formattedText = NSMutableAttributedString.init(attributedString: (selected as! UITextView).attributedText)
         formattedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: pointSize), range: NSRange(location: 0, length: formattedText.length))
         (selected as! UITextView).attributedText = formattedText
          adjustUITextViewHeight(textView: selected as! UITextView)
         print("this is the frame height: \(selected!.frame.height)")
     
     }
    
    }
    
    
    
    /// copied from online
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
           if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {

               let translation = gestureRecognizer.translation(in: self.view)
               // note: 'view' is optional and need to be unwrapped
               gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
               gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
           }

       }

    @objc func pinchRecognized(pinch: UIPinchGestureRecognizer) {

           if let view = pinch.view {
               view.transform = view.transform.scaledBy(x: pinch.scale, y: pinch.scale)
               pinch.scale = 1
           }
       }

    @objc func handleRotate(recognizer : UIRotationGestureRecognizer) {
           if let view = recognizer.view {
               view.transform = view.transform.rotated(by: recognizer.rotation)
               recognizer.rotation = 0
           }
       }

       //MARK:- UIGestureRecognizerDelegate Methods
       func gestureRecognizer(_: UIGestureRecognizer,
           shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
           return true
       }
    
    
    
    

}


 extension UITextView {

    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }

}
