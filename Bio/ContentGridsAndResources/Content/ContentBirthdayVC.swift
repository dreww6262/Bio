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
   // var captionTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
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
        print("This is age: \(age)")
        return age!
    }
    
    func setUpCaption() {
        var birthdayLabel = UILabel()
        var ageLabel = UILabel()
        var zodiacLabel = UILabel()
        scrollView.addSubview(birthdayLabel)
        scrollView.addSubview(ageLabel)
        scrollView.addSubview(zodiacLabel)
        var formattedBirthday = formatBirthday(date: birthdayHex!.resource)
        var birthdayText = "Birthday: \(formattedBirthday)"
        var zodiacLowerCased = "\(birthdayHex!.text)"
        var zodiac = zodiacLowerCased.capitalizingFirstLetter()
        var zodiacText = "Zodiac: \(zodiac)"
        
        birthdayLabel.text = birthdayText
        var theAge = calcAge(birthday: birthdayHex!.resource)
        ageLabel.text = "Age: \(theAge) years old"
        zodiacLabel.text = zodiacText
        let captionFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 66)
        birthdayLabel.font = UIFont(name: "DINAlternate-Bold", size: 28)
        zodiacLabel.font = UIFont(name: "DINAlternate-Bold", size: 28)
        ageLabel.font = UIFont(name: "DINAlternate-Bold", size: 28)
        let frame = CGRect(x: view.frame.width/3, y: view.frame.height/12, width: view.frame.width/3, height: view.frame.width/3)
        let birthdayFrame = CGRect(x: 0, y: (newImageView?.frame.maxY)! + 20, width: view.frame.width, height: 30)
        let ageFrame = CGRect(x: 0, y: birthdayFrame.maxY + 20, width: view.frame.width, height: 30)
        let zodiacFrame = CGRect(x: 0, y: ageFrame.maxY + 20, width: view.frame.width, height: 30)
        birthdayLabel.frame = birthdayFrame
        ageLabel.frame = ageFrame
        zodiacLabel.frame = zodiacFrame
        birthdayLabel.textColor = .white
        ageLabel.textColor = .white
        zodiacLabel.textColor = .white
        birthdayLabel.textAlignment = .center
        ageLabel.textAlignment = .center
        zodiacLabel.textAlignment = .center
        
        
        
        birthdayLabel.textAlignment = .center
        birthdayLabel.isUserInteractionEnabled = false
        print("This is caption text \(birthdayText)")
        print("This is text field text \(birthdayLabel.text)")
        birthdayLabel.textColor = .white
     //   birthdayLabel.frame = captionFrame
    //    captionTextField.size
        
        print()
    }
    
    func formatBirthday(date: String) -> String {
        print("This is date \(date)")
        var dateArray = date.components(separatedBy: "/")
        var month = dateArray[0]
        var day = dateArray[1]
        var year = dateArray[2]
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

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
