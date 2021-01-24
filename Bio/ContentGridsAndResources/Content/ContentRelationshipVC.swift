//
//  ContentRelationshipVC.swift
//  Bio
//
//  Created by Ann McDonough on 12/27/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit


class ContentRelationship: UIViewController, UIScrollViewDelegate {
    
    var relationshipHex: HexagonStructData?
    var showOpenAppButton = false
    var scrollView = UIScrollView()
    var newImageView: UIImageView?
    var userDataVM: UserDataVM?
   // var captionTextField = UITextField()
    
    var viewAlreadyLoaded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewAlreadyLoaded {
            return
        }
        viewAlreadyLoaded = true
        view.backgroundColor = .white
        setUpScrollView()
        setZoomScale()
        
        var imageText = "\(relationshipHex!.text.lowercased())"
        newImageView = UIImageView(image: UIImage(named: imageText))
//     /
        scrollView.addSubview(newImageView!)
        scrollView.bringSubviewToFront(newImageView!)
        
       // let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 65)
      //  let smallframe = CGRect(x: view.frame.width/3, y: view.frame.height/12, width: view.frame.width/3, height: view.frame.width/3)
        let frame = CGRect(x: view.frame.width/6, y: view.frame.height/12, width: view.frame.width*(2/3), height: view.frame.width*(2/3))
        let birthdayFrame = CGRect(x: 0, y: frame.maxY + 5, width: view.frame.width, height: 20)
        let ageFrame = CGRect(x: 0, y: birthdayFrame.maxY + 5, width: view.frame.width, height: 20)
        let zodiacFrame = CGRect(x: 0, y: ageFrame.maxY + 5, width: view.frame.width, height: 20)
//        captionTextField.font = UIFont(name: "DINAlternate-Bold", size: 28)
//        captionTextField.textAlignment = .center
//        captionTextField.isUserInteractionEnabled = false
        newImageView!.frame = frame
        newImageView?.layer.cornerRadius = (frame.width)/2
        newImageView!.backgroundColor = .black
        
        newImageView!.contentMode = .scaleAspectFit
        newImageView!.isUserInteractionEnabled = true
        setUpCaption()
        //let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //newImageView.addGestureRecognizer(tap)
        
        let textView = UITextView()
        textView.text = "asdfkjlasdfjasdf"
        textView.textColor = .red
        // Do any additional setup after loading the view.
        
      //  captionTextField.frame = captionFrame
        
    }
    

    let label1 = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()
    
    func setUpCaption() {
        
        scrollView.addSubview(label1)
        scrollView.addSubview(label2)
        scrollView.addSubview(label3)
        var relationshipStatus = relationshipHex!.text
        var relationshipText = ""
        if relationshipStatus.contains("complicated") {
         relationshipText = "relationship status: \(relationshipStatus.lowercased())"
            label1.font = UIFont(name: "DINAlternate-Bold", size: 18)
        }
        else {
        relationshipText = "\(relationshipHex!.resource) is \(relationshipStatus.lowercased())"
            label1.font = UIFont(name: "DINAlternate-Bold", size: 28)
        }
        
        var zodiacLowerCased = "\(relationshipHex!.text)"
        var zodiac = zodiacLowerCased.capitalizingFirstLetter()
        var zodiacText = "Zodiac: \(zodiac)"
        
        label1.text = relationshipText
        label1.numberOfLines = 0
        label2.text = ""
        label3.text = ""
        let captionFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 66)
//        label1.font = UIFont(name: "DINAlternate-Bold", size: 28)
        label3.font = UIFont(name: "DINAlternate-Bold", size: 28)
        label2.font = UIFont(name: "DINAlternate-Bold", size: 28)
        let frame = CGRect(x: view.frame.width/3, y: view.frame.height/12, width: view.frame.width/3, height: view.frame.width/3)
        let label1Frame = CGRect(x: 0, y: (newImageView?.frame.maxY)! + 20, width: view.frame.width, height: 30)
        let label2Frame = CGRect(x: 0, y: label1Frame.maxY + 20, width: view.frame.width, height: 30)
        let label3Frame = CGRect(x: 0, y: label2Frame.maxY + 20, width: view.frame.width, height: 30)
        label1.frame = label1Frame
        label2.frame = label2Frame
        label3.frame = label3Frame
        label1.textColor = .black
        label2.textColor = .black
        label3.textColor = .black
        label1.textAlignment = .center
        label2.textAlignment = .center
        label3.textAlignment = .center
        
        
        
        label1.textAlignment = .center
        label1.isUserInteractionEnabled = false
        print("This is caption text \(relationshipText)")
        print("This is text field text \(label1.text)")
        label1.textColor = .black
     //   birthdayLabel.frame = captionFrame
    //    captionTextField.size
        
        print()
    }
    
    override func loadView() {
        view = scrollView
    }
    
    override func viewDidLayoutSubviews() {
        let frame = CGRect(x: view.frame.width/6, y: view.frame.height/12, width: view.frame.width*(2/3), height: view.frame.width*(2/3))
        let birthdayFrame = CGRect(x: 0, y: frame.maxY + 5, width: view.frame.width, height: 20)
        let ageFrame = CGRect(x: 0, y: birthdayFrame.maxY + 5, width: view.frame.width, height: 20)
        let zodiacFrame = CGRect(x: 0, y: ageFrame.maxY + 5, width: view.frame.width, height: 20)
//        captionTextField.font = UIFont(name: "DINAlternate-Bold", size: 28)
//        captionTextField.textAlignment = .center
//        captionTextField.isUserInteractionEnabled = false
        newImageView!.frame = frame
        newImageView?.layer.cornerRadius = (frame.width)/2
        newImageView!.backgroundColor = .black
        
        newImageView!.contentMode = .scaleAspectFit
        newImageView!.isUserInteractionEnabled = true
        
        
        let label1Frame = CGRect(x: 0, y: (newImageView?.frame.maxY)! + 20, width: view.frame.width, height: 30)
        let label2Frame = CGRect(x: 0, y: label1Frame.maxY + 20, width: view.frame.width, height: 30)
        let label3Frame = CGRect(x: 0, y: label2Frame.maxY + 20, width: view.frame.width, height: 30)
        label1.frame = label1Frame
        label2.frame = label2Frame
        label3.frame = label3Frame
    }
    
    // viewdidload helper functions
    func setUpScrollView() {
        //view.addSubview(scrollView)
        //scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 65)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.backgroundColor = .white
        //scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentMode = .scaleAspectFit
        scrollView.bouncesZoom = false
        
    }
    
    func setZoomScale() {

        scrollView.maximumZoomScale = 60
        scrollView.minimumZoomScale = 1
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = newImageView!.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height)/2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width)/2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return newImageView
    }
    
//    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        for view in view.subviews {
//            view.removeFromSuperview()
//        }
//        self.dismiss(animated: false, completion: nil)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
