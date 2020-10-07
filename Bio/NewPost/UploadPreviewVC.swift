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
import YPImagePicker
import Photos

class UploadPreviewVC: UIViewController { //}, UITableViewDelegate, UITableViewDataSource {
    
    var items: [YPMediaItem]?
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    let filterSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890/_-."
    
    @IBOutlet weak var titleLabel1: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var userData: UserData?
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var cellArray: [UploadPreviewCell] = []
    
    var navBarView = NavBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBarView()
        formatBackButton()
        formatUploadButton()
        tableView.delegate = self
        tableView.dataSource = self
        print("This is items \(items!)")
        // Do any additional setup after loading the view.
        tableView.reloadData()
        
    }
    
    func setUpNavBarView() {
        self.view.addSubview(navBarView)
        self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()

        self.titleLabel1.text = "New Post"
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        let yOffset = navBarView.frame.maxY
        self.tableView.frame = CGRect(x: 0, y: yOffset, width: self.view.frame.width, height: self.view.frame.height - yOffset)
        self.titleLabel1.frame = CGRect(x: 0, y: 5, width: self.view.frame.width, height: self.view.frame.height/12)
        self.titleLabel1.textAlignment = .center
        
        self.titleLabel1.font = UIFont(name: "DINAlternate-Bold", size: 25)
        self.titleLabel1.textColor = .white
        self.navBarView.backgroundColor = UIColor(cgColor: CGColor(gray: 0.05, alpha: 1.0))
        self.navBarView.layer.borderWidth = 0.25
        self.navBarView.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
    }
    
    func formatBackButton() {
        self.view.addSubview(cancelButton)
       // toSettingsButton.frame = CGRect(x: 15, y: self.view.frame.height/48, width: 30, height: 30)
        cancelButton.frame = CGRect(x: self.view.frame.height*(1/48), y: (self.view.frame.height/48) + 2, width: self.view.frame.height/18, height: self.view.frame.height/18)
        
//        cancelButton.frame = CGRect(x: self.view.frame.height*(1/48), y: (self.view.frame.height/48) + 2, width: self.view.frame.height/24, height: self.view.frame.height/24)
        // round ava
        cancelButton.clipsToBounds = true
        cancelButton.isHidden = false
    }
    
    func formatUploadButton() {
        self.view.addSubview(doneButton)
        
        doneButton.frame = CGRect(x: self.view.frame.width - (self.view.frame.height*(3/48)), y: (self.view.frame.height/48) + 2, width: self.view.frame.height/24, height: self.view.frame.height/24)
        
//        doneButton.frame = CGRect(x: self.view.frame.width - (self.view.frame.height*(3/48)), y: (self.view.frame.height/48) + 2, width: self.view.frame.height/24, height: self.view.frame.height/24)
        // round ava
        doneButton.clipsToBounds = true
        doneButton.isHidden = false
       // followView.isHidden = false
        doneButton.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (userData == nil) {
            print("userdata did not get passed through")
            let privateID = Auth.auth().currentUser?.uid
            db.collection("UserData1").document(privateID ?? "").getDocument(completion: { doc, error in
                if error == nil {
                    guard let data = doc?.data() else {
                        print("Could not get userdata")
                        return
                    }
                    self.userData = UserData(dictionary: data)
                }
            })
        }
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        var success = true
        var count = 0
        let numPosts = self.userData!.numPosts
        
        if numPosts + cellArray.count > 37 {
            // too many posts
            let overflow = numPosts + cellArray.count - 37
            let alert = UIAlertController(title: "Not Enough Space :/", message: "Either remove \(overflow) photo\(overflow > 1 ? "s" : "") or delete \(overflow) post\(overflow > 1 ? "s" : "") from your home grid.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        var hexesToUpload = ThreadSafeArray<HexagonStructData>()
        
        let dispatchGroup = DispatchGroup()
        
        for cell in cellArray {
            dispatchGroup.enter()
            // get count for current post of batch
            count += 1
            // get timestamp for unique location name
            let timestamp = Timestamp.init()
            //print("addinghex")
            switch (cell.item) {
            case .photo(let photo):
                //print(photo)
                let rawPhotoLocation = "userFiles/\(userData!.publicID)/\(count)_\(timestamp.dateValue()).png"
                let photoLocation = rawPhotoLocation.filter{filterSet.contains($0)}
                var photoHex = HexagonStructData(resource: photoLocation, type: "photo", location: numPosts + count, thumbResource: photoLocation, createdAt: NSDate.now.description, postingUserID: self.userData!.publicID, text: "\(cell.captionField!.text!)", views: 0, isArchived: false, docID: "willBeSetLater")
                uploadPhoto(reference: photoLocation, image: photo, completion: { upComplete in
                    if (upComplete) {
                        print("uploaded shid")
                        print("should be adding \(photoHex)")
                        hexesToUpload.append(newElement: photoHex)
                        dispatchGroup.leave()
                    }
                    else {
                        dispatchGroup.leave()
                        print("didnt upload shid")
                    }
                })
            case .video(let video):
                print(video)
                let rawVideoLocation = "userFiles/\(userData!.publicID)/\(count)_\(timestamp.dateValue()).mov"
                let rawThumbLocation = "userFiles/\(userData!.publicID)/\(count)_\(timestamp.dateValue())_thumb.png"
                let videoLocation = rawVideoLocation.filter{filterSet.contains($0)}
                let thumbLocation = rawThumbLocation.filter{filterSet.contains($0)}
                let videoHex = HexagonStructData(resource: videoLocation, type: "video", location: numPosts + count, thumbResource: thumbLocation, createdAt: NSDate.now.description, postingUserID: self.userData!.publicID, text: "\(cell.captionField!.text!)", views: 0, isArchived: false, docID: "willBeSetLater")
                uploadVideo(reference: videoLocation, video: video, completion: { upComplete in
                    if (upComplete) {
                        print("uploaded shid")
                        self.uploadPhoto(reference: thumbLocation, image: YPMediaPhoto(image: video.thumbnail), completion: { upComplete in
                            if (upComplete) {
                                print("uploaded thumb")
                                hexesToUpload.append(newElement: videoHex)
                                dispatchGroup.leave()
//                                self.addHex(hexData: videoHex, completion: {    bool in
//                                    success = success && bool
//
//                                    if (bool) {
//                                        print("hex successfully added")
//                                    }
//                                    else {
//                                        print("hex failed")
//                                    }
//                                })
                            }
                            else {
                                print("didnt upload thumb")
                                dispatchGroup.leave()
                            }
                        })
                    }
                    else {
                        print("didnt upload shid")
                        dispatchGroup.leave()
                    }
                })
                
            default:
                print("bad item")
                dispatchGroup.leave()
                // shouldnt happen.  Items should be one of the above
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.uploadHexagons(hexes: hexesToUpload)
        }
    }
    
    func uploadHexagons(hexes: ThreadSafeArray<HexagonStructData>) {
        
        
        var readHexes = hexes.readOnlyArray()
        var failedHexes = [HexagonStructData]()
        readHexes.sort(by: { a, b in
            return a.location < b.location
        })
        let sem = DispatchSemaphore(value: 1)
        
        DispatchQueue.global().async {
            for var hex in readHexes {
                sem.wait()
                hex.location -= failedHexes.count
                self.addHex(hexData: hex, completion: { bool in
                    if (!bool) {
                        failedHexes.append(hex)
                    }
                    sem.signal()
                })
            }
        }
        
        self.userData!.numPosts += (hexes.count - failedHexes.count)
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
    
    func uploadPhoto(reference: String, image: YPMediaPhoto, completion: @escaping (Bool) -> Void) {
        
        let photoRef = storageRef.child(reference)
        print("ref and img")
        print(reference)
        print(image)
        photoRef.putData(image.image.pngData()!, metadata: nil, completion: { data, error in
            print("got complete")
            return completion(error == nil)
        })
    }
    
    func uploadVideo(reference: String, video: YPMediaVideo, completion: @escaping (Bool) -> Void) {
        
        let videoRef = storageRef.child(reference)
        uploadTOFireBaseVideo(url: video.url, storageRef: videoRef, completion: { bool in
            completion(bool)
        })
        
        
    }
    
    func uploadTOFireBaseVideo(url: URL, storageRef: StorageReference,
                                      completion : @escaping (Bool) -> Void) {

        let name = "\(Int(Date().timeIntervalSince1970)).mp4"
        let path = NSTemporaryDirectory() + name

        let dispatchgroup = DispatchGroup()

        dispatchgroup.enter()

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputurl = documentsURL.appendingPathComponent(name)
        var ur = outputurl
        self.convertVideo(toMPEG4FormatForVideo: url as URL, outputURL: outputurl) { (session) in

            ur = session.outputURL!
            dispatchgroup.leave()

        }
        dispatchgroup.wait()

        let data = NSData(contentsOf: ur as URL)

        do {

            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)

        } catch {

            print(error)
        }

        if let uploadData = data as Data? {
            storageRef.putData(uploadData, metadata: nil
                , completion: { (metadata, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false)
                    }else{
                        //let strPic:String = (metadata?.downloadURL()?.absoluteString)!
                        completion(true)
                    }
            })
        }
    }
    
    
    func convertVideo(toMPEG4FormatForVideo inputURL: URL, outputURL: URL, handler: @escaping (AVAssetExportSession) -> Void) {
        do{
            try FileManager.default.removeItem(at: outputURL as URL)
        }
        catch {
            print("bade")
        }
        let asset = AVURLAsset(url: inputURL as URL, options: nil)

        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously(completionHandler: {
            handler(exportSession)
        })
    }
    
    @IBAction func cancelPost(_ sender: UIButton) {
        self.items = []
        self.dismiss(animated: false, completion: nil)
    }
    
    func addHex(hexData: HexagonStructData, completion: @escaping (Bool) -> Void) {
        let hexCollectionRef = db.collection("Hexagons2")
        let docRef = hexCollectionRef.document()
        var hexCopy = HexagonStructData(dictionary: hexData.dictionary)
        hexCopy.docID = docRef.documentID
        docRef.setData(hexCopy.dictionary) { error in
            if error == nil {
                print("added hex: \(hexCopy)")
                return completion(true)
            }
            else {
                print("failed to add hex \(hexCopy)")
                return completion(false)
            }
        }
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
        print("This is photos.count \(items!.count)")
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //put the right photo in the right index here
        let cell = tableView.dequeueReusableCell(withIdentifier: "uploadPreviewCell", for: indexPath) as! UploadPreviewCell
        print("This is cell \(cell)")
        // TODO: fix next line
        switch items![indexPath.row] {
        case .photo(let photo):
            cell.previewImage.image = photo.image
        case .video(let video) :
            cell.previewImage.image = video.thumbnail
        default:
            print("bad")
        }
        cell.item = items![indexPath.row]
        cell.previewImage.setupHexagonMask(lineWidth: cell.previewImage.frame.width/15, color: myOrange, cornerRadius: cell.previewImage.frame.width/15)
        let previewImageWidth = cell.previewImage.frame.width
        let previewImageHeight = cell.previewImage.frame.height
        cell.previewImage.frame = CGRect(x: 10, y: (cell.frame.height/2) - (previewImageHeight/2), width: previewImageWidth, height: previewImageHeight)
        cell.previewImage.center = CGPoint(x: cell.contentView.bounds.size.width/2,y: cell.contentView.bounds.size.height/2)
   
        cell.captionField.attributedPlaceholder = NSAttributedString(string: "Write A Caption...",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        cell.tagField.attributedPlaceholder = NSAttributedString(string: "Tag Friends",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        cell.locationField.attributedPlaceholder = NSAttributedString(string: "Add Location",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        print("This is preview image frame \(cell.previewImage.frame)")
        print("This is cell frame \(cell.frame)")
        print("This is cell image \(cell.previewImage.image!)")
        
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 110, y: cell.captionField.frame.maxY, width: cell.captionField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 110, y: cell.tagField.frame.maxY, width: cell.tagField.frame.width, height: 1.0)
        bottomLine2.backgroundColor = UIColor.white.cgColor
               
        let bottomLine3 = CALayer()
        bottomLine3.backgroundColor = UIColor.white.cgColor
        bottomLine3.frame = CGRect(x: 110, y: cell.locationField.frame.maxY, width: cell.locationField.frame.width, height: 1.0)
        print("preview image frame \(cell.previewImage.frame)")
        print("bottomLine frame \(bottomLine.frame)")
        print("bottomLine 2 frame \(bottomLine2.frame)")
        print("bottomLine 3 frame \(bottomLine3.frame)")
        print("caption field frame \(cell.captionField.frame)")
        print("tag field  frame \(cell.tagField.frame)")
        print("location field frame \(cell.locationField.frame)")
        
        
                bottomLine3.backgroundColor = UIColor.white.cgColor
        cell.captionField.borderStyle = UITextField.BorderStyle.none
   //     cell.captionField.layer.addSublayer(bottomLine)
        cell.tagField.borderStyle = UITextField.BorderStyle.none
     //   cell.tagField.layer.addSublayer(bottomLine2)
        
        cell.locationField.borderStyle = UITextField.BorderStyle.none
       // cell.locationField.layer.addSublayer(bottomLine3)
//        bottomLine.frame = CGRect(x: 110, y: cell.captionField.frame.maxY, width: cell.captionField.frame.width, height: 1.0)
//        bottomLine2.frame = CGRect(x: 110, y: cell.locationField.frame.maxY, width: cell.locationField.frame.width, height: 1.0)
//        bottomLine3.frame = CGRect(x: 110, y: cell.locationField.frame.maxY, width: cell.locationField.frame.width, height: 1.0)
        cell.captionField.textColor = .white
        cell.tagField.textColor = .white
        cell.locationField.textColor = .white

        
        
        
//        cell.previewImage.setupHexagonMask(lineWidth: cell.previewImage.frame.width/15, color: myOrange, cornerRadius: cell.previewImage.frame.width/15)
        cellArray.append(cell)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    
}
