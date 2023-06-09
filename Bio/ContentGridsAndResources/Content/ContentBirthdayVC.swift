//
//  ContentBirthdayVC.swift
//  Bio
//
//  Created by Ann McDonough on 12/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class ContentBirthdayVC: UIViewController, UIScrollViewDelegate {
    
    var birthdayHex: HexagonStructData?
    var showOpenAppButton = false
    var scrollView = UIScrollView()
    var newImageView: UIImageView?
    var userDataVM: UserDataVM?
    
    var viewAlreadyLoaded = false
   // var captionTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewAlreadyLoaded {
            return
        }
        viewAlreadyLoaded = true
        view.backgroundColor = .white
        setUpScrollView()
        setZoomScale()
        
        
        newImageView = UIImageView(image: UIImage(named: "kbit"))
        let cleanRef = birthdayHex!.thumbResource.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        newImageView!.sd_setImage(with: url!, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
        scrollView.addSubview(newImageView!)
        scrollView.bringSubviewToFront(newImageView!)

        let frame = CGRect(x: view.frame.width/6, y: view.frame.height/12, width: view.frame.width*(2/3), height: view.frame.width*(2/3))

        newImageView!.frame = frame
        newImageView?.layer.cornerRadius = (frame.width)/2
        newImageView!.backgroundColor = .clear
        
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
    
    override func viewWillLayoutSubviews() {
        let frame = CGRect(x: view.frame.width/6, y: view.frame.height/12, width: view.frame.width*(2/3), height: view.frame.width*(2/3))

        newImageView!.frame = frame
        
        let birthdayFrame = CGRect(x: 0, y: (newImageView?.frame.maxY)! + 20, width: view.frame.width, height: 30)
        let ageFrame = CGRect(x: 0, y: birthdayFrame.maxY + 20, width: view.frame.width, height: 30)
        let zodiacFrame = CGRect(x: 0, y: ageFrame.maxY + 20, width: view.frame.width, height: 30)
        birthdayLabel.frame = birthdayFrame
        ageLabel.frame = ageFrame
        zodiacLabel.frame = zodiacFrame
        
        
    }
    
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
     //   self.myZodiac = getZodiacSign(birthdayDate!)
       // print("This is my zodiac \(self.myZodiac)")
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
    let birthdayLabel = UILabel()
    let ageLabel = UILabel()
    let zodiacLabel = UILabel()
    
    func setUpCaption() {
        scrollView.addSubview(birthdayLabel)
        scrollView.addSubview(ageLabel)
        scrollView.addSubview(zodiacLabel)
        let formattedBirthday = formatBirthday(date: birthdayHex!.resource)
        let birthdayText = "Birthday: \(formattedBirthday)"
        let zodiacLowerCased = "\(birthdayHex!.text)"
        let zodiac = zodiacLowerCased.capitalizingFirstLetter()
        let zodiacText = "Zodiac: \(zodiac)"
        
        birthdayLabel.text = birthdayText
        let theAge = calcAge(birthday: birthdayHex!.resource)
        ageLabel.text = "Age: \(theAge) years old"
        zodiacLabel.text = zodiacText
        _ = CGRect(x: 0, y: 0, width: view.bounds.width, height: 66)
        birthdayLabel.font = UIFont(name: "DINAlternate-Bold", size: 28)
        zodiacLabel.font = UIFont(name: "DINAlternate-Bold", size: 28)
        ageLabel.font = UIFont(name: "DINAlternate-Bold", size: 28)
        _ = CGRect(x: view.frame.width/3, y: view.frame.height/12, width: view.frame.width/3, height: view.frame.width/3)
        let birthdayFrame = CGRect(x: 0, y: (newImageView?.frame.maxY)! + 20, width: view.frame.width, height: 30)
        let ageFrame = CGRect(x: 0, y: birthdayFrame.maxY + 20, width: view.frame.width, height: 30)
        let zodiacFrame = CGRect(x: 0, y: ageFrame.maxY + 20, width: view.frame.width, height: 30)
        birthdayLabel.frame = birthdayFrame
        ageLabel.frame = ageFrame
        zodiacLabel.frame = zodiacFrame
        birthdayLabel.textColor = .black
        ageLabel.textColor = .black
        zodiacLabel.textColor = .black
        birthdayLabel.textAlignment = .center
        ageLabel.textAlignment = .center
        zodiacLabel.textAlignment = .center
        
        
        
        birthdayLabel.textAlignment = .center
        birthdayLabel.isUserInteractionEnabled = false
        birthdayLabel.textColor = .black
     //   birthdayLabel.frame = captionFrame
    //    captionTextField.size
        
        print()
    }
    
    func formatBirthday(date: String) -> String {
        print("This is date \(date)")
        let dateArray = date.components(separatedBy: "/")
        let month = dateArray[0]
        let day = dateArray[1]
        _ = dateArray[2]
        var monthString = ""
        switch (month) {
        case "01":
            monthString = "January"
        case "02":
            monthString = "February"
        case "03":
            monthString = "March"
        case "04":
            monthString = "April"
        case "05":
            monthString = "May"
        case "06":
            monthString = "June"
        case "07":
            monthString = "July"
        case "08":
            monthString = "August"
        case "09":
            monthString = "September"
        case "10":
            monthString = "October"
        case "11":
            monthString = "November"
        case "12":
            monthString = "December"
        default:
            monthString = "January"
        }
        var dayString = ""
        switch (day) {
        case "01":
           dayString = "1"
        case "02":
            dayString = "2"
        case "03":
            dayString = "3"
        case "04":
            dayString = "4"
        case "05":
            dayString = "5"
        case "06":
            dayString = "6"
        case "07":
            dayString = "7"
        case "08":
            dayString = "8"
        case "09":
            dayString = "9"
        default:
            dayString = "\(day)"
        }
        return "\(monthString) \(dayString)"
        
    }
    
    override func loadView() {
        view = scrollView
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

}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
