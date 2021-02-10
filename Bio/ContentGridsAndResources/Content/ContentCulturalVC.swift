//
//  ContentCulturalVC.swift
//  Bio
//
//  Created by Ann McDonough on 12/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class ContentCulturalVC: UIViewController, UIScrollViewDelegate {
    var minimumFontSize = CGFloat(28)
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
    var countryLabel4 = UILabel()
    var countryLabel5 = UILabel()
    var countryLabel6 = UILabel()
    var countryImage4 = UIImageView()
    var countryImage5 = UIImageView()
    var countryImage6 = UIImageView()
    var countryText1 = ""
    var countryText2 = ""
    var countryText3 = ""
    var countryText4 = ""
    var countryText5 = ""
    var countryText6 = ""
   // var captionTextField = UITextField()
    
    var viewAlreadyLoaded = false
    var captionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewAlreadyLoaded {
            return
        }
        viewAlreadyLoaded = true
        view.backgroundColor = .white
        
        setUpScrollView()
        setZoomScale()
        
        myCountries = cultureHex!.array
        countryText1 = ""
        countryText2 = ""
        countryText3 = ""
        
        captionLabel.text = "Ethnicity"
        captionLabel.textColor = .black
        captionLabel.font = UIFont(name: "DINAlternate-Bold", size: 28)
        captionLabel.textAlignment = .center
        scrollView.addSubview(captionLabel)
        captionLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 66)

        if myCountries.count > 0 {
         countryText1 = myCountries[0]
        }
        if myCountries.count > 1 {
         countryText2 = myCountries[1]
        }
        if myCountries.count > 2 {
         countryText3 = myCountries[2]
        }
        if myCountries.count > 3 {
         countryText4 = myCountries[3]
        }
        if myCountries.count > 4 {
         countryText5 = myCountries[4]
        }
        if myCountries.count > 5 {
         countryText6 = myCountries[5]
        }
        var countryText1Formatted = countryText1.replacingOccurrences(of: " ", with: "-")
        var countryText2Formatted = countryText2.replacingOccurrences(of: " ", with: "-")
        var countryText3Formatted = countryText3.replacingOccurrences(of: " ", with: "-")
      countryText1Formatted = countryText1Formatted.lowercased()
        countryText2Formatted = countryText2Formatted.lowercased()
        countryText3Formatted = countryText3Formatted.lowercased()
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
        
        
        
        var countryText4Formatted = countryText4.replacingOccurrences(of: " ", with: "-")
        var countryText5Formatted = countryText5.replacingOccurrences(of: " ", with: "-")
        var countryText6Formatted = countryText6.replacingOccurrences(of: " ", with: "-")
      countryText4Formatted = countryText4Formatted.lowercased()
        countryText5Formatted = countryText5Formatted.lowercased()
        countryText6Formatted = countryText6Formatted.lowercased()
        if countryText4 != "" {
            countryImage4.image = UIImage(named: countryText4Formatted)
            countryLabel4.text = countryText4.capitalized
        }
        if countryText5 != "" {
            countryImage5.image = UIImage(named: countryText5Formatted)
            countryLabel5.text = countryText5.capitalized
        }
        if countryText6 != "" {
            countryImage6.image = UIImage(named: countryText6Formatted)
            countryLabel6.text = countryText6.capitalized
        }
    
        let frame = CGRect(x: view.frame.width/3, y: view.frame.height/24, width: view.frame.width/3, height: view.frame.width/3)
    
        countryImage1.frame = frame
        countryImage1.layer.cornerRadius = (frame.width)/2
        countryImage1.backgroundColor = .clear
        
        countryImage1.contentMode = .scaleAspectFit
        countryImage1.isUserInteractionEnabled = true
        
        
        scrollView.addSubview(countryImage1)
        scrollView.addSubview(countryLabel1)
        scrollView.addSubview(countryImage2)
        scrollView.addSubview(countryLabel2)
        scrollView.addSubview(countryImage3)
        scrollView.addSubview(countryLabel3)
        scrollView.addSubview(countryImage4)
        scrollView.addSubview(countryLabel4)
        scrollView.addSubview(countryImage5)
        scrollView.addSubview(countryLabel5)
        scrollView.addSubview(countryImage6)
        scrollView.addSubview(countryLabel6)
        
        divyUpFrames()
      
        
    }
    
    func divyUpFrames() {
        captionLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 66)

        if myCountries.count == 1 {
            setUp1Country()
        }
        else if myCountries.count == 2 {
            setUp2Country()
        }
        else if myCountries.count == 3 {
            setUp3CountryAlternative()
        }
        else if myCountries.count == 4 {
            setUp4Country()
        }
        else if myCountries.count == 5 {
            setUp5Country()
        }
        else if myCountries.count == 6 {
            setUp6Country()
        }
        setUpLabels()
    }
    
    
    func setUpLabels() {
        countryLabel1.textColor = .black
        countryLabel1.font = UIFont(name: "DINAlternate-Bold", size: minimumFontSize)
        countryLabel1.textAlignment = .center
        countryLabel2.textColor = .black
        countryLabel2.font = UIFont(name: "DINAlternate-Bold", size: minimumFontSize)
        countryLabel2.textAlignment = .center
        countryLabel3.textColor = .black
        countryLabel3.font = UIFont(name: "DINAlternate-Bold", size: minimumFontSize)
        countryLabel3.textAlignment = .center
        countryLabel4.textColor = .black
        countryLabel4.font = UIFont(name: "DINAlternate-Bold", size: minimumFontSize)
        countryLabel4.textAlignment = .center
        countryLabel5.textColor = .black
        countryLabel5.font = UIFont(name: "DINAlternate-Bold", size: minimumFontSize)
        countryLabel5.textAlignment = .center
        countryLabel6.textColor = .black
        countryLabel6.font = UIFont(name: "DINAlternate-Bold", size: minimumFontSize)
        countryLabel6.textAlignment = .center

        
        countryLabel1.textAlignment = .center
        countryLabel2.textAlignment = .center
        countryLabel3.textAlignment = .center
        countryLabel4.textAlignment = .center
        countryLabel5.textAlignment = .center
        countryLabel6.textAlignment = .center
    }

    
    func setUp1Country() {

        let frame = CGRect(x: view.frame.width/6, y: captionLabel.frame.maxY + 10, width: view.frame.width*(2/3), height: view.frame.width*(2/3))
        countryImage1.frame = frame
        let label1Frame = CGRect(x: 0, y: (countryImage1.frame.maxY) + 20, width: view.frame.width, height: 30)
        countryLabel1.frame = label1Frame
         countryText1 = myCountries[0]
        countryLabel1.text = countryText1
    }
    
    func setUp2Country() {

        countryLabel1.text = myCountries[0]
        countryLabel2.text = myCountries[1]
        let frame1 = CGRect(x: view.frame.width/3, y: captionLabel.frame.maxY + 10, width: view.frame.width/3, height: view.frame.width/3)
        let label1frame = CGRect(x: 0, y: frame1.maxY + 10, width: view.frame.width, height: 30)
        let country2imageFrame = CGRect(x: view.frame.width/3, y: label1frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        let country2LabelFrame = CGRect(x: 0, y: country2imageFrame.maxY + 10, width: view.frame.width, height: 30)
        countryLabel1.frame = label1frame
        countryLabel2.frame = country2LabelFrame
        countryImage1.frame = frame1
        countryLabel1.frame = label1frame
        countryImage2.frame = country2imageFrame
        countryLabel2.frame = country2LabelFrame
        
    }
    func setUp3Country() {

        countryLabel1.text = myCountries[0]
        countryLabel2.text = myCountries[1]
        countryLabel3.text = myCountries[2]
        let frame1 = CGRect(x: view.frame.width/3, y: captionLabel.frame.maxY + 10, width: view.frame.width/3, height: view.frame.width/3)
        let label1frame = CGRect(x: 0, y: frame1.maxY + 10, width: view.frame.width, height: 30)
        let country2imageFrame = CGRect(x: view.frame.width/3, y: label1frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        let country2LabelFrame = CGRect(x: 0, y: country2imageFrame.maxY + 10, width: view.frame.width, height: 30)
        countryLabel1.frame = label1frame
        countryLabel2.frame = country2LabelFrame
        let frame3 = CGRect(x: view.frame.width/3, y: countryLabel2.frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        let country3LabelFrame = CGRect(x: 0, y: frame3.maxY + 10, width: view.frame.width, height: 30)
        countryImage1.frame = frame1
        countryLabel1.frame = label1frame
        countryImage2.frame = country2imageFrame
        countryLabel2.frame = country2LabelFrame
        countryImage3.frame = frame3
        countryLabel3.frame = country3LabelFrame
    }
    
    func setUp3CountryAlternative() {

        countryLabel1.text = myCountries[0]
        countryLabel2.text = myCountries[1]
        countryLabel3.text = myCountries[2]
        let frame1 = CGRect(x: view.frame.width/3, y: captionLabel.frame.maxY + 10, width: view.frame.width/3, height: view.frame.width/3)
        let label1frame = CGRect(x: 0, y: frame1.maxY + 10, width: view.frame.width, height: 30)
        let country2imageFrame = CGRect(x: view.frame.width/9, y: label1frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        let country2LabelFrame = CGRect(x: view.frame.width/9, y: country2imageFrame.maxY + 10, width: view.frame.width/3, height: 30)
        countryLabel2.frame = country2LabelFrame

        let country5imageFrame = CGRect(x: view.frame.width*(5/9), y: label1frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        let country5LabelFrame = CGRect(x: view.frame.width*(5/9), y: country2imageFrame.maxY + 10, width: view.frame.width/3, height: 30)
        countryLabel2.frame = country2LabelFrame
        countryImage1.frame = frame1
        countryLabel1.frame = label1frame
        countryImage2.frame = country2imageFrame
        countryLabel2.frame = country2LabelFrame
        countryImage3.frame = country5imageFrame
        countryLabel3.frame = country5LabelFrame
    }
    
    
    func setUp4Country() {

        countryLabel1.text = myCountries[0]
        countryLabel2.text = myCountries[1]
        countryLabel3.text = myCountries[2]
        countryLabel4.text = myCountries[3]
        let frame1 = CGRect(x: view.frame.width/9, y: captionLabel.frame.maxY + 10, width: view.frame.width/3, height: view.frame.width/3)
        let label1frame = CGRect(x: view.frame.width/9, y: frame1.maxY + 10, width: view.frame.width/3, height: 30)
        let country2imageFrame = CGRect(x: view.frame.width/9, y: label1frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        let country2LabelFrame = CGRect(x: view.frame.width/9, y: country2imageFrame.maxY + 10, width: view.frame.width/3, height: 30)
        countryLabel2.frame = country2LabelFrame

        let frame4 = CGRect(x: view.frame.width*(5/9), y: captionLabel.frame.maxY + 10, width: view.frame.width/3, height: view.frame.width/3)
        let label4frame = CGRect(x: view.frame.width*(5/9), y: frame1.maxY + 10, width: view.frame.width/3, height: 30)
        let country5imageFrame = CGRect(x: view.frame.width*(5/9), y: label1frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        let country5LabelFrame = CGRect(x: view.frame.width*(5/9), y: country2imageFrame.maxY + 10, width: view.frame.width/3, height: 30)
        countryLabel2.frame = country2LabelFrame
        countryImage1.frame = frame1
        countryLabel1.frame = label1frame
        countryImage2.frame = frame4
        countryLabel2.frame = label4frame
        countryImage3.frame = country2imageFrame
        countryLabel3.frame = country2LabelFrame
        countryImage4.frame = country5imageFrame
        countryLabel4.frame = country5LabelFrame
     
        
    }
    func setUp5Country() {

        countryLabel1.text = myCountries[0]
        countryLabel2.text = myCountries[1]
        countryLabel3.text = myCountries[2]
        countryLabel4.text = myCountries[3]
        countryLabel5.text = myCountries[4]
        let frame1 = CGRect(x: view.frame.width/3, y: captionLabel.frame.maxY + 10, width: view.frame.width/3, height: view.frame.width/3)
        let label1frame = CGRect(x: 0, y: frame1.maxY + 10, width: view.frame.width, height: 30)
        let country2imageFrame = CGRect(x: view.frame.width/9, y: label1frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        let country2LabelFrame = CGRect(x: view.frame.width/9, y: country2imageFrame.maxY + 10, width: view.frame.width/3, height: 30)
        countryLabel2.frame = country2LabelFrame
        let frame3 = CGRect(x: view.frame.width/9, y: countryLabel2.frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        let country3LabelFrame = CGRect(x: view.frame.width/9, y: frame3.maxY + 10, width: view.frame.width/3, height: 30)

        let country5imageFrame = CGRect(x: view.frame.width*(5/9), y: label1frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        let country5LabelFrame = CGRect(x: view.frame.width*(5/9), y: country2imageFrame.maxY + 10, width: view.frame.width/3, height: 30)
        countryLabel2.frame = country2LabelFrame
        let frame6 = CGRect(x: view.frame.width*(5/9), y: countryLabel2.frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        let country6LabelFrame = CGRect(x: view.frame.width*(5/9), y: frame3.maxY + 10, width: view.frame.width/3, height: 30)
        countryImage1.frame = frame1
        countryLabel1.frame = label1frame
        countryImage2.frame = country2imageFrame
        countryLabel2.frame = country2LabelFrame
        countryImage3.frame = country5imageFrame
        countryLabel3.frame = country5LabelFrame
        countryImage4.frame = frame3
        countryLabel4.frame = country3LabelFrame
        countryImage5.frame = frame6
        countryLabel5.frame = country6LabelFrame
    }
    func setUp6Country() {

        countryLabel1.text = myCountries[0]
        countryLabel2.text = myCountries[1]
        countryLabel3.text = myCountries[2]
        countryLabel4.text = myCountries[3]
        countryLabel5.text = myCountries[4]
        countryLabel6.text = myCountries[5]
        let frame1 = CGRect(x: view.frame.width/9, y: captionLabel.frame.maxY + 10, width: view.frame.width/3, height: view.frame.width/3)
        let label1frame = CGRect(x: view.frame.width/9, y: frame1.maxY + 10, width: view.frame.width/3, height: 30)
        let country2imageFrame = CGRect(x: view.frame.width/9, y: label1frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        let country2LabelFrame = CGRect(x: view.frame.width/9, y: country2imageFrame.maxY + 10, width: view.frame.width/3, height: 30)
        countryLabel2.frame = country2LabelFrame
        let frame3 = CGRect(x: view.frame.width/9, y: countryLabel2.frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        let country3LabelFrame = CGRect(x: view.frame.width/9, y: frame3.maxY + 10, width: view.frame.width/3, height: 30)
        
        
        let frame4 = CGRect(x: view.frame.width*(5/9), y: captionLabel.frame.maxY + 10, width: view.frame.width/3, height: view.frame.width/3)
        let label4frame = CGRect(x: view.frame.width*(5/9), y: frame1.maxY + 10, width: view.frame.width/3, height: 30)
        let country5imageFrame = CGRect(x: view.frame.width*(5/9), y: label1frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        let country5LabelFrame = CGRect(x: view.frame.width*(5/9), y: country2imageFrame.maxY + 10, width: view.frame.width/3, height: 30)
        countryLabel2.frame = country2LabelFrame
        let frame6 = CGRect(x: view.frame.width*(5/9), y: countryLabel2.frame.maxY + 20, width: view.frame.width/3, height: view.frame.width/3)
        let country6LabelFrame = CGRect(x: view.frame.width*(5/9), y: frame3.maxY + 10, width: view.frame.width/3, height: 30)
        countryImage1.frame = frame1
        countryLabel1.frame = label1frame
        countryImage2.frame = country2imageFrame
        countryLabel2.frame = country2LabelFrame
        countryImage3.frame = frame3
        countryLabel3.frame = country3LabelFrame
        countryImage4.frame = frame4
        countryLabel4.frame = label4frame
        countryImage5.frame = country5imageFrame
        countryLabel5.frame = country5LabelFrame
        countryImage6.frame = frame6
        countryLabel6.frame = country6LabelFrame
        
    }
    
    override func viewWillLayoutSubviews() {
        divyUpFrames()
        if countryLabel1.text != "" && countryLabel1.text != nil {
        countryLabel1.text = countryLabel1.text!.capitalizingFirstLetter()
        countryLabel1.numberOfLines = 1
        countryLabel1.adjustsFontSizeToFitWidth = true
        
        }
        if countryLabel2.text != "" && countryLabel3.text !=  nil {
        countryLabel2.text = countryLabel2.text!.capitalizingFirstLetter()
            countryLabel2.numberOfLines = 1
            countryLabel2.adjustsFontSizeToFitWidth = true
        }
        if countryLabel3.text != "" && countryLabel3.text != nil {
        countryLabel3.text = countryLabel3.text!.capitalizingFirstLetter()
            countryLabel3.numberOfLines = 1
            countryLabel3.adjustsFontSizeToFitWidth = true
        }
        if countryLabel4.text != "" && countryLabel4.text != nil  {
        countryLabel4.text = countryLabel4.text!.capitalizingFirstLetter()
            countryLabel4.numberOfLines = 1
            countryLabel4.adjustsFontSizeToFitWidth = true
        }
        if countryLabel5.text != "" && countryLabel5.text != nil  {
        countryLabel5.text = countryLabel5.text!.capitalizingFirstLetter()
            countryLabel5.numberOfLines = 1
            countryLabel5.adjustsFontSizeToFitWidth = true
        }
        if countryLabel6.text != "" && countryLabel6.text != nil  {
        countryLabel6.text = countryLabel6.text!.capitalizingFirstLetter()
            countryLabel6.numberOfLines = 1
            countryLabel6.adjustsFontSizeToFitWidth = true
        }
        let size1 = countryLabel1.font.pointSize
        let size2 = countryLabel2.font.pointSize
        let size3 = countryLabel3.font.pointSize
        let size4 = countryLabel4.font.pointSize
        let size5 = countryLabel5.font.pointSize
        let size6 = countryLabel6.font.pointSize
        let sizeArray = [size1, size2, size3, size4, size5
        , size6]
        var index = 0
        for size in sizeArray {
            print("This is size for \(index): \(size)")
            index = index + 1
        }
        self.minimumFontSize = sizeArray.min()!
        print("This is smallest size \(self.minimumFontSize)")
        countryLabel1.font.withSize(self.minimumFontSize)
        countryLabel2.font.withSize(self.minimumFontSize)
        countryLabel3.font.withSize(self.minimumFontSize)
        countryLabel4.font.withSize(self.minimumFontSize)
        countryLabel5.font.withSize(self.minimumFontSize)
        countryLabel6.font.withSize(self.minimumFontSize)
        

    }
    
    override func loadView() {
        view = scrollView
    }
    
    // viewdidload helper functions
    func setUpScrollView() {
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
        let imageViewSize = countryImage1.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height)/2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width)/2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return countryImage1
    }
}
