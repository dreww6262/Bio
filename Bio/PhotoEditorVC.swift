
//
//  PhotoEditorVC.swift
//  Bio
//
//  Created by Ann McDonough on 8/6/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import Foundation
import UIKit
import Photos
import PhotosUI
import CoreImage
//import CIFilterImage


class PhotoEditorVC:
    UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
    {
    var thumbnailImage: CIImage!
    var thumbnailImages: [UIImage] = []
    var previewImage: UIImage!
    var previewedPhotoIndexPath: IndexPath!
    var ciContext = CIContext(options: nil)
    
    let filters: [(name: String, applier: FilterApplierType?)] = [
        (name: "Normal",
         applier: nil),
        (name: "Nashville",
         applier: ImageHelper.applyNashvilleFilter),
        (name: "Toaster",
         applier: ImageHelper.applyToasterFilter),
        (name: "1977",
         applier: ImageHelper.apply1977Filter),
        (name: "Clarendon",
         applier: ImageHelper.applyClarendonFilter),
        (name: "HazeRemoval",
         applier: ImageHelper.applyHazeRemovalFilter),
        (name: "Chrome",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectChrome")),
        (name: "Fade",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectFade")),
        (name: "Instant",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectInstant")),
        (name: "Mono",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectMono")),
        (name: "Noir",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectNoir")),
        (name: "Process",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectProcess")),
        (name: "Tonal",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectTonal")),
        (name: "Transfer",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectTransfer")),
        (name: "Tone",
         applier: ImageHelper.createDefaultFilterApplier(name: "CILinearToSRGBToneCurve")),
        (name: "Linear",
         applier: ImageHelper.createDefaultFilterApplier(name: "CISRGBToneCurveToLinear")),
    ]
    
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet var filterCollection: UICollectionView!

    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: preview.bounds.width * scale,
                      height: preview.bounds.height * scale)
    }

    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
   //     let startTime = getStartTime()
        loadButton()
        
        
        
        self.preview.image = self.previewImage
        self.thumbnailImages = filters.map({ (name, applier) -> UIImage in
      //      let startTime = getStartTime()
            
            if applier == nil {
                return UIImage(ciImage: self.thumbnailImage)
            }
            let uiImage = self.applyFilter(
                applier: applier,
                ciImage: self.thumbnailImage)
            
      //      printElapsedTime(title:"viewDidLoad\(name)", startTime: startTime)
            
            return uiImage
        })
        
//        printElapsedTime(title: "viewDidload", startTime: startTime)
    }
    
    
    
    
    
    func loadButton() {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    button.center = view.center
    button.setTitle("ShowFilter", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped)))
    view.addSubview(button)
    }
    
        @objc func buttonTapped(_ sender: Any) {
//            let vc = CIFilterViewController()
//            vc.image = UIImage(named: "k14")
//            vc.backgroundColor = .white
//            vc.textColor = .black
//            vc.delegate = self
//            present(vc, animated: true, completion: nil)
        }
    
    deinit {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: UICollectionView
    // return cell size UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numRow: Int = 4
        let cellWidth:CGFloat = self.view.bounds.width / CGFloat(numRow) - CGFloat(numRow)
        let cellHeight: CGFloat = CGFloat(120.0)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // return num items
    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters.count
    }
    
    // return number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // return cell
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let startTime = getStartTime()
        
        guard let cell: FilterCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: FilterCell.self),
            for: indexPath) as? FilterCell
            else {
                fatalError("unexpected cell in collection view")
        }
        cell.title.text = self.filters[indexPath.item].name
        cell.thumbnailImage = self.thumbnailImages[indexPath.item]
        
   //     printElapsedTime(title:"\(indexPath.item)-cell", startTime: startTime)
        
        return cell
    }
    
    // cell is selected
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        self.previewedPhotoIndexPath = indexPath
        
        if indexPath.item != 0 {
//            let startTime = getStartTime()
            
            self.preview.image = self.applyFilter(
                at: indexPath.item, image: self.previewImage)
            
 //           printElapsedTime(title:"selected-\(filters[indexPath.item].name)", startTime: startTime)
        } else {
            self.preview.image = self.previewImage
        }
    }
    
    // MARK: Filter
    func applyFilter(
        applier: FilterApplierType?, ciImage: CIImage) -> UIImage {
        let outputImage: CIImage? = applier!(ciImage)
        
        let outputCGImage = self.ciContext.createCGImage(
            (outputImage)!,
            from: (outputImage?.extent)!)
        return UIImage(cgImage: outputCGImage!)
    }
    
    func applyFilter(
        applier: FilterApplierType?, image: UIImage) -> UIImage {
        let ciImage: CIImage? = CIImage(image: image)
        return applyFilter(applier: applier, ciImage: ciImage!)
    }
    
    func applyFilter(at: Int, image: UIImage) -> UIImage {
        let applier: FilterApplierType? = self.filters[at].applier
        return applyFilter(applier: applier, image: image)
    }
}

//extension ViewController: CIFilterViewControllerDelegate {
//    func didFinish(_ image: UIImage) {
//        print("image", image)
//        let imageView = UIImageView(image: image)
//        imageView.contentMode = .scaleAspectFit
//        imageView.frame = CGRect(x: 0, y: 60, width: 200, height: 200)
//        imageView.center.x = view.center.x
//        view.addSubview(imageView)
//    }
//
//    func didCancel() {
//        print("did Cancel")
//    }
//}
