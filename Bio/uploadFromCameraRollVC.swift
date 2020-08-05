//
//  uploadFromCameraRollVC.swift
//  Bio
//
//  Created by Ann McDonough on 7/30/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//


import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
//import Parse


class uploadFromCameraRollVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var firstTime = true
    
    // UI objects
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextView!
    @IBOutlet weak var publishBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    let currentUser = Auth.auth().currentUser
    
    // Get a reference to the storage service using the default Firebase App
    let storage = Storage.storage()
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable publish btn
        publishBtn.isEnabled = false
        publishBtn.backgroundColor = .lightGray
        
        // hide remove button
        removeBtn.isHidden = true
        
        // standart UI containt
        picImg.image = UIImage(named: "boyprofile")
        
        // hide kyeboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(uploadFromCameraRollVC.hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // select image tap
        let picTap = UITapGestureRecognizer(target: self, action: #selector(uploadFromCameraRollVC.selectImg))
        picTap.numberOfTapsRequired = 1
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(picTap)
    }
    
    
    // preload func
    override func viewWillAppear(_ animated: Bool) {
        // call alignment function
        alignment()
    }
    
    
    // hide kyeboard function
    @objc func hideKeyboardTap() {
        self.view.endEditing(true)
    }
    
    
    // func to cal pickerViewController
    @objc func selectImg() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    // hold selected image in picImg object and dissmiss PickerController()
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        picImg.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        // enable publish btn
        publishBtn.isEnabled = true
        publishBtn.backgroundColor = UIColor(red: 52.0/255.0, green: 169.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        // unhide remove button
        removeBtn.isHidden = false
        
        // implement second tap for zooming image
        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(uploadFromCameraRollVC.zoomImg))
        zoomTap.numberOfTapsRequired = 1
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(zoomTap)
    }
    
    
    // zooming in / out function
    @objc func zoomImg() {
        
        // define frame of zoomed image
        let zoomed = CGRect(x: 0, y: self.view.center.y - self.view.center.x - self.tabBarController!.tabBar.frame.size.height * 1.5, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        // frame of unzoomed (small) image
        let unzoomed = CGRect(x: 15, y: 15, width: self.view.frame.size.width / 4.5, height: self.view.frame.size.width / 4.5)
        
        // if picture is unzoomed, zoom it
        if picImg.frame == unzoomed {
            
            // with animation
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                // resize image frame
                self.picImg.frame = zoomed
                
                // hide objects from background
                self.view.backgroundColor = .black
                self.titleTxt.alpha = 0
                self.publishBtn.alpha = 0
                self.removeBtn.alpha = 0
            })
            
            // to unzoom
        } else {
            
            // with animation
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                // resize image frame
                self.picImg.frame = unzoomed
                
                // unhide objects from background
                self.view.backgroundColor = .white
                self.titleTxt.alpha = 1
                self.publishBtn.alpha = 1
                self.removeBtn.alpha = 1
            })
        }
        
    }
    
    
    // alignment
    func alignment() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        picImg.frame = CGRect(x: 15, y: 15, width: width / 4.5, height: width / 4.5)
        titleTxt.frame = CGRect(x: picImg.frame.size.width + 25, y: picImg.frame.origin.y, width: width / 1.488, height: picImg.frame.size.height)
        publishBtn.frame = CGRect(x: 0, y: height / 1.09, width: width, height: width / 8)
        removeBtn.frame = CGRect(x: picImg.frame.origin.x, y: picImg.frame.origin.y + picImg.frame.size.height, width: picImg.frame.size.width, height: 20)
    }
    
    
    func saveData(completed: @escaping (Bool) -> ()) {
        let username = currentUser?.email?.split(separator: "@")[0] ?? ""
        let usernameString = String(username)
        if (username == "") {
            return
        }
        
        
        let userStorageRef = storage.reference().child("userFiles").child(usernameString)
        
        // dissmiss keyboard
        self.view.endEditing(true)
        
        // send pic to server after converting to FILE and comprassion
        let imageData = picImg.image!.jpegData(compressionQuality: 0.5)
        let uniqueName = String(Date().timeIntervalSince1970 * 1000) + ".jpg"
        let imageRef = userStorageRef.child(uniqueName)
        if (imageData != nil) {
            let uploadTask = imageRef.putData(imageData!, metadata: nil) { (data, error) -> Void in
                guard let metadata = data else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    
                }
            }
            uploadTask.observe(.success) { snapshot -> Void in
                print("im in")
                let resourceString = "userFiles/\(usernameString)/\(uniqueName)"
                let hexCollection = Firestore.firestore().collection("Hexagons")
                var userData: UserData? = nil
                var userDataRef: DocumentReference? = nil
                let userDataCollection = Firestore.firestore().collection("UserData")
                let userQuery = userDataCollection.whereField("publicID", isEqualTo: usernameString)
                userQuery.addSnapshotListener({objects,error -> Void in
                    print("im still running")
                    if error == nil && self.firstTime == true {
                        userData = UserData(dictionary: objects!.documents[0].data())
                        userDataRef = objects!.documents[0].reference
                        
                        let hexData = HexagonStructData(resource: resourceString, type: "Photo", location: userData!.numPosts + 1, thumbResource: resourceString, createdAt: NSTimeIntervalSince1970, postingUserID: usernameString, text: self.titleTxt.text, views: 0)
                        userData?.numPosts += 1
                        userDataRef?.updateData(userData!.dictionary)
                        hexCollection.addDocument(data: hexData.dictionary)
                        print("This is hexData \(hexData)")
                        self.firstTime = false
                        print("I went through, first time = \(self.firstTime)")
                        
                        completed(true)
                    }
                    else {
                        print(error?.localizedDescription)
                        completed(false)
                    }
                })
                completed(true)
                
            }
            uploadTask.observe(.failure) { snapshot -> Void in
                // Upload failed
                print("upload Task failed")
                completed(false)
            }
        }
        else {
            //no image provided
            print("no image provided")
            completed(false)
        }
    }
    
    
    
    // clicked publish button
    @IBAction func publishBtn_clicked(_ sender: AnyObject) {
        firstTime = true
        saveData { success in
            if (success) {
                print("success")
            }
            else {
                print("failed")
            }
            return
            
        }
        //        let username = currentUser?.email?.split(separator: "@")[0] ?? ""
        //        let usernameString = String(username)
        //        if (username == "") {
        //            return
        //        }
        //
        //
        //        let userStorageRef = storage.reference().child("userFiles").child(usernameString)
        //
        //        // dissmiss keyboard
        //        self.view.endEditing(true)
        //
        //        // send pic to server after converting to FILE and comprassion
        //        let imageData = picImg.image!.jpegData(compressionQuality: 0.5)
        //        let timestamp = String(Date().timeIntervalSince1970 * 1000) + ".jpg"
        //        let imageRef = userStorageRef.child(timestamp)
        //        if (imageData != nil) {
        //            let uploadTask = imageRef.putData(imageData!, metadata: nil) { (data, error) -> Void in
        //                guard let metadata = data else {
        //                    // Uh-oh, an error occurred!
        //                    return
        //                }
        //                // Metadata contains file metadata such as size, content-type.
        //                let size = metadata.size
        //                // You can also access to download URL after upload.
        //
        //                imageRef.downloadURL { (url, error) in
        //                    guard let downloadURL = url else {
        //                        // Uh-oh, an error occurred!
        //                        return
        //                    }
        //
        //                }
        //            }
        //            uploadTask.observe(.success) { snapshot -> Void in
        //                print("im in")
        //                let resourceString = "userFiles/\(usernameString)/\(timestamp).jpg"
        //                let hexCollection = Firestore.firestore().collection("Hexagons")
        //                var userData: UserData? = nil
        //                var userDataRef: DocumentReference? = nil
        //                let userDataCollection = Firestore.firestore().collection("UserData")
        //                let userQuery = userDataCollection.whereField("publicID", isEqualTo: usernameString)
        //                userQuery.addSnapshotListener({objects,error -> Void in
        //                    if error == nil {
        //                        userData = UserData(dictionary: objects!.documents[0].data())
        //                        userDataRef = objects!.documents[0].reference
        //
        //                        let hexData = HexagonStructData(resource: resourceString, type: "Photo", location: userData!.numPosts + 1, thumbResource: resourceString, createdAt: NSTimeIntervalSince1970, postingUserID: usernameString, text: self.titleTxt.text, views: 0)
        //                        userData?.numPosts += 1
        //                        userDataRef?.updateData(userData!.dictionary)
        //                        hexCollection.addDocument(data: hexData.dictionary)
        //                        print("This is hexData \(hexData)")
        //                        return
        //                    }
        //                    else {
        //                        print(error?.localizedDescription)
        //                        return
        //                    }
        //                })
        //                return
        //
        //            }
        //            uploadTask.observe(.failure) { snapshot -> Void in
        //                // Upload failed
        //                print("upload Task failed")
        //                return
        //            }
        //        }
        //        else {
        //            //no image provided
        //            print("no image provided")
        //        }
        
        
        
        
        //        // send #hashtag to server
        //        let words:[String] = titleTxt.text!.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        //
        //        // define taged word
        //        for var word in words {
        //
        //            // save #hasthag in server
        //            if word.hasPrefix("#") {
        //
        //                // cut symbold
        //                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
        //                word = word.trimmingCharacters(in: CharacterSet.symbols)
        //
        //                //let hashtagObj = PFObject(className: "hashtags")
        //                //hashtagObj["to"] = "\(PFUser.current()!.username!) \(uuid)"
        //                //hashtagObj["by"] = PFUser.current()?.username
        ////                hashtagObj["hashtag"] = word.lowercased()
        ////                hashtagObj["comment"] = titleTxt.text
        ////                hashtagObj.saveInBackground(block: { (success, error) -> Void in
        ////                    if success {
        ////                        print("hashtag \(word) is created")
        ////                    } else {
        ////                        print(error!.localizedDescription)
        ////                    }
        ////                })
        //            }
        //        }
        
        
        // finally save information
        //        object.saveInBackground (block: { (success, error) -> Void in
        //            if error == nil {
        //
        //                // send notification wiht name "uploaded"
        //                NotificationCenter.default.post(name: Notification.Name(rawValue: "uploaded"), object: nil)
        //
        //                // switch to another ViewController at 0 index of tabbar
        //                self.tabBarController!.selectedIndex = 0
        //
        //                // reset everything
        //                self.viewDidLoad()
        //                self.titleTxt.text = ""
        //            }
        //        })
        
    }
    
    
    // clicked remove button
    @IBAction func removeBtn_clicked(_ sender: AnyObject) {
        self.viewDidLoad()
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}



