//
//  UploadPreviewVC.swift
//  Bio
//
//  Created by Ann McDonough on 8/6/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseUI
import FirebaseStorage

class UploadPreviewVC: UIViewController { //}, UITableViewDelegate, UITableViewDataSource {
    
    var photos: [UIImage]?
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    
    @IBOutlet weak var tableView: UITableView!
    var userData: UserData?
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var cellArray: [UploadPreviewCell] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
             tableView.dataSource = self
        print("This is photos \(photos)")
        // Do any additional setup after loading the view.
        tableView.reloadData()
        if (userData == nil) {
            print("userdata did not get passed through")
            let userEmail = Auth.auth().currentUser?.email
            db.collection("UserData1").whereField("email", isEqualTo: userEmail).addSnapshotListener({ objects, error in
                if (error == nil && objects?.documents.count ?? 0 > 0) {
                    self.userData = UserData(dictionary: objects!.documents[0].data())
                }
                
            })
        }
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        var success = true
        var count = 0
        for cell in cellArray {
            count += 1
            let timestamp = Timestamp.init()
            print("addinghex")
            let photoLocation = "userFiles/\(userData!.publicID)/\(count)_\(timestamp.dateValue()).png"
            uploadPhoto(reference: photoLocation, image: cell.previewImage.image!, completion: { upComplete in
                if (upComplete) {
                    print("uploaded shid")
                }
                else {
                    print("didnt upload shid")
                }
            })
            let photoHex = HexagonStructData(resource: photoLocation, type: "photo", location: self.userData!.numPosts + count, thumbResource: photoLocation, createdAt: TimeInterval.init(), postingUserID: self.userData!.publicID, text: "\(cell.captionField.text)", views: 0)
            print("should be adding \(photoHex)")
            self.addHex(hexData: photoHex, completion: {    bool in
              success = success && bool
              
              if (bool) {
                  print("hex successfully added")
              }
              else {
                  print("hex failed")
              }
            })
            
        }
        self.userData!.numPosts += count
        self.db.collection("UserData1").document(Auth.auth().currentUser!.uid).setData(self.userData!.dictionary, completion: { error in
            if error == nil {
                print("should navigate to homehexgrid")
                self.performSegue(withIdentifier: "unwindFromUpload", sender: nil)
            }
        })
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // prepare if needed
    }
    
    func uploadPhoto(reference: String, image: UIImage, completion: @escaping (Bool) -> Void) {

        let photoRef = storageRef.child(reference)
        print("ref and img")
        print(reference)
        print(image)
        photoRef.putData(image.pngData()!, metadata: nil, completion: { data, error in
            print("got complete")
            return completion(error == nil)
            })
    }
    
    func addHex(hexData: HexagonStructData, completion: @escaping (Bool) -> Void) {
          let hexCollectionRef = db.collection("Hexagons")
          hexCollectionRef.addDocument(data: hexData.dictionary).addSnapshotListener({object,error in
              if error == nil {
                  print("added hex: \(hexData)")
                return completion(true)
              }
              else {
                  print("failed to add hex \(hexData)")
                return completion(false)
              }
          })
      }
    
    @IBAction func cancelPost(_ sender: UIButton) {
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UploadPreviewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          // put the number of photos that you have selected in here for count
          print("This is photos.count \(photos?.count)")
          return photos?.count ?? 0
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          //put the right photo in the right index here
         let cell = tableView.dequeueReusableCell(withIdentifier: "uploadPreviewCell", for: indexPath) as! UploadPreviewCell
          print("This is cell \(cell)")
          cell.previewImage.image = photos![indexPath.row]
          print("This is cell image \(cell.previewImage.image)")
        cell.previewImage.setupHexagonMask(lineWidth: 10.0, color: .black, cornerRadius: 10.0)
        cellArray.append(cell)
               return cell
          
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    
    
}
