//
//  ContentImageVC.swift
//  
//
//  Created by Andrew Williamson on 9/28/20.
//

import UIKit

class ContentImageVC: UIViewController, UIScrollViewDelegate {
    
    var photoHex: HexagonStructData?
    var showOpenAppButton = false
    var scrollView = UIScrollView()
    var newImageView: UIImageView?
    var userDataVM: UserDataVM?
   // var captionTextField = UITextField()
    
    override func loadView() {
        view = scrollView
    }
    
    var viewAlreadyLoaded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewAlreadyLoaded {
            return
        }
        viewAlreadyLoaded = true
        
        setUpScrollView()
        setZoomScale()
        
        
        newImageView = UIImageView(image: UIImage(named: "kbit"))
        let cleanRef = photoHex!.thumbResource.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        newImageView!.sd_setImage(with: url!, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
        scrollView.addSubview(newImageView!)
        scrollView.bringSubviewToFront(newImageView!)
        
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//        let captionFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 66)
//        captionTextField.font = UIFont(name: "DINAlternate-Bold", size: 28)
//        captionTextField.textAlignment = .center
//        captionTextField.isUserInteractionEnabled = false
        newImageView!.frame = frame
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
    
    override func viewDidLayoutSubviews() {
        newImageView!.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }
    
    func setUpCaption() {
        let captionTextField = UITextField()
        scrollView.addSubview(captionTextField)
        let captionText = photoHex?.text
        captionTextField.text = captionText
        let captionFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 66)
        captionTextField.font = UIFont(name: "DINAlternate-Bold", size: 28)
        captionTextField.textAlignment = .center
        captionTextField.isUserInteractionEnabled = false
        captionTextField.textColor = .white
        captionTextField.frame = captionFrame
    //    captionTextField.size
        
        print()
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
        scrollView.backgroundColor = .black
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

}
