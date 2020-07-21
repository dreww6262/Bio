//
////  PhotoEditorVC.swift
////  Dart1
////
////  Created by Ann McDonough on 5/26/20.
////  Copyright © 2020 Patrick McDonough. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Photos
//import PhotosUI
//import Parse
//import AVKit
//import MobileCoreServices
//
//
//class PhotoEditorVC:
//    UIViewController,
//    UICollectionViewDataSource,
//    UICollectionViewDelegate,
//    UICollectionViewDelegateFlowLayout
//    {
//    @IBOutlet weak var titleTxt: UITextView!
//    var thumbnailImage: CIImage!
//    var thumbnailImages: [UIImage] = []
//    var previewImage: UIImage!
//    var previewedPhotoIndexPath: IndexPath!
//    var ciContext = CIContext(options: nil)
// //   let applier: Applier
//   // let applier: Applier
//    let filters: [(name: String, applier: FilterApplierType?)] = [
//        (name: "Normal",
//         applier: nil),
//        (name: "Nashville",
//         applier: ImageHelper.applyNashvilleFilter),
//        (name: "Toaster",
//         applier: ImageHelper.applyToasterFilter),
//        (name: "1977",
//         applier: ImageHelper.apply1977Filter),
//        (name: "Clarendon",
//         applier: ImageHelper.applyClarendonFilter),
//        (name: "HazeRemoval",
//         applier: ImageHelper.applyHazeRemovalFilter),
//        (name: "Chrome",
//         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectChrome")),
//        (name: "Fade",
//         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectFade")),
//        (name: "Instant",
//         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectInstant")),
//        (name: "Mono",
//         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectMono")),
//        (name: "Noir",
//         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectNoir")),
//        (name: "Process",
//         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectProcess")),
//        (name: "Tonal",
//         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectTonal")),
//        (name: "Transfer",
//         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectTransfer")),
//        (name: "Tone",
//         applier: ImageHelper.createDefaultFilterApplier(name: "CILinearToSRGBToneCurve")),
//        (name: "Linear",
//         applier: ImageHelper.createDefaultFilterApplier(name: "CISRGBToneCurveToLinear")),
//    ]
//    
//    @IBOutlet weak var preview: UIImageView!
//    @IBOutlet var filterCollection: UICollectionView!
//
//    var targetSize: CGSize {
//        let scale = UIScreen.main.scale
//        return CGSize(width: preview.bounds.width * scale,
//                      height: preview.bounds.height * scale)
//    }
//
//    
//    //  var delegate : AppDelegate?
//    
//    // MARK: UIViewController
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let startTime = getStartTime()
//        
//        self.preview.image = self.previewImage
//        self.thumbnailImages = filters.map({ (name, applier) -> UIImage in
//            let startTime = getStartTime()
//            
//            if applier == nil {
//                return UIImage(ciImage: self.thumbnailImage)
//            }
//            let uiImage = self.applyFilter(
//                applier: applier,
//                ciImage: self.thumbnailImage)
//            
//            printElapsedTime(title:"viewDidLoad\(name)", startTime: startTime)
//            
//            return uiImage
//        })
//        
//        printElapsedTime(title: "viewDidload", startTime: startTime)
//    }
//    
//    deinit {
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//    
//    
//@IBAction func publishBtn_clicked(_ sender: AnyObject) {
//            
//            // dissmiss keyboard
//            self.view.endEditing(true)
//            
//            // send data to server to "posts" class in Parse
//            let object = PFObject(className: "posts")
//            object["username"] = PFUser.current()!.username
//            object["ava"] = PFUser.current()!.value(forKey: "ava") as! PFFile
//            
//            let uuid = UUID().uuidString
//            object["uuid"] = "\(PFUser.current()!.username!) \(uuid)"
//            
//            if titleTxt.text.isEmpty {
//                object["title"] = ""
//            } else {
//                object["title"] = titleTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//            }
//            
//            // send pic to server after converting to FILE and comprassion
//         //   let imageData = picImg.image!.jpegData(compressionQuality: 0.5)
////    let imageData = previewImage!.jpegData(compressionQuality: 0.5)
//    let imageData = self.preview.image!.jpegData(compressionQuality: 0.5)
//    let imageFile = PFFile(name: "post.jpg", data: imageData!)
//            
//    //        let videoData = NSData(contentsOfFile:tempImage.relativePath)
//    //        let videoFile:PFFile = PFFile(name:"yourfilenamewithtype", data:videoData)
//    //        object.saveInBackgroundWithBlock(block: { (success, error) -> Void in
//    //
//    //        //Update your progress spinner here.percentDone will be between 0 and 100.
//    //
//    //        })
//            
//            
//            
//            
//            
//          //  let videoData = picImg.
//           // let videoFile = PFFile(name: <#T##String?#>, data: <#T##Data#>)
//            
//            object["pic"] = imageFile
//            
//            
//            // send #hashtag to server
//            let words:[String] = titleTxt.text!.components(separatedBy: CharacterSet.whitespacesAndNewlines)
//            
//            // define taged word
//            for var word in words {
//                
//                // save #hasthag in server
//                if word.hasPrefix("#") {
//                    
//                    // cut symbold
//                    word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
//                    word = word.trimmingCharacters(in: CharacterSet.symbols)
//                    
//                    let hashtagObj = PFObject(className: "hashtags")
//                    hashtagObj["to"] = "\(PFUser.current()!.username!) \(uuid)"
//                    hashtagObj["by"] = PFUser.current()?.username
//                    hashtagObj["hashtag"] = word.lowercased()
//                    hashtagObj["comment"] = titleTxt.text
//                    hashtagObj.saveInBackground(block: { (success, error) -> Void in
//                        if success {
//                            print("hashtag \(word) is created")
//                        } else {
//                            print(error!.localizedDescription)
//                        }
//                    })
//                }
//            }
//            
//            
//            // finally save information
//            object.saveInBackground (block: { (success, error) -> Void in
//                if error == nil {
//                    
//                    // send notification wiht name "uploaded"
//                    NotificationCenter.default.post(name: Notification.Name(rawValue: "uploaded"), object: nil)
//                    
//                    // switch to another ViewController at 0 index of tabbar
//                    self.tabBarController!.selectedIndex = 0
//                    
//                    // reset everything
//                    self.viewDidLoad()
//                    self.titleTxt.text = ""
//                }
//            })
//            
//        }
//    
//    // MARK: UICollectionView
//    // return cell size UICollectionViewDelegateFlowLayout
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let numRow: Int = 4
//        let cellWidth:CGFloat = self.view.bounds.width / CGFloat(numRow) - CGFloat(numRow)
//        let cellHeight: CGFloat = CGFloat(120.0)
//        return CGSize(width: cellWidth, height: cellHeight)
//    }
//    
//    // return num items
//    func collectionView(
//        _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.filters.count
//    }
//    
//    // return number of sections
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    // return cell
//    func collectionView(
//        _ collectionView: UICollectionView,
//        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let startTime = getStartTime()
//        
//        guard let cell: FilterCell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: String(describing: FilterCell.self),
//            for: indexPath) as? FilterCell
//            else {
//                fatalError("unexpected cell in collection view")
//        }
//        cell.title.text = self.filters[indexPath.item].name
//        cell.thumbnailImage = self.thumbnailImages[indexPath.item]
//        
//        printElapsedTime(title:"\(indexPath.item)-cell", startTime: startTime)
//        
//        return cell
//    }
//    
//    // cell is selected
//    func collectionView(
//        _ collectionView: UICollectionView,
//        didSelectItemAt indexPath: IndexPath) {
//        self.previewedPhotoIndexPath = indexPath
//        
//        if indexPath.item != 0 {
//            let startTime = getStartTime()
//            
//            self.preview.image = self.applyFilter(
//                at: indexPath.item, image: self.previewImage)
//            
//            printElapsedTime(title:"selected-\(filters[indexPath.item].name)", startTime: startTime)
//        } else {
//            self.preview.image = self.previewImage
//        }
//    }
//    
//    // MARK: Filter
//    func applyFilter(
//        applier: FilterApplierType?, ciImage: CIImage) -> UIImage {
//        let outputImage: CIImage? = applier!(ciImage)
//        
//        let outputCGImage = self.ciContext.createCGImage(
//            (outputImage)!,
//            from: (outputImage?.extent)!)
//        return UIImage(cgImage: outputCGImage!)
//    }
//    
//    func applyFilter(
//        applier: FilterApplierType?, image: UIImage) -> UIImage {
//        let ciImage: CIImage? = CIImage(image: image)
//        return applyFilter(applier: applier, ciImage: ciImage!)
//    }
//    
//    func applyFilter(at: Int, image: UIImage) -> UIImage {
//        let applier: FilterApplierType? = self.filters[at].applier
//        return applyFilter(applier: applier, image: image)
//    }
//}
