//
//  ContentCulturalVC.swift
//  Bio
//
//  Created by Ann McDonough on 12/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class ContentCulturalVC: UIViewController, UIScrollViewDelegate {
    
    var cultureHex: HexagonStructData?
    var showOpenAppButton = false
    var scrollView = UIScrollView()
    var userDataVM: UserDataVM?
    var myCountries: [String] = []
    var countryLabel1 = UILabel()
    var countryLabel2 = UILabel()
    var countryLabel3 = UILabel()
    var countryImage1 = UIImageView()
    var countryImage2 = UIImageView()
    var countryImage3 = UIImageView()
    var countryText1 = ""
    var countryText2 = ""
    var countryText3 = ""
   // var captionTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpScrollView()
        setZoomScale()
        
        
//        let cleanRef = cultureHex!.thumbResource.replacingOccurrences(of: "/", with: "%2F")
//        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
//        countryImage1.sd_setImage(with: url!, completed: {_, error, _, _ in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//        })
       
        
       // let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 65)
        let frame = CGRect(x: view.frame.width/3, y: view.frame.height/24, width: view.frame.width/3, height: view.frame.width/3)
        let birthdayFrame = CGRect(x: 0, y: frame.maxY + 5, width: view.frame.width, height: 20)
        let ageFrame = CGRect(x: 0, y: birthdayFrame.maxY + 5, width: view.frame.width, height: 20)
        let zodiacFrame = CGRect(x: 0, y: ageFrame.maxY + 5, width: view.frame.width, height: 20)
//        captionTextField.font = UIFont(name: "DINAlternate-Bold", size: 28)
//        captionTextField.textAlignment = .center
//        captionTextField.isUserInteractionEnabled = false
        countryImage1.frame = frame
        countryImage1.layer.cornerRadius = (frame.width)/2
        countryImage1.backgroundColor = .black
        
        countryImage1.contentMode = .scaleAspectFit
        countryImage1.isUserInteractionEnabled = true
        setUpCaption()
        //let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //newImageView.addGestureRecognizer(tap)
        
        let textView = UITextView()
        textView.text = "asdfkjlasdfjasdf"
        textView.textColor = .red
        // Do any additional setup after loading the view.
        
      //  captionTextField.frame = captionFrame
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        myCountries = cultureHex!.array
         countryText1 = myCountries[0] ?? ""
         countryText2 = myCountries[1] ?? ""
         countryText3 = myCountries[2] ?? ""
        var countryText1Formatted = countryText1.replacingOccurrences(of: " ", with: "-")
        var countryText2Formatted = countryText2.replacingOccurrences(of: " ", with: "-")
        var countryText3Formatted = countryText3.replacingOccurrences(of: " ", with: "-")
        if countryText1 != "" {
            countryImage1.image = UIImage(named: countryText1Formatted)
            countryLabel1.text = countryText1.capitalized
        }
        if countryText2 != "" {
            countryImage2.image = UIImage(named: countryText2Formatted)
            countryLabel2.text = countryText2.capitalized
        }
        if countryText3 != "" {
            countryImage3.image = UIImage(named: countryText3Formatted)
            countryLabel3.text = countryText3.capitalized
        }

   
  
        
        
    }

    
    func setUpCaption() {
        scrollView.addSubview(countryImage1)
        scrollView.addSubview(countryLabel1)
        scrollView.addSubview(countryLabel2)
        scrollView.addSubview(countryLabel3)
        scrollView.addSubview(countryImage2)
        scrollView.addSubview(countryImage3)
    
  
        
        countryLabel1.text = countryText1
        countryLabel2.text = countryText2
        countryLabel3.text = countryText3
        let captionFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 66)
        countryLabel1.font = UIFont(name: "DINAlternate-Bold", size: 28)
        countryLabel3.font = UIFont(name: "DINAlternate-Bold", size: 28)
        countryLabel2.font = UIFont(name: "DINAlternate-Bold", size: 28)
        var frame1 = CGRect(x: view.frame.width/3, y: view.frame.height/12, width: view.frame.width/3, height: view.frame.width/3)
        let label1frame = CGRect(x: 0, y: (countryImage1.frame.maxY) + 20, width: view.frame.width, height: 30)
        let country2imageFrame = CGRect(x: view.frame.width/3, y: label1frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        var country2LabelFrame = CGRect(x: 0, y: country2imageFrame.maxY + 10, width: view.frame.width, height: 30)
        countryLabel1.frame = label1frame
        var frame2 = CGRect(x: view.frame.width/3, y: countryLabel1.frame.maxY + 10, width: view.frame.width/3, height: view.frame.width/3)
        countryLabel2.frame = country2LabelFrame
        var countryImage3Frame = CGRect(x: view.frame.width/3, y: countryLabel2.frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        var country3LabelFrame = CGRect(x: 0, y: countryImage3Frame.maxY + 10, width: view.frame.width, height: 30)
        countryImage2.frame = country2imageFrame
        countryImage3.frame = countryImage3Frame
        countryLabel2.frame = country2LabelFrame
        countryLabel3.frame = country3LabelFrame
        countryLabel1.textColor = .white
        countryLabel2.textColor = .white
        countryLabel3.textColor = .white
        countryLabel1.textAlignment = .center
        countryLabel2.textAlignment = .center
        countryLabel3.textAlignment = .center
        
        
        
        countryLabel1.textAlignment = .center
        countryLabel1.isUserInteractionEnabled = false
        print("This is caption text \(countryText1)")
        print("This is text field text \(countryLabel1.text)")
        countryLabel1.textColor = .white
     //   birthdayLabel.frame = captionFrame
    //    captionTextField.size
        
        print()
    }
    
    // viewdidload helper functions
    func setUpScrollView() {
        view.addSubview(scrollView)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 65)
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
        let imageViewSize = countryImage1.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height)/2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width)/2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return countryImage1
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
