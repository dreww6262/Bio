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
    
    
    @IBOutlet weak var tableView: UITableView!
    var userData: UserData?
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var cellArray: [UploadPreviewCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print("This is items \(items!)")
        // Do any additional setup after loading the view.
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (userData == nil) {
            print("userdata did not get passed through")
            let userEmail = Auth.auth().currentUser?.email
            db.collection("UserData1").whereField("email", isEqualTo: userEmail!).addSnapshotListener({ objects, error in
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
            switch (cell.item) {
            case .photo(let photo):
                print(photo)
                let photoLocation = "userFiles/\(userData!.publicID)/\(count)_\(timestamp.dateValue()).png"
                uploadPhoto(reference: photoLocation, image: photo, completion: { upComplete in
                    if (upComplete) {
                        print("uploaded shid")
                    }
                    else {
                        print("didnt upload shid")
                    }
                })
                let photoHex = HexagonStructData(resource: photoLocation, type: "photo", location: self.userData!.numPosts + count, thumbResource: photoLocation, createdAt: TimeInterval.init(), postingUserID: self.userData!.publicID, text: "\(cell.captionField!.text!)", views: 0, isArchived: false, docID: "willBeSetLater")
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
                
                
            case .video(let video):
                print(video)
                let videoLocation = "userFiles/\(userData!.publicID)/\(count)_\(timestamp.dateValue()).mov"
                let thumbLocation = "userFiles/\(userData!.publicID)/\(count)_\(timestamp.dateValue())_thumb.png"
                uploadVideo(reference: videoLocation, video: video, completion: { upComplete in
                    if (upComplete) {
                        print("uploaded shid")
                    }
                    else {
                        print("didnt upload shid")
                    }
                })
                uploadPhoto(reference: thumbLocation, image: YPMediaPhoto(image: video.thumbnail), completion: { upComplete in
                    if (upComplete) {
                        print("uploaded thumb")
                    }
                    else {
                        print("didnt upload thumb")
                    }
                })
                let videoHex = HexagonStructData(resource: videoLocation, type: "video", location: self.userData!.numPosts + count, thumbResource: thumbLocation, createdAt: TimeInterval.init(), postingUserID: self.userData!.publicID, text: "\(cell.captionField!.text!)", views: 0, isArchived: false, docID: "willBeSetLater")
                self.addHex(hexData: videoHex, completion: {    bool in
                    success = success && bool
                    
                    if (bool) {
                        print("hex successfully added")
                    }
                    else {
                        print("hex failed")
                    }
                })
                
            default:
                print("bad item")
                // shouldnt happen.  Items should be one of the above
            }
            
            
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
        let hexCopy = HexagonStructData(dictionary: hexData.dictionary)
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
        let previewImageWidth = cell.previewImage.frame.width
        let previewImageHeight = cell.previewImage.frame.height
        cell.previewImage.frame = CGRect(x: 10, y: cell.frame.height/2 - previewImageHeight/2, width: previewImageWidth, height: previewImageHeight)
        print("This is cell image \(cell.previewImage.image!)")
        cell.previewImage.setupHexagonMask(lineWidth: cell.previewImage.frame.width/15, color: gold, cornerRadius: cell.previewImage.frame.width/15)
        cellArray.append(cell)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    
    
}
