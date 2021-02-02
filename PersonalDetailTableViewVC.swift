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

class PersonalDetailTableViewVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, isAbleToReceiveData {
    let stateCodes = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    let fullStateNames = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
    
    var userDataVM: UserDataVM?
    //var userData: UserData?
    var myZodiac = ""
    var myBirthday = ""
    var myAgeLimit = 13
    var myCountry = ""
    var myCountries: [String] = []
    var GDPRCountries: [String] = ["Austria", "Belgium", "Bulgaria", "Croatia", "Cyprus", "Czech Republic", "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", "Hungary", "Ireland", "Italy", "Latvia", "Lithuania", "Luxembourg", "Malta", "Netherlands", "Poland", "Portugal", "Romania", "Slovakia", "Slovenia", "Spain", "Sweden"]
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
    
    var comingFromHome = false
    
    var placeHolderTextArray: [String] = ["Birthday (Required)", "Current City (Required)", "Gender (Required)", "Ethnicities", "Phone Number", "Relationship Status"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBarView()
        tableView.delegate = self
        tableView.dataSource = self
        let numRows = CGFloat(6.0)
        let rowHeight = CGFloat(90)
        let tableViewHeight = CGFloat(numRows*rowHeight)
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
        
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
        doneButton.titleLabel!.font = UIFont(name: "DINAlternate-Bold", size: 19)
        
        view.addSubview(tableView)
        
        setUpContinueButton()
        
        if comingFromHome {
            backButton.isHidden = true
        }
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
    
    func addRelationshipHex() {
        let userData = userDataVM?.userData.value
        var success = true
        let myText = cellArray[5].interactiveTextField.text ?? ""
        var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        trimmedText = trimmedText.lowercased()
        //        print("This is trimmedText \(trimmedText)")
        let relationshipHex = HexagonStructData(resource: "\(userData!.displayName)", type: "pin_relationship", location: userData!.numPosts + 1, thumbResource: "icons/RelationshipSigns/\(trimmedText).png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
        addHex(hexData: relationshipHex, completion: { bool in
            success = success && bool
            
        })
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
        let cultureHex = HexagonStructData(resource: "\(userData!.displayName)", type: "pin_country", location: userData!.numPosts + 1, thumbResource: "icons/flags/\(trimmedText).png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: myCountries)
        addHex(hexData: cultureHex, completion: { bool in
            success = success && bool
            
        })
    }
    
    func addPhoneHex() {
        let userData = userDataVM?.userData.value
        var success = true
        let myText = cellArray[4].interactiveTextField.text ?? ""
        var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        trimmedText = trimmedText.lowercased()
        //        print("This is trimmedText \(trimmedText)")
        let phoneHex = HexagonStructData(resource: "\(userData!.displayName)", type: "pin_phone", location: userData!.numPosts + 1, thumbResource: "icons/smartphone.png", createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
        addHex(hexData: phoneHex, completion: { bool in
            success = success && bool
            
        })
    }
    
    func addCityHex() {
        let userData = userDataVM?.userData.value
        var success = true
        let myText = cellArray[1].interactiveTextField.text ?? ""
        var stateCode = ""
        var state = ""
        var stateImage = ""
        for shortState in stateCodes {
            if myText.contains(shortState) {
                print("This is the state code: \(shortState)")
                stateCode = shortState
               state = longStateName(stateCode)
            state = state.lowercased()
                print("This is state \(state)")
                stateImage = "\(state)_flag-png-square-large.png"
                cellArray[1].socialMediaIcon.image = UIImage(named: stateImage)
            }
        }
        
        // var trimmedText = myText.trimmingCharacters(in: .whitespaces)
        //  trimmedText = trimmedText.lowercased()
        //  print("This is trimmedText \(trimmedText)")
        let cityHex = HexagonStructData(resource: "\(userData!.displayName)", type: "pin_city", location: userData!.numPosts + 1, thumbResource: stateImage, createdAt: NSDate.now.description, postingUserID: userData!.publicID, text: myText, views: 0, isArchived: false, docID: "WillBeSetLater", coverText: "", isPrioritized: false, array: [])
        addHex(hexData: cityHex, completion: { bool in
            success = success && bool
            
        })
    }
    


    func shortStateName(_ state:String) -> String {
        let lowercaseNames = fullStateNames.map { $0.lowercased() }
        let dic = NSDictionary(objects: stateCodes, forKeys: lowercaseNames as [NSCopying])
        return dic.object(forKey:state.lowercased()) as? String ?? state}

    func longStateName(_ stateCode:String) -> String {
        let dic = NSDictionary(objects: fullStateNames, forKeys:stateCodes as [NSCopying])
        return dic.object(forKey:stateCode) as? String ?? stateCode
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
        datePicker.preferredDatePickerStyle = .wheels
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        
    }
    
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        cellArray[0].interactiveTextField.text = formatter.string(from: datePicker.date)
        let birthdaySubmitted = cellArray[0].interactiveTextField.text
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
  
    
    func setUpContinueButton() {
        view.addSubview(continueButton)
        let buttonHeight = CGFloat(55)
        let buttonWidth = CGFloat(view.frame.width*(3/4))
        let heightToBottom = CGFloat(view.frame.height - tableView.frame.maxY)
        continueButton.frame = CGRect(x: (view.frame.width - buttonWidth)/2, y: tableView.frame.maxY + ((heightToBottom - buttonHeight)/2), width: buttonWidth, height: buttonHeight)
        continueButton.layer.cornerRadius = continueButton.frame.width/40
        continueButton.backgroundColor = .systemBlue
        continueButton.titleLabel!.textColor = .white
        continueButton.setTitle("Finish Account", for: .normal)
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
        
        var hyphenCountry = myCountry.replacingOccurrences(of: " ", with: "-")
        hyphenCountry = hyphenCountry.lowercased()
        return hyphenCountry
    }
    
    func pass(data: String) {
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
            cellArray[3].socialMediaIcon.image = UIImage(named: formattedCountry) ?? UIImage(named: "unity")
        }
        
    }
    
    
    @objc func continueTapped(_ sender: UITapGestureRecognizer) {
        let userData = userDataVM?.userData.value
        if cellArray[0].interactiveTextField.text == "" || cellArray[1].interactiveTextField.text == "" || cellArray[2].interactiveTextField.text == "" {
            // print("Fill in all required fields")//
            let alert = UIAlertController(title: "Required", message: "Fill in all required fields.", preferredStyle: .alert)
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
        
        //save birthday, current city, gender, cultural identity, phonenumber, relationship status
        let myBirthday = cellArray[0].interactiveTextField.text
        let myCurrentCity = cellArray[1].interactiveTextField.text
        let myGender = cellArray[2].interactiveTextField.text
        let myPhoneNumber = cellArray[4].interactiveTextField.text ?? ""
        
        userData?.birthday = myBirthday ?? ""
        userData?.currentCity = myCurrentCity ?? ""
        userData?.gender = myGender ?? ""
        userData?.phoneNumber = myPhoneNumber
        
        addBirthdayHex()
        userData?.numPosts += 1
        
        let myCity = cellArray[1].interactiveTextField.text ?? ""
        if myCity.contains("United States") {
            addCityHex()
            userData?.numPosts += 1
        }
            
  
        if !myCountries.isEmpty {
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
        
        postButton.isUserInteractionEnabled = false
        
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
            self.performSegue(withIdentifier: "signUpSegue2", sender: self)
            blurEffectView.removeFromSuperview()
            loadingIndicator!.view.removeFromSuperview()
            loadingIndicator!.removeFromParent()
            self.postButton.isUserInteractionEnabled = true
        })
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
        citySearchVC.modalPresentationStyle = .fullScreen
        self.present(citySearchVC, animated: false, completion: nil)
    }
    
    @objc func genderCellTap(_ sender: UITapGestureRecognizer) {
        print("I tapped gender cell")
        cellArray[2].interactiveTextField.becomeFirstResponder()
        
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
        cellArray[4].interactiveTextField.becomeFirstResponder()
    }
    
    
    @objc func relationshipCellTap(_ sender: UITapGestureRecognizer) {
        cellArray[5].interactiveTextField.becomeFirstResponder()
    }
    
    
    
    func setUpNavBarView() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(backButton)
        self.navBarView.addSubview(postButton)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        
        let navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
        navBarView.backButton.isHidden = true
        navBarView.postButton.isHidden = true
        let backButtonWidth = CGFloat(30)
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
        
        self.navBarView.addBehavior()
        self.navBarView.titleLabel.text = "Personal Details"
        
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 140, y: postButton.frame.minY, width: 280, height: 25)
        navBarView.backgroundColor = .white
        navBarView.titleLabel.textColor = .black
        
    }
    
    
    var textFieldData = [String]()

    
    
    
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
        return tableView.frame.height/6
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalDetailCell", for: indexPath) as! PersonalDetailCell
        cell.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/8)
        cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
        let myGray = cell.backgroundColor
        cell.layer.borderColor = myGray?.cgColor
        cell.layer.borderWidth = 10

        cell.socialMediaIcon.layer.cornerRadius = cell.socialMediaIcon.frame.size.width / 2
        cell.socialMediaIcon.clipsToBounds = true
        cell.socialMediaIcon.layer.borderWidth = 1.0
        cell.socialMediaIcon.layer.borderColor = white.cgColor
        cell.interactiveTextField.isUserInteractionEnabled = true
        cell.interactiveTextField.textColor = .black
        
        
        cell.interactiveTextField.attributedPlaceholder = NSAttributedString(string: "Ethnicities",
                                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        cell.socialMediaIcon.image = iconArray[indexPath.row]
        
        cell.circularMask.frame = cell.socialMediaIcon.frame
        cell.interactiveTextField.textColor = .black

        
        cell.interactiveTextField.tag = indexPath.row

        
        //do birthday stuff
        if indexPath.row == 0 {
            //show datePicker
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            //ToolBar
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
            
            toolbar.setItems([cancelButton, spaceButton,doneButton], animated: false)
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
        cellArray.append(cell)
        
        return cell
    }
}
protocol isAbleToReceiveData {
    func pass(data: String)  //data: string is an example parameter
    func passArray(dataArray: [String])
}

