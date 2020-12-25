//
//  PersonalDetailTableViewVC.swift
//  Bio
//
//  Created by Ann McDonough on 12/15/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SDWebImage
import FirebaseUI
import FirebaseStorage
import YPImagePicker

class PersonalDetailTableViewVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var userDataVM: UserDataVM?
    var userData: UserData?
    var myZodiac = ""
    var myBirthday = ""
    var myAgeLimit = 13
    var myCountry = ""
    var GDPRCountries: [String] = ["Austria", "Belgium", "Bulgaria", "Croatia", "Cyprus", "Czech Republic", "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", "Hungary", "Ireland", "Italy", "Latvia", "Lithuania", "Luxembourg", "Malta", "Netherlands", "Poland", "Portugal", "Romania", "Slovakia", "Slovenia", "Spain", "Sweden"]
    var loadingIndicator: UIViewController?
    var blurEffectView: UIVisualEffectView?
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    var genderArray: [String] = ["", "I am a man", "I am a woman", "Custom"]
    var relationshipStatusArray: [String] = ["", "Single", "In a relationship", "Engaged", "Married", "In a domestic partnership", "In a civil union", "In an open relationship", "It's complicated", "Separated", "Divorced", "Widowed"]
    var datePicker = UIDatePicker()
    var maxCountriesAllowed = 6
    var genderPickerView = UIPickerView()
    var relationshipPickerView = UIPickerView()
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    @IBOutlet weak var doneButton: UIButton!
    var birthday = ""
    var age = 0
    var cellArray: [PersonalDetailCell] = []
    
    var backButton = UIButton()
    var postButton = UIButton()
    var continueButton = UIButton()
    var indexPaths: [IndexPath] = []
    var txtDatePicker = UITextField()
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    var currentUser: User?
    var loadUserDataArray = ThreadSafeArray<UserData>()
    var searchString: String = ""
//    var textFieldArray = [UITextField]()
    
    var followList = [String]()
    var followListener: ListenerRegistration?
    
    var cancelLbl: String?
    

    

    var image1 = UIImage(named: "unity")
    var birthdayImage = UIImage(named: "birthday")
    var houseImage = UIImage(named: "homeCircle")
    var genderImage = UIImage(named: "genderCircle")
    var cultureImage = UIImage(named: "unity")
    var phoneImage = UIImage(named: "smartphone")
    var relationshipImage = UIImage(named: "heart-1")

    var iconArray: [UIImage] = []


    var placeHolderTextArray: [String] = ["Birthday (Required)", "Current City (Required)", "Gender (Required)", "Cultural Identity", "Phone Number", "Relationship Status"]

    override func viewDidLoad() {
    super.viewDidLoad()
        setUpNavBarView()
        tableView.delegate = self
        tableView.dataSource = self
        var numRows = CGFloat(6.0)
        var rowHeight = CGFloat(90)
        var tableViewHeight = CGFloat(numRows*rowHeight)
        tableView.frame = CGRect(x: 0, y: navBarView.frame.height, width: view.frame.width, height: tableViewHeight)
        tableView.reloadData()
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        relationshipPickerView.delegate = self
        relationshipPickerView.dataSource = self
        genderPickerView.tag = 1
        relationshipPickerView.tag = 2
     //   textFieldData = Array(repeating: "", count: socialMediaArray.count)
        cancelButton.isHidden = true
        doneButton.isHidden = true
        titleLabel1.isHidden = true
        view.addSubview(genderPickerView)
       genderPickerView.frame = CGRect(x: 0, y: view.frame.height - 300, width: view.frame.width, height: 300)
        view.addSubview(relationshipPickerView)
       relationshipPickerView.frame = CGRect(x: 0, y: view.frame.height - 300, width: view.frame.width, height: 300)
        
        view.backgroundColor = .systemGray6
        doneButton.titleLabel!.font = UIFont(name: "DINAlternate-Bold", size: 19)
    
        view.addSubview(tableView)
//        textField.isUserInteractionEnabled = false
//        interactiveTextField.isUserInteractionEnabled = true
//
     

   
       // showDatePicker()
       // showDatePicker()
   setUpContinueButton()
    }
    
    func getZodiacSign(_ date:Date) -> String{

        let calendar = Calendar.current
        let d = calendar.component(.day, from: date)
        let m = calendar.component(.month, from: date)

        switch (d,m) {
        case (21...31,1),(1...19,2):
            return "aquarius"
        case (20...29,2),(1...20,3):
            return "pisces"
        case (21...31,3),(1...20,4):
            return "aries"
        case (21...30,4),(1...21,5):
            return "taurus"
        case (22...31,5),(1...21,6):
            return "gemini"
        case (22...30,6),(1...22,7):
            return "cancer"
        case (23...31,7),(1...22,8):
            return "leo"
        case (23...31,8),(1...23,9):
            return "virgo"
        case (24...30,9),(1...23,10):
            return "libra"
        case (24...31,10),(1...22,11):
            return "scorpio"
        case (23...30,11),(1...21,12):
            return "sagittarius"
        default:
            return "capricorn"
        }

    }
    
    func addBirthdayHex() {
    //    userDataVM?.userData.listener
        var success = true
        var myText = cellArray[0].interactiveTextField.text ?? ""
        var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        trimmedText = trimmedText.lowercased()
        print("This is trimmedText \(trimmedText)")
        let birthdayHex = HexagonStructData(resource: "\(userData!.publicID)Birthday", type: "pin_birthday", location: userData!.numPosts + 1, thumbResource: "icons/AstrologicalSigns/\(myZodiac).png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myZodiac, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
        addHex(hexData: birthdayHex, completion: { bool in
            success = success && bool
            
        })
    }
    
    func addRelationshipHex() {
    //    userDataVM?.userData.listener
        var success = true
        var myText = cellArray[5].interactiveTextField.text ?? ""
        var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        trimmedText = trimmedText.lowercased()
        print("This is trimmedText \(trimmedText)")
        let relationshipHex = HexagonStructData(resource: "\(userData!.publicID)Relationship", type: "pin_relationship", location: userData!.numPosts + 1, thumbResource: "icons/Relationships/\(trimmedText).png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
        addHex(hexData: relationshipHex, completion: { bool in
            success = success && bool
            
        })
    }
    
    func addCultureHex() {
    //    userDataVM?.userData.listener
        var success = true
        var myText = cellArray[3].interactiveTextField.text ?? ""
        var myCountries = userData!.country
        var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        trimmedText = trimmedText.lowercased()
        print("This is trimmedText \(trimmedText)")
        let cultureHex = HexagonStructData(resource: "\(userData!.publicID)Culture", type: "pin_country", location: userData!.numPosts + 1, thumbResource: "icons/Flags/\(trimmedText).png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
        addHex(hexData: cultureHex, completion: { bool in
            success = success && bool
            
        })
    }
    
    func addPhoneHex() {
    //    userDataVM?.userData.listener
        var success = true
        var myText = cellArray[4].interactiveTextField.text ?? ""
        var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        trimmedText = trimmedText.lowercased()
        print("This is trimmedText \(trimmedText)")
        let phoneHex = HexagonStructData(resource: "\(userData!.publicID)Phone", type: "pin_phone", location: userData!.numPosts + 1, thumbResource: "icons/smartphone.png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
        addHex(hexData: phoneHex, completion: { bool in
            success = success && bool
            
        })
    }
    
    func addCityHex() {
    //    userDataVM?.userData.listener
        var success = true
        var myText = cellArray[1].interactiveTextField.text ?? ""
       // var trimmedText = myText.trimmingCharacters(in: .whitespaces)
      //  trimmedText = trimmedText.lowercased()
      //  print("This is trimmedText \(trimmedText)")
        let cityHex = HexagonStructData(resource: "\(userData!.publicID)City", type: "pin_city", location: userData!.numPosts + 1, thumbResource: "icons/smartphone.png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
        addHex(hexData: cityHex, completion: { bool in
            success = success && bool
            
        })
    }
    
    
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        self.myZodiac = getZodiacSign(birthdayDate!)
        print("This is my zodiac \(self.myZodiac)")
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        print("This is age: \(age)")
        return age!
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         loadingIndicator = storyboard?.instantiateViewController(withIdentifier: "loading")
        currentUser = Auth.auth().currentUser
        if GDPRCountries.contains(myCountry) {
            myAgeLimit = 16
        } else {
            myAgeLimit = 13
        }
        
         iconArray = [birthdayImage ?? UIImage(), houseImage ?? UIImage(), genderImage ?? UIImage(), cultureImage ?? UIImage(), phoneImage ?? UIImage(), relationshipImage ?? UIImage()]
      //  genderPickerView.isHidden = true
       // relationshipPickerView.isHidden = true
        genderPickerView.endEditing(true)
        relationshipPickerView.endEditing(true)
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date

       //ToolBar
       let toolbar = UIToolbar();
       toolbar.sizeToFit()
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

     toolbar.setItems([spaceButton,doneButton], animated: false)

  //      cellArray[0].interactiveTextField.inputAccessoryView = toolbar
   //     cellArray[0].interactiveTextField.inputView = datePicker

     }
    
    
    @objc func cancelDatePicker(){
       self.view.endEditing(true)
     }
    @objc func donedatePicker(){

     let formatter = DateFormatter()
     formatter.dateFormat = "MM/dd/yyyy"
        cellArray[0].interactiveTextField.text = formatter.string(from: datePicker.date)
        var birthdaySubmitted = cellArray[0].interactiveTextField.text
      self.birthday = birthdaySubmitted!
    age = calcAge(birthday: birthdaySubmitted!)
        cellArray[0].socialMediaIcon.image = UIImage(named: self.myZodiac)
     self.view.endEditing(true)
   }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            var countrows : Int = genderArray.count
            if pickerView == relationshipPickerView {
                countrows = self.relationshipStatusArray.count
            }

            return countrows
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView == genderPickerView {
                let titleRow = genderArray[row]
                 return titleRow
            } else if pickerView == relationshipPickerView {
                let titleRow = relationshipStatusArray[row]
                return titleRow
            }

            return ""
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if pickerView == genderPickerView {
                cellArray[2].interactiveTextField.text = self.genderArray[row]
            } else if pickerView == relationshipPickerView {
                cellArray[5].interactiveTextField.text = self.relationshipStatusArray[row]
            }
        }

//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView.tag == 1 {
//            return genderArray.count
//        } else {
//            return relationshipStatusArray.count
//        }
//    }
//
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
//        if pickerView.tag == 1 {
//            return "\(genderArray[row])"
//        } else {
//            return "\(relationshipStatusArray[row])"
//        }
//    }
//
//
    
    func setUpContinueButton() {
        view.addSubview(continueButton)
        var buttonHeight = CGFloat(55)
        var buttonWidth = CGFloat(view.frame.width*(3/4))
        continueButton.frame = CGRect(x: (view.frame.width - buttonWidth)/2, y: view.frame.height - buttonHeight - buttonHeight, width: buttonWidth, height: buttonHeight)
        continueButton.layer.cornerRadius = continueButton.frame.width/40
        continueButton.backgroundColor = .systemBlue
        continueButton.titleLabel!.textColor = .white
        continueButton.setTitle("Save", for: .normal)
        continueButton.titleLabel!.font = UIFont(name: "DINAlternate-Bold", size: 20)
        let continueTap = UITapGestureRecognizer(target: self, action: #selector(continueTapped))
        continueButton.addGestureRecognizer(continueTap)
        //continueButt
    }

    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        print("hit cancel button")
        // hide keyboard when pressed cancel
        self.view.endEditing(true)
        if (cancelButton.titleLabel?.text == "Skip") {
            performSegue(withIdentifier: "rewindToFront", sender: nil)
        }
        else {
            print("should dismiss vc")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func addHex(hexData: HexagonStructData, completion: @escaping (Bool) -> Void) {
        let hexCollectionRef = db.collection("Hexagons2")
        let hexDoc = hexCollectionRef.document()
        var hexCopy = HexagonStructData(dictionary: hexData.dictionary)
        hexCopy.docID = hexDoc.documentID
        hexDoc.setData(hexCopy.dictionary){ error in
            if error == nil {
                completion(true)
            }
            else {
                completion(false)
            }
        }
        
    }
    
    
    @objc func continueTapped(_ sender: UITapGestureRecognizer) {
     //    age = calcAge(birthday: myBirthday)
        if cellArray[0].interactiveTextField.text == "" || cellArray[1].interactiveTextField.text == "" || cellArray[2].interactiveTextField.text == "" {
           // print("Fill in all required fields")//
            let alert = UIAlertController(title: "👶🏼", message: "Fill in all required fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        print("All required fields are filled in. Now create hexagons")
        if age < myAgeLimit {
       //     print("You are too young. You must be \(myAgeLimit) years old")
            let alert = UIAlertController(title: "👶🏼", message: "You must be \(myAgeLimit) to join Bio.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        addBirthdayHex()
        userData?.numPosts += 1
        addCityHex()
        userData?.numPosts += 1
        
        if cellArray[3].interactiveTextField.text != "" {
            addCultureHex()
            userData?.numPosts += 1
        }
        
        if cellArray[4].interactiveTextField.text != "" {
            addPhoneHex()
            userData?.numPosts += 1
        }
        
        if cellArray[5].interactiveTextField.text != "" {
            addRelationshipHex()
            userData?.numPosts += 1
        }
        
        //segue to home screen
        self.performSegue(withIdentifier: "signUpSegue2", sender: self)
    self.blurEffectView?.removeFromSuperview()
    loadingIndicator!.view.removeFromSuperview()
    loadingIndicator!.removeFromParent()
        
     }
    
    @objc func backTapped(_ sender: UITapGestureRecognizer) {
        print("back hit!")
        for v in view.subviews {
            v.isHidden = true
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func backButtonpressed() {
        print("It should dismiss here")
        self.dismiss(animated: true)
     }
    
    @objc func birthdayCellTap(_ sender: UITapGestureRecognizer) {
       print("I tapped birthday cell")
       // pickerView.tag = 1
        cellArray[0].interactiveTextField.becomeFirstResponder()
    }
    @objc func cityCellTap(_ sender: UITapGestureRecognizer) {
       print("I tapped city cell")
        let citySearchVC = storyboard?.instantiateViewController(withIdentifier: "locationViewController") as! LocationViewController
        citySearchVC.userDataVM = userDataVM
        citySearchVC.modalPresentationStyle = .fullScreen
        self.present(citySearchVC, animated: false, completion: nil)
    }
    
    @objc func genderCellTap(_ sender: UITapGestureRecognizer) {
       print("I tapped gender cell")
      //  pickerView.tag = 1
        cellArray[2].interactiveTextField.becomeFirstResponder()
    }
    
    @objc func cultureCell(_ sender: UITapGestureRecognizer) {
       print("I tapped culture cell")
        let cultureVC = storyboard?.instantiateViewController(withIdentifier: "culturalIdentityVC") as! CulturalIdentityVC
        cultureVC.userDataVM = userDataVM
        cultureVC.modalPresentationStyle = .fullScreen
        self.present(cultureVC, animated: false, completion: nil)
    }
    
    
    
    @objc func phoneCellTap(_ sender: UITapGestureRecognizer) {
       print("I tapped phone cell")
        cellArray[4].interactiveTextField.becomeFirstResponder()
    }
    
    
    @objc func relationshipCellTap(_ sender: UITapGestureRecognizer) {
       print("I tapped relationship cell")
       // pickerView.tag = 0
        cellArray[5].interactiveTextField.becomeFirstResponder()
    }
    
    
    
    func formatCountryToImage(myCountry: String) -> String {
        var success = true

        var hyphenCountry = myCountry.replacingOccurrences(of: " ", with: "-") as! String
        hyphenCountry = hyphenCountry.lowercased()
        print("This is hypehenCountry \(hyphenCountry)")
        print("should be a country hex!")
        var countryString = "icons/Flags/\(hyphenCountry).png"
  return countryString
    }
    
    
    func setUpNavBarView() {
        var statusBarHeight = UIApplication.shared.statusBarFrame.height
        print("This is status bar height \(statusBarHeight)")
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(backButton)
        self.navBarView.addSubview(postButton)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
       
        var navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
//        self.navBarView.addSubview(toSettingsButton)
//        self.navBarView.addSubview(toSearchButton)
        var backButtonWidth = CGFloat(30)
        self.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - backButtonWidth)/2, width: backButtonWidth, height: backButtonWidth)
        

            let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
            backTap.numberOfTapsRequired = 1
            backButton.isUserInteractionEnabled = true
            backButton.addGestureRecognizer(backTap)
            backButton.setImage(UIImage(named: "blackChevron"), for: .normal)
        
        
  //      let postTap = UITapGestureRecognizer(target: self, action: #selector(self.postTapped))
//        postTap.numberOfTapsRequired = 1
//        postButton.isUserInteractionEnabled = true
//        postButton.addGestureRecognizer(postTap)
        postButton.setTitle("Next", for: .normal)
        postButton.setTitleColor(.systemBlue, for: .normal)
        postButton.isHidden = true
      //  postButton.frame = CGRect(x: (self.view.frame.width) - (topBar.frame.height) - 5, y: 0, width: topBar.frame.height, height: topBar.frame.height)
        postButton.titleLabel?.sizeToFit()
        postButton.titleLabel?.textAlignment = .right
        
    
   //     self.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        
      //  backButton.sizeToFit()
        postButton.frame = CGRect(x: navBarView.frame.width - 50, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 40, height: 34)
        //navBarView.postButton.titleLabel?.sizeToFit()
        navBarView.postButton.titleLabel?.textAlignment = .right
        let yOffset = navBarView.frame.maxY
  
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Add Your Cultural Identities"
        
       // self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 140, y: postButton.frame.minY, width: 280, height: 25)
        navBarView.backgroundColor = .white
        navBarView.titleLabel.textColor = .black
      
    }
    
    
    var textFieldData = [String]()
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        textFieldData[textField.tag] = textField.text!
//    }
    
    
   

}


extension PersonalDetailTableViewVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return placeHolderTextArray.count
    }
    
    // cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     //   print("This is height for row at: \(self.view.frame.height/8)")
    //    return self.view.frame.height/8
   // return 66
        return 90
    }
    

  
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        print("This is number cell tapped \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalDetailCell", for: indexPath) as! PersonalDetailCell
        //birthday cell tapped
        
        //this is the add country Cell
     
        
        
        if indexPath.row == 0 {
          
        }
        
        //current city cell tapped
        if indexPath.row == 1 {
            
        }
        //gender cell tapped
        if indexPath.row == 2 {
            
        }
        //cultural identity cell tapped
        if indexPath.row == 3 {

            
        }
        //phone number cell tapped
        if indexPath.row == 4 {
            
        }
        //relationship cell tapped
        if indexPath.row == 5 {
            
        }
        
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalDetailCell", for: indexPath) as! PersonalDetailCell
        cell.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/8)
        cell.backgroundColor = .systemGray6
        var myGray = cell.backgroundColor
        cell.layer.borderColor = myGray?.cgColor
        cell.layer.borderWidth = 10
       // let cellTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
       // cell.addGestureRecognizer(cellTappedRecognizer)
        //  Configure the cell...
        //cell.socialMediaIcon.image = UIImage(named: "unity")
        cell.socialMediaIcon.layer.cornerRadius = cell.socialMediaIcon.frame.size.width / 2
        cell.socialMediaIcon.clipsToBounds = true
        cell.socialMediaIcon.layer.borderWidth = 1.0
        cell.socialMediaIcon.layer.borderColor = white.cgColor
        cell.interactiveTextField.isUserInteractionEnabled = true
        cell.interactiveTextField.textColor = .black
        
   
        cell.interactiveTextField.attributedPlaceholder = NSAttributedString(string: "Cultural Identity",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
       // cell.interactiveTextField.text = placeHolderTextArray[indexPath.row] ?? "Add Personal Details"
        cell.socialMediaIcon.image = iconArray[indexPath.row] ?? UIImage(named: "unity")
    
            
        cell.circularMask.frame = cell.socialMediaIcon.frame
        cell.interactiveTextField.textColor = .black
       // cell.interactiveTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        cell.interactiveTextField.tag = indexPath.row
//        if (textFieldData.count > indexPath.row) {
//            cell.interactiveTextField.text = textFieldData[indexPath.row]
//        }
        
    //do birthday stuff
        if indexPath.row == 0 {
            //show datePicker
            datePicker.datePickerMode = .date

           //ToolBar
           let toolbar = UIToolbar();
           toolbar.sizeToFit()
           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
          let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

         toolbar.setItems([spaceButton,doneButton], animated: false)
            let cellTap = UITapGestureRecognizer(target: self, action: #selector(birthdayCellTap))
                cell.addGestureRecognizer(cellTap)

           cell.interactiveTextField.inputAccessoryView = toolbar
            cell.interactiveTextField.inputView = datePicker
        }
        
        // do current city stuff
        else if indexPath.row == 1 {
            //send to chooseCityVC
            cell.interactiveTextField.isUserInteractionEnabled = false
            let cellTap = UITapGestureRecognizer(target: self, action: #selector(cityCellTap))
                cell.addGestureRecognizer(cellTap)
        }
        
        //do gender stuff
           else if indexPath.row == 2 {
             //show gender picker
            cell.interactiveTextField.inputView = genderPickerView
            let cellTap = UITapGestureRecognizer(target: self, action: #selector(genderCellTap))
                cell.addGestureRecognizer(cellTap)
            
            }
            
            // do cultural  stuff
           else if indexPath.row == 3 {
            cell.interactiveTextField.isUserInteractionEnabled = false
            let cellTap = UITapGestureRecognizer(target: self, action: #selector(cultureCell))
                cell.addGestureRecognizer(cellTap)
            }
        // do phone stuff
       else if indexPath.row == 4 {
            //type in phoneNumber
        cell.interactiveTextField.keyboardType = UIKeyboardType.numberPad
        let cellTap = UITapGestureRecognizer(target: self, action: #selector(phoneCellTap))
            cell.addGestureRecognizer(cellTap)
    
        }
        
        //do relationship
           else if indexPath.row == 5 {
                //show relationshipPicker
            let cellTap = UITapGestureRecognizer(target: self, action: #selector(relationshipCellTap))
                cell.addGestureRecognizer(cellTap)
            cell.interactiveTextField.inputView = relationshipPickerView
            }
            
          
        
    
        
            cell.xButton.isHidden = true
        cell.interactiveTextField.attributedPlaceholder = NSAttributedString(string: placeHolderTextArray[indexPath.row],
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        
        

       // cell.frame = cell.frame.offsetBy(dx: 10, dy: 10)
      //  cell.socialMediaIcon.image = UIImage(named: "united-states")
        cellArray.append(cell)
        
        return cell
    }
}

