//
//  AddPersonalDetailTableViewVC.swift
//  Bio
//
//  Created by Ann McDonough on 12/29/20.
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

class AddPersonalDetailTableViewVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, isAbleToReceiveData {
    
    
    var userDataVM: UserDataVM?
    //var userData: UserData?
    var myZodiac = ""
    var myBirthday = ""
    var myAgeLimit = 13
    var myCountry = ""
    var myCountries: [String] = []
    var myCity = ""
    var myPhoneNumber = ""
    var myRelationship = ""
    var GDPRCountries: [String] = ["Austria", "Belgium", "Bulgaria", "Croatia", "Cyprus", "Czech Republic", "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", "Hungary", "Ireland", "Italy", "Latvia", "Lithuania", "Luxembourg", "Malta", "Netherlands", "Poland", "Portugal", "Romania", "Slovakia", "Slovenia", "Spain", "Sweden"]
    
    var userCountry = ""
    var ogBirthday = ""
    var ogCity = ""
    var ogCountries: [String] = []
    var ogCountriesString = ""
    var ogPhoneNumber = ""
    var ogRelationship = ""
    
    var birthdayDoc = ""
    var cityDoc = ""
    var cultureDoc = ""
    var phoneDoc = ""
    var relationshipDoc = ""
    
    var userDataIdentityList: [String]?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    var relationshipStatusArray: [String] = ["", "Single", "In a relationship", "Engaged", "Married", "In a domestic partnership", "In a civil union", "In an open relationship", "It's complicated", "Separated", "Divorced", "Widowed"]
    var datePicker = UIDatePicker()
    var maxCountriesAllowed = 6
    var relationshipPickerView = UIPickerView()
    var navBarView = NavBarView()
    var titleLabel1 = UILabel()
    @IBOutlet weak var doneButton: UIButton!
    //var birthday = ""
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
    var cultureImage = UIImage(named: "unity")
    var phoneImage = UIImage(named: "smartphone")
    var relationshipImage = UIImage(named: "heart-1")
    
    var iconArray: [UIImage] = []
    
    
    var placeHolderTextArray: [String] = ["Birthday", "Current City", "Cultural Identity", "Phone Number", "Relationship Status"]
    
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
        relationshipPickerView.delegate = self
        relationshipPickerView.dataSource = self
        relationshipPickerView.tag = 2
        //   textFieldData = Array(repeating: "", count: socialMediaArray.count)
        cancelButton.isHidden = true
        doneButton.isHidden = true
        titleLabel1.isHidden = true
        
        view.backgroundColor = .systemGray6
        doneButton.titleLabel!.font = UIFont(name: "DINAlternate-Bold", size: 19)
        
        view.addSubview(tableView)
        
        setUpContinueButton()
        
        userDataIdentityList = userDataVM?.userData.value?.identityValues
        
        for identity in userDataIdentityList! {
            let chunks = identity.split(separator: ":")
            if chunks.count < 4 {
                continue
            }
            switch chunks[0] {
            case "pin_birthday":
                ogBirthday = String(chunks[2])
                birthdayDoc = String(chunks[3])
            case "pin_city":
                ogCity = String(chunks[1])
                cityDoc = String(chunks[3])
            case "pin_country":
                ogCountries.append(String(chunks[2]))
                cultureDoc = String(chunks[3])
            case "pin_relationship":
                ogRelationship = String(chunks[1])
                relationshipDoc = String(chunks[3])
            case "pin_phone":
                ogPhoneNumber = String(chunks[1])
                phoneDoc = String(chunks[3])
            default:
                print("bad chunk")
            }
        }
        myBirthday = ogBirthday
        myCountries = ogCountries
        myCity = ogCity
        myRelationship = ogRelationship
        myPhoneNumber = ogPhoneNumber
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
        let userData = userDataVM?.userData.value
        var success = true
        let myText = cellArray[0].interactiveTextField.text ?? ""
        var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        trimmedText = trimmedText.lowercased()
        //        print("This is trimmedText \(trimmedText)")
        let birthdayHex = HexagonStructData(resource: myText, type: "pin_birthday", location: userData!.numPosts + 1, thumbResource: "icons/AstrologicalSigns/\(myZodiac).png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myZodiac, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
        addHex(hexData: birthdayHex, completion: { bool in
            success = success && bool
            
        })
    }
    
    func updateBirthdayHex() {
        let userData = userDataVM?.userData.value
        let myText = cellArray[0].interactiveTextField.text ?? ""
        var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        trimmedText = trimmedText.lowercased()
        //        print("This is trimmedText \(trimmedText)")
        let birthdayHex = HexagonStructData(resource: myText, type: "pin_birthday", location: userData!.numPosts + 1, thumbResource: "icons/AstrologicalSigns/\(myZodiac).png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myZodiac, views: 0, isArchived: false, docID: birthdayDoc, coverText: "", isPrioritized: false, array: [])
        db.collection("Hexagons2").document(birthdayDoc).setData(birthdayHex.dictionary)

    }
    
    func addRelationshipHex() {
        let userData = userDataVM?.userData.value
        var success = true
        let myText = cellArray[4].interactiveTextField.text ?? ""
        var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        trimmedText = trimmedText.lowercased()
        //        print("This is trimmedText \(trimmedText)")
        let relationshipHex = HexagonStructData(resource: "\(userData!.displayName)", type: "pin_relationship", location: userData!.numPosts + 1, thumbResource: "icons/RelationshipSigns/\(trimmedText).png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
        addHex(hexData: relationshipHex, completion: { bool in
            success = success && bool
            
        })
    }
    
    func updateRelationshipHex() {
        let userData = userDataVM?.userData.value
        let myText = cellArray[4].interactiveTextField.text ?? ""
        var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        trimmedText = trimmedText.lowercased()
        //        print("This is trimmedText \(trimmedText)")
        let relationshipHex = HexagonStructData(resource: "\(userData!.displayName)", type: "pin_relationship", location: userData!.numPosts + 1, thumbResource: "icons/RelationshipSigns/\(trimmedText).png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: relationshipDoc, coverText: "", isPrioritized: false, array: [])
        db.collection("Hexagons2").document(relationshipDoc).setData(relationshipHex.dictionary)

        
    }
    
    func addCultureHex() {
        let userData = userDataVM?.userData.value
        var success = true
     //   var myText = cellArray[3].interactiveTextField.text ?? ""
      //  var myCountries = userData!.country
        var myText = myCountry
        if !myCountries.isEmpty {
            myText = myCountries[0]
        }
        var trimmedText = myText.replacingOccurrences(of: " ", with: "-")
      //  var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        trimmedText = trimmedText.lowercased()
        //        print("This is trimmedText \(trimmedText)")
        let cultureHex = HexagonStructData(resource: "\(userData!.displayName)", type: "pin_country", location: userData!.numPosts + 1, thumbResource: "icons/StateIcons/\(trimmedText).png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: myCountries)
        addHex(hexData: cultureHex, completion: { bool in
            success = success && bool
            
        })
    }
    
    func updateCultureHex() {
        let userData = userDataVM?.userData.value
        var myText = myCountry
        if !myCountries.isEmpty {
            myText = myCountries[0]
        }
        var trimmedText = myText.replacingOccurrences(of: " ", with: "-")
      //  var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        trimmedText = trimmedText.lowercased()
        //        print("This is trimmedText \(trimmedText)")
        let cultureHex = HexagonStructData(resource: "\(userData!.displayName)", type: "pin_country", location: userData!.numPosts + 1, thumbResource: "icons/StateIcons/\(trimmedText).png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: cultureDoc, coverText: "", isPrioritized: false, array: myCountries)
        db.collection("Hexagons2").document(cultureDoc).setData(cultureHex.dictionary)

        
    }
    
    func addPhoneHex() {
        let userData = userDataVM?.userData.value
        var success = true
        var myText = cellArray[3].interactiveTextField.text ?? ""
        var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        trimmedText = trimmedText.lowercased()
        //        print("This is trimmedText \(trimmedText)")
        let phoneHex = HexagonStructData(resource: "\(userData!.displayName)", type: "pin_phone", location: userData!.numPosts + 1, thumbResource: "icons/smartphone.png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
        addHex(hexData: phoneHex, completion: { bool in
            success = success && bool
            
        })
    }
    
    func updatePhoneHex() {
        let userData = userDataVM?.userData.value
        let myText = cellArray[3].interactiveTextField.text ?? ""
        var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        trimmedText = trimmedText.lowercased()
        //        print("This is trimmedText \(trimmedText)")
        let phoneHex = HexagonStructData(resource: "\(userData!.displayName)", type: "pin_phone", location: userData!.numPosts + 1, thumbResource: "icons/smartphone.png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: phoneDoc, coverText: "", isPrioritized: false, array: [])
        db.collection("Hexagons2").document(phoneDoc).setData(phoneHex.dictionary)

    }
    
    func addCityHex() {
        let userData = userDataVM?.userData.value
        var success = true
        let myText = cellArray[1].interactiveTextField.text ?? ""
        // var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        //  trimmedText = trimmedText.lowercased()
        //  print("This is trimmedText \(trimmedText)")
        let cityHex = HexagonStructData(resource: "\(userData!.displayName)", type: "pin_city", location: userData!.numPosts + 1, thumbResource: "icons/home.png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
        addHex(hexData: cityHex, completion: { bool in
            success = success && bool
            
        })
    }
    
    func updateCityHex() {
        let userData = userDataVM?.userData.value
        let myText = cellArray[1].interactiveTextField.text ?? ""
        let cityHex = HexagonStructData(resource: "\(userData!.displayName)", type: "pin_city", location: userData!.numPosts + 1, thumbResource: "icons/home.png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: cityDoc, coverText: "", isPrioritized: false, array: [])
        db.collection("Hexagons2").document(cityDoc).setData(cityHex.dictionary)
    }
    
    
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        self.myZodiac = getZodiacSign(birthdayDate!)
        //        print("This is my zodiac \(self.myZodiac)")
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        //        print("This is age: \(age)")
        return age!
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentUser = Auth.auth().currentUser
        userDataVM = UserDataVM(email: currentUser!.email!)
        //myCountry = (userDataVM?.userData.value!.country)!
    //    print("This is mycountry \(myCountry)")
        if GDPRCountries.contains(myCountry) {
            myAgeLimit = 16
        } else {
            myAgeLimit = 13
        }
        
        iconArray = [birthdayImage ?? UIImage(), houseImage ?? UIImage(), cultureImage ?? UIImage(), phoneImage ?? UIImage(), relationshipImage ?? UIImage()]
        // relationshipPickerView.isHidden = true
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
        
        
    }
    
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        cellArray[0].interactiveTextField.text = formatter.string(from: datePicker.date)
        var birthdaySubmitted = cellArray[0].interactiveTextField.text
        self.myBirthday = birthdaySubmitted!
        age = calcAge(birthday: birthdaySubmitted!)
        cellArray[0].socialMediaIcon.image = UIImage(named: self.myZodiac)
        self.view.endEditing(true)
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           var countrows = self.relationshipStatusArray.count
        return countrows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            let titleRow = relationshipStatusArray[row]
            return titleRow
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            cellArray[4].interactiveTextField.text = self.relationshipStatusArray[row]
    }
  
    
    func setUpContinueButton() {
        view.addSubview(continueButton)
        var buttonHeight = CGFloat(55)
        var buttonWidth = CGFloat(view.frame.width*(3/4))
        continueButton.frame = CGRect(x: (view.frame.width - buttonWidth)/2, y: view.frame.height - buttonHeight - buttonHeight, width: buttonWidth, height: buttonHeight)
        continueButton.layer.cornerRadius = continueButton.frame.width/40
        continueButton.backgroundColor = .systemBlue
        continueButton.titleLabel!.textColor = .white
        continueButton.setTitle("Create Post", for: .normal)
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
        let userData = userDataVM?.userData.value
        userData?.identityValues.removeAll(where: { instance in
            let chunks = instance.split(separator: ":")
            return chunks[0].contains(hexData.type)
        })
        userData?.identityValues.append("\(hexData.type):\(hexData.text):\(hexData.resource):\(hexDoc.documentID)")
        userDataVM?.updateUserData(newUserData: userData!, completion: {_ in})
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
    
    func formatCountryToImage(myCountry: String) -> String {
        var success = true
        
        var hyphenCountry = myCountry.replacingOccurrences(of: " ", with: "-") as! String
        hyphenCountry = hyphenCountry.lowercased()
        return hyphenCountry
    }
    
    func pass(data: String) {
        print("data: \(data)")
        cellArray[1].interactiveTextField.text = data
    }
    
    func passArray(dataArray: [String]) {
        myCountries = dataArray
        if !myCountries.isEmpty {
            let unformattedCountry = myCountries[0]
            var formattedCountry = formatCountryToImage(myCountry: unformattedCountry)
            formattedCountry = formattedCountry.lowercased()
            formattedCountry = formattedCountry.replacingOccurrences(of: " ", with: "-")
            print("formatted country: \(formattedCountry)")
            cellArray[2].socialMediaIcon.image = UIImage(named: formattedCountry) ?? UIImage(named: "unity")
        }
        
    }
    
    
    @objc func continueTapped(_ sender: UITapGestureRecognizer) {
        let userData = userDataVM?.userData.value
        if cellArray[0].interactiveTextField.text == ogBirthday && cellArray[1].interactiveTextField.text == ogCity && myCountries == ogCountries && cellArray[3].interactiveTextField.text == ogPhoneNumber && cellArray[4].interactiveTextField.text == ogRelationship {
            // print("Fill in all required fields")//
            let alert = UIAlertController(title: "Fill in a Field", message: "Fill in a field to create a post.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        print("a field is filled in. Now create hexagons")
        if cellArray[0].interactiveTextField.text != "" && age < myAgeLimit {
            //     print("You are too young. You must be \(myAgeLimit) years old")
            let alert = UIAlertController(title: "👶🏼", message: "You must be \(myAgeLimit) to join Bio.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //save birthday, current city, cultural identity, phonenumber, relationship status
        let myBirthday = cellArray[0].interactiveTextField.text
        let myCurrentCity = cellArray[1].interactiveTextField.text
        let myCulturalIdentity = myCountries
        let myPhoneNumber = cellArray[3].interactiveTextField.text ?? ""
        let myRelationship = cellArray[4].interactiveTextField.text ?? ""
        
        userData?.birthday = myBirthday ?? ""
        userData?.currentCity = myCurrentCity ?? ""
        userData?.phoneNumber = myPhoneNumber
        
        if myBirthday != "" && ogBirthday == ""{
            addBirthdayHex()
            userData?.numPosts += 1
        }
        else if myBirthday != "" && ogBirthday != "" {
            updateBirthdayHex()
        }
        
        let myCity = cellArray[1].interactiveTextField.text ?? ""
        if myCity.contains("United States") && ogCity == "" {
            addCityHex()
            userData?.numPosts += 1
        }
        else if myCity.contains("United States") && ogCity != "" {
            updateCityHex()
        }
            
  
        if !myCountries.isEmpty && ogCountries.isEmpty {
            addCultureHex()
            userData?.numPosts += 1
        }
        
        else if !myCountries.isEmpty && !ogCountries.isEmpty {
            updateCultureHex()
        }
        
        if cellArray[3].interactiveTextField.text != "" && ogPhoneNumber == "" {
            addPhoneHex()
            userData?.numPosts += 1
        }
        
        else if cellArray[3].interactiveTextField.text != "" && ogPhoneNumber != "" {
            updatePhoneHex()
        }
        
        if cellArray[4].interactiveTextField.text != "" && ogRelationship == "" {
            addRelationshipHex()
            userData?.numPosts += 1
        }
        
        else if cellArray[4].interactiveTextField.text != "" && ogRelationship != "" {
            updateRelationshipHex()
        }
        
        let loadingIndicator = storyboard?.instantiateViewController(withIdentifier: "loading")
        
        let blurEffectView: UIVisualEffectView = {
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.alpha = 0.8
            
            // Setting the autoresizing mask to flexible for
            // width and height will ensure the blurEffectView
            // is the same size as its parent view.
            blurEffectView.autoresizingMask = [
                .flexibleWidth, .flexibleHeight
            ]
            blurEffectView.frame = view.bounds
            
            return blurEffectView
        }()
        view.addSubview(blurEffectView)
        
        addChild(loadingIndicator!)
        view.addSubview(loadingIndicator!.view)
        
        userDataVM?.updateUserData(newUserData: userData!, completion: {_ in
            //segue to home screen
            self.performSegue(withIdentifier: "rewindToFront", sender: self)
            blurEffectView.removeFromSuperview()
            loadingIndicator!.view.removeFromSuperview()
            loadingIndicator!.removeFromParent()
        })
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
        citySearchVC.delegate = self
        citySearchVC.userDataVM = userDataVM
        citySearchVC.savedLocation = cellArray[1].interactiveTextField.text ?? ""
        print("citySearVC.savedLocation = \(citySearchVC.savedLocation)")
        citySearchVC.modalPresentationStyle = .fullScreen
        self.present(citySearchVC, animated: false, completion: nil)
    }
    

    
    @objc func cultureCell(_ sender: UITapGestureRecognizer) {
        print("I tapped culture cell")
        let cultureVC = storyboard?.instantiateViewController(withIdentifier: "culturalIdentityVC") as! CulturalIdentityVC
        cultureVC.delegate = self
        cultureVC.userDataVM = userDataVM
        cultureVC.userCountries = myCountries
        cultureVC.modalPresentationStyle = .fullScreen
        self.present(cultureVC, animated: false, completion: nil)
    }
    
    
    
    @objc func phoneCellTap(_ sender: UITapGestureRecognizer) {
        print("I tapped phone cell")
        cellArray[3].interactiveTextField.becomeFirstResponder()
    }
    
    
    @objc func relationshipCellTap(_ sender: UITapGestureRecognizer) {
        cellArray[4].interactiveTextField.becomeFirstResponder()
    }
    
    
    
    func setUpNavBarView() {
        var statusBarHeight = UIApplication.shared.statusBarFrame.height
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(backButton)
        self.navBarView.addSubview(postButton)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        
        var navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
        var backButtonWidth = CGFloat(30)
        self.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - backButtonWidth)/2, width: backButtonWidth, height: backButtonWidth)
        
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonpressed))
        backTap.numberOfTapsRequired = 1
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(backTap)
        backButton.setImage(UIImage(named: "blackChevron"), for: .normal)
        
        

        postButton.setTitle("Next", for: .normal)
        postButton.setTitleColor(.systemBlue, for: .normal)
        postButton.isHidden = true
        postButton.titleLabel?.sizeToFit()
        postButton.titleLabel?.textAlignment = .right
        
        
        
        postButton.frame = CGRect(x: navBarView.frame.width - 50, y: statusBarHeight + (navBarHeightRemaining - 34)/2, width: 40, height: 34)
        navBarView.postButton.titleLabel?.textAlignment = .right
        let yOffset = navBarView.frame.maxY
        
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Add Your Cultural Identities"
        
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 140, y: postButton.frame.minY, width: 280, height: 25)
        navBarView.backgroundColor = .white
        navBarView.titleLabel.textColor = .black
        
    }
    
    
    var textFieldData = [String]()

    
    
    
}


extension AddPersonalDetailTableViewVC: UITableViewDelegate, UITableViewDataSource {
    
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
        
        return tableView.frame.height/5
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalDetailCell", for: indexPath) as! PersonalDetailCell
        cell.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/8)
        cell.backgroundColor = .systemGray6
        var myGray = cell.backgroundColor
        cell.layer.borderColor = myGray?.cgColor
        cell.layer.borderWidth = 10

        cell.socialMediaIcon.layer.cornerRadius = cell.socialMediaIcon.frame.size.width / 2
        cell.socialMediaIcon.clipsToBounds = true
        cell.socialMediaIcon.layer.borderWidth = 1.0
        cell.socialMediaIcon.layer.borderColor = white.cgColor
        cell.interactiveTextField.isUserInteractionEnabled = true
        cell.interactiveTextField.textColor = .black
        
        
        cell.interactiveTextField.attributedPlaceholder = NSAttributedString(string: "Cultural Identity",
                                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        cell.socialMediaIcon.image = iconArray[indexPath.row]
        
        
        cell.circularMask.frame = cell.socialMediaIcon.frame
        cell.interactiveTextField.textColor = .black

        
        cell.interactiveTextField.tag = indexPath.row
        
        

        
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
            
            cell.interactiveTextField.text = ogBirthday
            
        }
        
        // do current city stuff
        else if indexPath.row == 1 {
            //send to chooseCityVC
            cell.interactiveTextField.isUserInteractionEnabled = false
            let cellTap = UITapGestureRecognizer(target: self, action: #selector(cityCellTap))
            cell.addGestureRecognizer(cellTap)
            cell.interactiveTextField.text = myCity
        }
        

        
        // do cultural  stuff
        else if indexPath.row == 2 {
            cell.interactiveTextField.isUserInteractionEnabled = false
            let cellTap = UITapGestureRecognizer(target: self, action: #selector(cultureCell))
            cell.addGestureRecognizer(cellTap)
            var countryString = ""
            var index = 0
            for country in myCountries {
                if index != myCountries.count - 1 {
                    countryString.append("\(country), ")
                }
                else {
                    countryString.append(country)
                }
                index += 1
            }
            print("This is myCountries \(myCountries)")
        }
        // do phone stuff
        else if indexPath.row == 3 {
            //type in phoneNumber
            cell.interactiveTextField.keyboardType = UIKeyboardType.numberPad
            let cellTap = UITapGestureRecognizer(target: self, action: #selector(phoneCellTap))
            cell.addGestureRecognizer(cellTap)
            cell.interactiveTextField.text = myPhoneNumber
        }
        
        //do relationship
        else if indexPath.row == 4 {
            //show relationshipPicker
            let cellTap = UITapGestureRecognizer(target: self, action: #selector(relationshipCellTap))
            cell.addGestureRecognizer(cellTap)
            cell.interactiveTextField.inputView = relationshipPickerView
            cell.interactiveTextField.text = myRelationship
            
        }
        
        
        cell.xButton.isHidden = true
        cell.interactiveTextField.attributedPlaceholder = NSAttributedString(string: placeHolderTextArray[indexPath.row],
                                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        cellArray.append(cell)
        
        return cell
    }
}

