//
//  NewUploadPreviewVC.swift
//  Bio
//
//  Created by Ann McDonough on 10/13/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseUI
import FirebaseStorage
import YPImagePicker
import Photos

class NewUploadPreviewVC: UIViewController {
    var items: [YPMediaItem]?
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    let filterSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890/_-."
    
   // var titleLabel1 = UILabel()
    
    var subtitleLabel = UILabel()
    @IBOutlet weak var tableView: UITableView!
    var userData: UserData?
    
var doneButton = UIButton()
var cancelButton = UIButton()
    var cellArray: [UploadPreviewCell] = []
    
    var cancelLbl: String?
    
    var navBarView = NavBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBarView()
      //  formatBackButton()
       // formatUploadButton()
        tableView.delegate = self
        tableView.dataSource = self
        print("This is items \(items!)")
        // Do any additional setup after loading the view.
        tableView.reloadData()
        
    }
    
    func setUpNavBarView() {
        var statusBarHeight = UIApplication.shared.statusBarFrame.maxY
        self.view.addSubview(navBarView)
      //  self.navBarView.addSubview(titleLabel1)
        self.navBarView.addBehavior()

        self.navBarView.titleLabel.text = "New Post"
      //  self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/10)+5)
        self.navBarView.frame = CGRect(x: -5, y: -5, width: self.view.frame.width + 10, height: (self.view.frame.height/12)+5)
        let yOffset = navBarView.frame.maxY
        self.tableView.frame = CGRect(x: 0, y: yOffset, width: self.view.frame.width, height: self.view.frame.height - yOffset)
    //    self.navBarView.titleLabel.frame = CGRect(x: 0, y: self.navBarView.frame.maxY - 30, width: self.view.frame.width, height: 30)
        self.navBarView.titleLabel.textAlignment = .center
        
        self.navBarView.titleLabel.font = UIFont(name: "DINAlternate-Bold", size: 20)
        self.navBarView.titleLabel.textColor = .white
        self.navBarView.backgroundColor = UIColor(cgColor: CGColor(gray: 0.05, alpha: 1.0))
        self.navBarView.layer.borderWidth = 0.25
        self.navBarView.layer.borderColor = CGColor(gray: 2/3, alpha: 1.0)
        
    //    self.navBarView.addSubview(self.cancelButton)
  //      self.navBarView.addSubview(doneButton)
        var navBarHeightRemaining = navBarView.frame.maxY - statusBarHeight
      //  self.cancelButton.frame = CGRect(x: 5, y: navBarView.frame.maxY - 30, width: 25, height: 25)
        let postTap = UITapGestureRecognizer(target: self, action: #selector(self.donePressed))
        postTap.numberOfTapsRequired = 1
//        self.doneButton.isUserInteractionEnabled = true
//        self.doneButton.addGestureRecognizer(postTap)
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(self.cancelPost))
        cancelTap.numberOfTapsRequired = 1
        self.navBarView.backButton.isUserInteractionEnabled = true
        self.navBarView.backButton.addGestureRecognizer(cancelTap)
        
        
       // self.cancelButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        //cancelButton.imageView?.frame = cancelButton.frame
        self.navBarView.backButton.clipsToBounds = true
        self.navBarView.backButton.isHidden = false
        self.navBarView.backButton.clipsToBounds = true
        self.navBarView.postButton.isHidden = false
       // followView.isHidden = false
        self.navBarView.postButton.isHidden = false
       // self.doneButton.frame = CGRect(x: self.view.frame.width - 75, y: navBarView.frame.maxY - 30, width: 70, height: 25)
        self.navBarView.backButton.frame = CGRect(x: 10, y: statusBarHeight + (navBarHeightRemaining - 25)/2, width: 25, height: 25)
        self.navBarView.postButton.frame = CGRect(x: navBarView.frame.maxX - 65, y: statusBarHeight + (navBarHeightRemaining - 30)/2, width: 50, height: 30)
        self.navBarView.postButton.titleLabel?.textAlignment = .right
        
        self.navBarView.postButton.isUserInteractionEnabled = true
        self.navBarView.postButton.addGestureRecognizer(postTap)
        self.navBarView.titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 100, y: navBarView.frame.maxY - 30, width: 200, height: 30)
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func formatBackButton() {
        
        self.navBarView.addSubview(cancelButton)
        self.cancelButton.frame = CGRect(x: 5, y: navBarView.frame.maxY - 30, width: 25, height: 25)
        print("This is cancel Button.frame \(cancelButton.frame)")
        print("This is post Button.frame \(doneButton.frame)")
        
        cancelButton.clipsToBounds = true
        cancelButton.isHidden = false
    }
    
    func formatUploadButton() {
        self.view.addSubview(doneButton)
        
     //   doneButton.frame = CGRect(x: self.view.frame.width - (self.view.frame.height*(3/48)), y: (self.view.frame.height/48) + 2, width: self.view.frame.height/24, height: self.view.frame.height/24)
        
//        doneButton.frame = CGRect(x: self.view.frame.width - (self.view.frame.height*(3/48)), y: (self.view.frame.height/48) + 2, width: self.view.frame.height/24, height: self.view.frame.height/24)
        // round ava
        doneButton.clipsToBounds = true
        doneButton.isHidden = false
       // followView.isHidden = false
        doneButton.isHidden = false
        doneButton.frame = CGRect(x: self.view.frame.width - 30, y: navBarView.frame.maxY - 30, width: 25, height: 25)
        
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
    
    var loadingIndicator: UIViewController?
    var blurEffectView: UIVisualEffectView?
    
    
    @objc func donePressed(_ sender: UIButton) {
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
        
        let loadingIndicator = storyboard?.instantiateViewController(withIdentifier: "loading")
        
        blurEffectView = {
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
        view.addSubview(blurEffectView!)
        
        addChild(loadingIndicator!)
        view.addSubview(loadingIndicator!.view)
        
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
                if (self.cancelLbl == nil) {
                    self.performSegue(withIdentifier: "unwindFromUpload", sender: nil)
                }
                else {
                    let musicVC = self.storyboard?.instantiateViewController(withIdentifier: "addMusicVC") as! AddMusicVC
                    musicVC.userData = self.userData
                    musicVC.currentUser = Auth.auth().currentUser
                    musicVC.cancelLbl = "Skip"
                    self.present(musicVC, animated: false, completion: nil)
                }
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
    
    @objc func cancelPost(_ sender: UIButton) {
        print("Trying to cancel")
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
    
    @objc func tagTapped(_ sender: UITapGestureRecognizer) {
        print("tag view hit!")
        print("******Pull in the cell this is contained in so we can ge the image for the next page")
        let cell = sender.view?.superview?.superview as! UploadPreviewCell
        
        let tagUsersVC = storyboard?.instantiateViewController(identifier: "tagUsersVC") as! TagUsersVC
        tagUsersVC.item = cell.item
        tagUsersVC.tagImage = cell.previewImage
        tagUsersVC.userData = self.userData
        present(tagUsersVC, animated: false)
    }
    
    @objc func locationTapped(_ sender: UITapGestureRecognizer) {
        print("location view hit!")
        let addLocationVC = storyboard?.instantiateViewController(identifier: "mapViewController") as! MapViewController
       // addLocationVC.tagImage = cellArray[0].previewImage
        addLocationVC.userData = self.userData
        present(addLocationVC, animated: false)
    }
    
    
}

extension NewUploadPreviewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // put the number of photos that you have selected in here for count
        print("This is photos.count \(items!.count)")
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //put the right photo in the right index here
        print("inside table view func")
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
//        let previewImageWidth = cell.previewImage.frame.width
//        let previewImageHeight = cell.previewImage.frame.height
//        cell.previewImage.frame = CGRect(x: 10, y: (cell.frame.height/2) - (previewImageHeight/2), width: previewImageWidth, height: previewImageHeight)
//        cell.previewImage.center = CGPoint(x: cell.contentView.bounds.size.width/2,y: cell.contentView.bounds.size.height/2)
   
        cell.captionField.attributedPlaceholder = NSAttributedString(string: "Write A Caption...",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
   
        print("This is preview image frame \(cell.previewImage.frame)")
        print("This is cell frame \(cell.frame)")
        print("This is cell image \(cell.previewImage.image!)")
        
//        print("This is locationView frame \(cell.locationView.frame)")
//        print("This is tag view frame \(cell.tagView.frame)")
//        print("This is taglabel frame \(cell.tagLabel.frame)")
//        print("This is location label frame \(cell.locationLabel.frame)")
//        print("This is tag arrow frame \(cell.tagArrow.frame)")
//        print("This is location arrow frame \(cell.locationArrow.frame)")
//
//        let tagTap = UITapGestureRecognizer(target: self, action: #selector(tagTapped))
//        let locationTap = UITapGestureRecognizer(target: self, action: #selector(locationTapped))
//        cell.tagView.addGestureRecognizer(tagTap)
//        cell.locationView.addGestureRecognizer(locationTap)
//
//
        
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: 100, width: cell.captionField.frame.width, height: 0.1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        
//        let bottomLine2 = CALayer()
//        bottomLine2.frame = CGRect(x: 110, y: cell.tagView.frame.maxY, width: cell.tagView.frame.width, height: 1.0)
//        bottomLine2.backgroundColor = UIColor.white.cgColor
//
//        let bottomLine3 = CALayer()
//        bottomLine3.backgroundColor = UIColor.white.cgColor
////        bottomLine3.frame = CGRect(x: 110, y: cell.locationView.frame.maxY, width: cell.locationView.frame.width, height: 1.0)
//
//
//
//                bottomLine3.backgroundColor = UIColor.white.cgColor
        cell.captionField.borderStyle = UITextField.BorderStyle.none

        cell.captionField.textColor = .white
   
        
        cellArray.append(cell)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    
}

