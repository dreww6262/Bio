//
//  ContentPagesVC.swift
//  Bio
//
//  Created by Andrew Williamson on 9/28/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class ContentPagesVC: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    let db = Firestore.firestore()
    var currentIndexLabel = UILabel()
    let backImage = UIImage(named: "whiteBack")
    let shareImage = UIImage(named: "whiteShare1")
    let commentImage = UIImage(named: "whiteComment")
    let reportImage = UIImage(named: "elipsis")
    let openAppImage = UIImage(named: "bioBlue")
    var userDataVM: UserDataVM?
    
    var showBool = false
    
    var viewControllers = [UIViewController]()
    var pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    var currentIndex: Int = 0 {
        didSet{
            currentIndexLabel.text = "\(currentIndex + 1)/\(viewControllers.count)"
        }
    }
    
    var hexData: [HexagonStructData?]? {
        didSet {
            viewControllers.removeAll()
            if (hexData != nil) {
                for data in hexData! {
                    if (data != nil) {
                        switch data!.type {
                        case "photo":
                            let vc = ContentImageVC()
                            vc.photoHex = data
                            vc.userDataVM = userDataVM
                            showBool = false
                            vc.showOpenAppButton = false
                            viewControllers.append(vc)
                        case "video":
                            let vc = ContentVideoVC()
                            vc.videoHex = data
                            vc.userDataVM = userDataVM
                            vc.showOpenAppButton = false
                            showBool = false
                            viewControllers.append(vc)
                        case "link":
                            let vc = ContentLinkVC()
                            vc.userDataVM = userDataVM
                            vc.webHex = data
                            vc.showOpenAppButton = false
                            showBool = false
                            viewControllers.append(vc)
                        default:
                            let vc = ContentLinkVC()
                            vc.webHex = data
                            vc.userDataVM = userDataVM
                            vc.showOpenAppButton = true
                            showBool = true
                            viewControllers.append(vc)
                        }
                        //pageView.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
                    }
                    else {
                        print("hexdata list has a nil value")
                    }
                }
            }
        }
    }
    
    //    func presentationCount(for pageViewController: UIPageViewController) -> Int {
    //        return viewControllers.count
    //    }
    //
    //    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    //        return self.currentIndex
    //    }
//    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//
//    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllers.firstIndex(of: viewController) else {
            if currentIndex == -1 {
                return viewControllers.first
            }
            else if currentIndex >= viewControllers.count {
                return viewControllers.last
            }
            else {
                return viewControllers[currentIndex]
            }
        }
        
        let previousIndex  = vcIndex - 1
        
        if previousIndex < 0 {
            return nil
        }
        if previousIndex >= viewControllers.count {
            return nil
        }
        
        print("viewcontroller: \(previousIndex)")
        
        return viewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllers.firstIndex(of: viewController) else {
            if currentIndex == -1 {
                return viewControllers.first
            }
            else if currentIndex >= viewControllers.count {
                return viewControllers.last
            }
            else {
                return viewControllers[currentIndex]
            }
        }
        
        let nextIndex  = vcIndex + 1
        
        if nextIndex >= viewControllers.count {
            return nil
        }
        if nextIndex < 0 {
            return nil
        }
        
        print("viewcontroller: \(nextIndex)")
        
        
        return viewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if (pendingViewControllers.count > 0) {
            guard let vcIndex = viewControllers.firstIndex(of: pendingViewControllers[0]) else {return}
            currentIndex = vcIndex
        }
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            guard let vcIndex = viewControllers.firstIndex(of: previousViewControllers[0]) else {return}
            currentIndex = vcIndex
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("Content Pages userdata: \(userData)")
        
        
        let topBar = UIView()
        view.addSubview(topBar)
        topBar.backgroundColor = .clear
        topBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/11)
        
        let bottomBar = UIView()
        view.addSubview(bottomBar)
        bottomBar.backgroundColor = .clear
        // bottomBar.frame = CGRect(x: 0, y: self.view.frame.height*(14/15), width: view.frame.width, height: self.view.frame.height/15)
        // hide Bottom bar by pushing it off screen
        bottomBar.frame = CGRect(x: 0, y: self.view.frame.height*(15/15), width: view.frame.width, height: self.view.frame.height/15)
        
        let backButton = UIButton()
        topBar.addSubview(backButton)
        backButton.imageView?.image?.withTintColor(.white)
        backButton.tintColor = .white
        backButton.imageView?.tintColor = white
        //  backButton.imageView.col
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        backButton.addGestureRecognizer(backTap)
        //backButton.sizeToFit()
        backButton.frame = CGRect(x: 5, y: topBar.frame.maxY - 34, width: 34, height: 34)
        //  backButton.frame = CGRect(x: 5, y: (topBar.frame.height - 34)/2, width: 34, height: 34)
        backButton.setBackgroundImage(UIImage(named:"whiteChevron"), for: .normal)
        
        topBar.addSubview(currentIndexLabel)
        currentIndexLabel.frame = CGRect(x: (view.frame.width/2) - 40, y: topBar.frame.maxY - 30, width: 80, height: 25)
        currentIndexLabel.text = "\(currentIndex + 1)/\(viewControllers.count)"
        currentIndexLabel.textColor = white
        currentIndexLabel.font.withSize(25)
        currentIndexLabel.textAlignment = .center
        
        let commentButton = UIButton()
        //bottomBar.addSubview(commentButton)
        commentButton.setTitleColor(.white, for: .normal)
        commentButton.backgroundColor = .clear
        commentButton.imageView?.image?.withTintColor(.white)
        //    commentButton.setTitle("Comment", for: .normal)
        
        commentButton.tintColor = .white
        commentButton.imageView?.tintColor = white
        //  backButton.imageView.col
        // let commentTap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        // commentButton.addGestureRecognizer(backTap)
        commentButton.sizeToFit()
        //1
        commentButton.frame = CGRect(x:5, y: bottomBar.frame.height/4, width: bottomBar.frame.height/2, height: bottomBar.frame.height/2)
        commentButton.imageView?.frame = commentButton.frame
        commentButton.imageView?.image = commentImage
        var spacingForButton = bottomBar.frame.height/4
        
        let shareButton = UIButton()
        //bottomBar.addSubview(shareButton)
        bottomBar.backgroundColor = .black
        //view.bringSubviewToFront(bottomBar)
        bottomBar.bringSubviewToFront(commentButton)
        // bottomBar.isHidden = true
        
        
        print("This is bottm bar frame \(bottomBar.frame) and view.frame \(view.frame)")
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.backgroundColor = .clear
        shareButton.imageView?.image?.withTintColor(.white)
        // shareButton.setTitle("Share", for: .normal)
        
        shareButton.tintColor = .white
        shareButton.imageView?.tintColor = white
        //  backButton.imageView.col
        //    let shareTap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        //shareButton.addGestureRecognizer(backTap)
        shareButton.sizeToFit()
        //1
        shareButton.frame = CGRect(x: commentButton.frame.maxX + spacingForButton, y: bottomBar.frame.height/4, width: bottomBar.frame.height/2, height: bottomBar.frame.height/2)
        shareButton.imageView?.frame = shareButton.frame
        shareButton.imageView?.image = shareImage
        bottomBar.bringSubviewToFront(shareButton)
        
        if userDataVM?.userData.value?.publicID != hexData?[0]?.postingUserID {
            let reportButton = UIButton()
            topBar.addSubview(reportButton)
            reportButton.setTitleColor(.white, for: .normal)
            reportButton.backgroundColor = .clear
            reportButton.imageView?.image?.withTintColor(.white)
            reportButton.isUserInteractionEnabled = true
            let reportTapped = UITapGestureRecognizer(target: self, action: #selector(reportButtonPressed))
            reportButton.addGestureRecognizer(reportTapped)
            reportButton.tintColor = .white
            reportButton.imageView?.tintColor = white
            reportButton.sizeToFit()
            reportButton.setBackgroundImage(UIImage(named: "whiteDots"), for: .normal)
            reportButton.frame = CGRect(x: self.view.frame.width-30, y: (topBar.frame.maxY) -  30, width: 25, height: 25)
        }
        else {
            let crudButton = UIButton()
            topBar.addSubview(crudButton)
            crudButton.setTitleColor(.white, for: .normal)
            crudButton.backgroundColor = .clear
            crudButton.imageView?.image?.withTintColor(.white)
            crudButton.isUserInteractionEnabled = true
            let crudTapped = UITapGestureRecognizer(target: self, action: #selector(crudButtonPressed))
            crudButton.addGestureRecognizer(crudTapped)
            crudButton.tintColor = .white
            crudButton.imageView?.tintColor = white
            crudButton.sizeToFit()
            crudButton.setBackgroundImage(UIImage(named: "whiteDots"), for: .normal)
            crudButton.frame = CGRect(x: self.view.frame.width-30, y: (topBar.frame.maxY) -  30, width: 25, height: 25)
        }
        
        
        commentButton.setBackgroundImage(UIImage(named: "whiteComment"), for: .normal)
        shareButton.setBackgroundImage(UIImage(named: "whiteDots"), for: .normal)
        
        let goToAppButton = UIButton()
        bottomBar.addSubview(goToAppButton)
        
        if showBool == true {
            goToAppButton.isHidden = false
        }
        else {
            goToAppButton.isHidden = true
        }
        
        
        let openInAppWidth = (7/4)*bottomBar.frame.height
        goToAppButton.setTitle("Open App", for: .normal)
        goToAppButton.sizeToFit()
        goToAppButton.frame = CGRect(x: (bottomBar.frame.width/2)-((openInAppWidth + 8)/2), y: bottomBar.frame.height/2 - (goToAppButton.frame.height + 3) / 2, width: goToAppButton.frame.width + 8, height: goToAppButton.frame.height + 3)
        
        //  goToAppButton.setBackgroundImage(UIImage(named: "bioBlue"), for: .normal)
        goToAppButton.backgroundColor = .clear
        
        goToAppButton.setTitleColor(.white, for: .normal)
        goToAppButton.titleLabel?.textAlignment = .center
        goToAppButton.layer.cornerRadius = goToAppButton.frame.width/20
        goToAppButton.layer.borderWidth = 0.4
        goToAppButton.layer.borderColor = white.cgColor
        
        
        
        //        pageView.view.frame = CGRect(x: 0, y: topBar.frame.maxY, width: view.frame.width, height: view.frame.height - topBar.frame.height - bottomBar.frame.height)
        //adjust height for removing bottom bar
        
        pageView.view.frame = CGRect(x: 0, y: topBar.frame.maxY, width: view.frame.width, height: view.frame.height - topBar.frame.height)
        
        addChild(pageView)
        view.addSubview(pageView.view)
        pageView.didMove(toParent: self)
        
        pageView.dataSource = self
        pageView.delegate = self
        view.backgroundColor = .black
        pageView.view.backgroundColor = .clear
        // pageView.presentationController.
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for v in view.subviews {
            v.isHidden = false
        }
        pageView.dataSource = nil
        pageView.dataSource = self
        
        if (currentIndex < viewControllers.count && currentIndex >= 0) {
            let currentVC = viewControllers[currentIndex]
            pageView.setViewControllers([currentVC], direction: .forward, animated: false, completion: nil)
        }
        else if (viewControllers.first != nil) {
            pageView.setViewControllers([viewControllers.first!], direction: .forward, animated: false, completion: nil)
            currentIndex = 0
        }
    }
    
    //    func createContextMenu() -> UIMenu {
    //    let shareAction = UIAction(title: "Copy Link", image: UIImage(systemName: "square.and.arrow.up")) { _ in
    //    print("Copy Link")
    //    }
    //    let copy = UIAction(title: "Report", image: UIImage(named: "whiteShield")) { _ in
    //    print("Report")
    //        let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "reportVC") as! ReportAPostVC
    //        let currentVC = self.viewControllers[self.currentIndex]
    //        if currentVC is ContentLinkVC {
    //            let linkVC = currentVC as! ContentLinkVC
    //            reportVC.hexData = linkVC.webHex
    //        }
    //        else if currentVC is ContentImageVC {
    //            let imageVC = currentVC as! ContentImageVC
    //            reportVC.hexData = imageVC.photoHex
    //        }
    //        else if currentVC is ContentVideoVC {
    //            let videoVC = currentVC as! ContentVideoVC
    //            reportVC.hexData = videoVC.videoHex
    //        }
    //        self.present(reportVC, animated: false, completion: nil)
    //    }
    ////    let saveToPhotos = UIAction(title: "Cancel", image: UIImage(systemName: "photo")) { _ in
    ////    print("Save to Photos")
    ////    }
    //    let cancelAction = UIAction(title: "Cancel", image: .none, attributes: .destructive) { action in
    //             // Delete this photo 😢
    //         }
    //
    //    return UIMenu(title: "", children: [shareAction, copy, cancelAction])
    //    }
    
    //    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    //    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
    //    return self.createContextMenu()
    //        }
    //    }
    
    func copyTextToResource() {
        let pasteboard = UIPasteboard.general
        let currentVC = viewControllers[currentIndex]
        if currentVC is ContentLinkVC {
            let linkVC = currentVC as! ContentLinkVC
            pasteboard.string = linkVC.webHex?.resource
        }
    }
    
    func editMusicPost() {
            let currentVC = viewControllers[currentIndex] as! ContentLinkVC
            let hex = currentVC.webHex
            let onePostPreviewVC = self.storyboard?.instantiateViewController(identifier: "editMusicPostVC") as! EditMusicPostVC
            onePostPreviewVC.userDataVM = self.userDataVM
            onePostPreviewVC.hexData = hex
            print("This is hex \(hex)")
        let cleanRef = hex!.thumbResource.replacingOccurrences(of: "/", with: "%2F")
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
            onePostPreviewVC.linkHexagonImage.sd_setImage(with: url!, completed: {_, error, _, _ in
                if error != nil {
                    print(error!.localizedDescription)
                }
            })
            onePostPreviewVC.linkHexagonImageCopy.sd_setImage(with: url!, completed: {_, error, _, _ in
                if error != nil {
                    print(error!.localizedDescription)
                }
            })
            var entireMusicString = hex!.resource
            var artistSongString = hex!.resource.chopPrefix(21)
            print("This is artistSongString \(artistSongString)")
            var artistSongComponents = artistSongString.components(separatedBy: "/")
            var artist = artistSongComponents[0] as! String
            var song = artistSongComponents[1] as! String
            var finalArist = artist.replacingOccurrences(of: "-", with: " ")
            var finalSong = song.replacingOccurrences(of: "-", with: " ")
            print("final artist \(finalArist)")
        print("final song \(finalSong)")
            onePostPreviewVC.captionTextField.text = hex!.text
            onePostPreviewVC.textOverlayTextField.text = hex!.coverText
            onePostPreviewVC.captionString = hex!.text
            onePostPreviewVC.textOverlayString = hex!.coverText
            onePostPreviewVC.linkTextField.text = finalArist
            onePostPreviewVC.songNameTextField.text = finalSong
            var isPrioritized = currentVC.webHex?.isPrioritized ?? false
            onePostPreviewVC.checkBoxStatus = isPrioritized
            if isPrioritized {
                onePostPreviewVC.checkBox.setImage(UIImage(named: "check-2"), for: .normal)
            }
            
         //   onePostPreviewVC.items
         //   picker.present(onePostPreviewVC, animated: false, completion: nil)
            present(onePostPreviewVC, animated: false,completion: nil)
            onePostPreviewVC.modalPresentationStyle = .fullScreen
        }
    
    func editPost() {
        let currentVC = viewControllers[currentIndex]
        if currentVC is ContentLinkVC {
            let linkVC = currentVC as! ContentLinkVC
            print("Go to add Link Post and feed current info")
        }
        else if currentVC is ContentVideoVC {
            let linkVC = currentVC as! ContentVideoVC
            print("Go to One Post Preview and feed currrent info")
        }
        else if currentVC is ContentImageVC {
            let linkVC = currentVC as! ContentImageVC
            print("Go to One Post Preview and feed currrent info")
        }
        print("To:Do an else if for music")
    }
    
    func editLinkPost() {
        let currentVC = viewControllers[currentIndex] as! ContentLinkVC
        let hex = currentVC.webHex
        let onePostPreviewVC = self.storyboard?.instantiateViewController(identifier: "editLinkPostVC") as! EditLinkPostVC
        onePostPreviewVC.userDataVM = userDataVM
        onePostPreviewVC.hexData = hex
        print("This is hex \(hex)")
        let cleanRef = hex!.thumbResource.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        onePostPreviewVC.linkHexagonImage.sd_setImage(with: url!, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
        onePostPreviewVC.linkHexagonImageCopy.sd_setImage(with: url!, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
        onePostPreviewVC.captionTextField.text = hex!.text
        onePostPreviewVC.textOverlayTextField.text = hex!.coverText
        onePostPreviewVC.captionString = hex!.text
        onePostPreviewVC.textOverlayString = hex!.coverText
        onePostPreviewVC.linkTextField.text = hex!.resource
        var isPrioritized = currentVC.webHex?.isPrioritized ?? false
        onePostPreviewVC.checkBoxStatus = isPrioritized
        if isPrioritized {
            onePostPreviewVC.checkBox.setImage(UIImage(named: "check-3"), for: .normal)
        }
        
        //   onePostPreviewVC.items
        //   picker.present(onePostPreviewVC, animated: false, completion: nil)
        present(onePostPreviewVC, animated: false,completion: nil)
        onePostPreviewVC.modalPresentationStyle = .fullScreen
    }
    
    func editPhotoPost() {
        let currentVC = viewControllers[currentIndex] as! ContentImageVC
        let hex = currentVC.photoHex
        let onePostPreviewVC = self.storyboard?.instantiateViewController(identifier: "editPhotoPostVC") as! EditPhotoPostVC
        onePostPreviewVC.userDataVM = userDataVM
        onePostPreviewVC.hexData = hex
        print("This is hex \(hex)")
        let cleanRef = hex!.thumbResource.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        onePostPreviewVC.previewImage.sd_setImage(with: url!, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
        onePostPreviewVC.linkHexagonImageCopy.sd_setImage(with: url!, completed: {_, error, _, _ in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                })
        onePostPreviewVC.captionTextField.text = hex!.text
        onePostPreviewVC.textOverlayTextField.text = hex!.coverText
        onePostPreviewVC.captionString = hex!.text
        onePostPreviewVC.textOverlayString = hex!.coverText
        var isPrioritized = currentVC.photoHex?.isPrioritized ?? false
        onePostPreviewVC.checkBoxStatus = isPrioritized
        if isPrioritized {
            onePostPreviewVC.checkBox.setImage(UIImage(named: "check-3"), for: .normal)
        }
        
        //   onePostPreviewVC.items
        //   picker.present(onePostPreviewVC, animated: false, completion: nil)
        present(onePostPreviewVC, animated: false,completion: nil)
        onePostPreviewVC.modalPresentationStyle = .fullScreen
    }
    
    func prioritizeThisPost() {
        let currentVC = viewControllers[currentIndex]
        if currentVC is ContentLinkVC {
            let linkVC = currentVC as! ContentLinkVC
            linkVC.webHex?.isPrioritized = true
            db.collection("Hexagons2").document(linkVC.webHex!.docID).setData(linkVC.webHex!.dictionary)
        }
        else if currentVC is ContentVideoVC {
            let linkVC = currentVC as! ContentVideoVC
            linkVC.videoHex?.isPrioritized = true
            db.collection("Hexagons2").document(linkVC.videoHex!.docID).setData(linkVC.videoHex!.dictionary)
        }
        else if currentVC is ContentImageVC {
            let linkVC = currentVC as! ContentImageVC
            linkVC.photoHex?.isPrioritized = true
            db.collection("Hexagons2").document(linkVC.photoHex!.docID).setData(linkVC.photoHex!.dictionary)
        }
    }
    
    @objc func backTapped(_ sender: UITapGestureRecognizer) {
        print("back hit!")
        for v in view.subviews {
            v.isHidden = true
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func reportButtonPressed(_ sender: UITapGestureRecognizer) {
        print("More tapped")
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Copy Link", style: .default , handler:{ (UIAlertAction)in
            print("User click Copy Link button")
            self.copyTextToResource()
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "Report Post", style: .default , handler:{ (UIAlertAction)in
            print("User click Report button")
            let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "reportVC") as! ReportAPostVC
            reportVC.userDataVM = self.userDataVM
            let currentVC = self.viewControllers[self.currentIndex]
            if currentVC is ContentLinkVC {
                let linkVC = currentVC as! ContentLinkVC
                reportVC.hexData = linkVC.webHex
                reportVC.userDataVM = self.userDataVM
            }
            else if currentVC is ContentImageVC {
                let imageVC = currentVC as! ContentImageVC
                reportVC.hexData = imageVC.photoHex
                reportVC.userDataVM = self.userDataVM
            }
            else if currentVC is ContentVideoVC {
                let videoVC = currentVC as! ContentVideoVC
                reportVC.hexData = videoVC.videoHex
                reportVC.userDataVM = self.userDataVM
            }
            self.present(reportVC, animated: false, completion: nil)
            
        }))
        
        //        let prioritize = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    @objc func crudButtonPressed(_ sender: UITapGestureRecognizer) {
        print("More tapped crud")
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Copy Link", style: .default , handler:{ (UIAlertAction)in
            print("User click Copy Link button")
            self.copyTextToResource()
        }))
        
        alert.addAction(UIAlertAction(title: "Edit Post", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit Post")
            self.editLinkPost()
            //    self.copyTextToResource()
        }))
        
        
        alert.addAction(UIAlertAction(title: "Prioritize This Post", style: .default , handler:{ (UIAlertAction)in
            print("User click Prioritize button")
            self.prioritizeThisPost()
        }))
        
        alert.addAction(UIAlertAction(title: "Delete This Post", style: .default, handler:  { (UIAlertAction)in
            
            let sureAlert = UIAlertController(title: "Are you sure you want to delete this post?", message: "It cannot be undone", preferredStyle: .alert)
            
            sureAlert.addAction(UIKit.UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                let currentVC = self.viewControllers[self.currentIndex]
                if currentVC is ContentLinkVC {
                    let linkVC = currentVC as! ContentLinkVC
                    linkVC.webHex?.isArchived = true
                    self.db.collection("Hexagons2").document(linkVC.webHex!.docID).setData(linkVC.webHex!.dictionary)
                }
                else if currentVC is ContentImageVC {
                    let imageVC = currentVC as! ContentImageVC
                    imageVC.photoHex?.isArchived = true
                    self.db.collection("Hexagons2").document(imageVC.photoHex!.docID).setData(imageVC.photoHex!.dictionary)
                }
                else if currentVC is ContentVideoVC {
                    let videoVC = currentVC as! ContentVideoVC
                    videoVC.videoHex?.isArchived = true
                    self.db.collection("Hexagons2").document(videoVC.videoHex!.docID).setData(videoVC.videoHex!.dictionary)
                }
                self.viewControllers.remove(at: self.currentIndex)
                if self.currentIndex == self.viewControllers.count {
                    self.currentIndex -= 1
                }
                if (self.currentIndex == -1 || self.viewControllers.count == 0) {
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    self.pageView.setViewControllers([self.viewControllers[self.currentIndex]], direction: .forward, animated: false, completion: nil)
                    self.pageViewController(self.pageView, didFinishAnimating: true, previousViewControllers: [self.viewControllers[self.currentIndex]], transitionCompleted: true)
                }
            }))
            
            sureAlert.addAction(UIKit.UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(sureAlert, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
}
