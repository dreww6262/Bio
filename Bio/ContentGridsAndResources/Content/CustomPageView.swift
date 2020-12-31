//
//  CustomPageView.swift
//  Bio
//
//  Created by Andrew Williamson on 12/10/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Firebase

class CustomPageView: UIViewController {
    var userDataVM: UserDataVM?
    var viewControllers = [UIViewController]()
    var currentIndex: Int?
    var currentPostingUserID = ""
    var visibleVCs: [UIViewController?] = [nil, nil, nil]
    
    var showBool = false
    
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
//                            vc.viewDidLoad()
                            viewControllers.append(vc)
                        case "pin_birthday":
                            let vc = ContentBirthdayVC()
                            vc.userDataVM = userDataVM
                            vc.birthdayHex = data
                            vc.showOpenAppButton = false
                            showBool = false
//                            vc.viewDidLoad()
                            viewControllers.append(vc)
                        case "pin_phone":
                            let vc = ContentPhoneVC()
                            vc.userDataVM = userDataVM
                            vc.currentPostingUserID = currentPostingUserID
                            vc.birthdayHex = data
                            vc.showOpenAppButton = false
                            showBool = false
//                            vc.viewDidLoad()
                            viewControllers.append(vc)
                        case "pin_country":
                            let vc = ContentCulturalVC()
                            vc.userDataVM = userDataVM
                            vc.cultureHex = data
                            vc.showOpenAppButton = false
                            showBool = false
//                            vc.viewDidLoad()
                            viewControllers.append(vc)
                        case "pin_relationship":
                            let vc = ContentRelationship()
                            vc.userDataVM = userDataVM
                            vc.relationshipHex = data
                            vc.showOpenAppButton = false
                            showBool = false
//                            vc.viewDidLoad()
                            viewControllers.append(vc)
                        case "pin_city":
                            let vc = ContentCityVC()
                            vc.userDataVM = userDataVM
                            vc.cityHex = data
                            vc.showOpenAppButton = false
                            showBool = false
//                            vc.viewDidLoad()
                            viewControllers.append(vc)
                        default:
                            let vc = ContentLinkVC()
                            vc.webHex = data
                            vc.userDataVM = userDataVM
                            vc.showOpenAppButton = true
                            showBool = true
//                            vc.viewDidLoad()
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
    
    private var leftBox = CGRect()
    private var rightBox = CGRect()
    private var centerBox = CGRect()
    
    let caption = UILabel()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBoxes()
        
      //  view.backgroundColor = .systemGray6
     //   view.backgroundColor = .darkGray
        view.backgroundColor = .black
        
        if currentIndex == nil {
            if (!setPresentedViewControllers(vcIndex: 0)) {
                return
            }
        }
        
        view.addSubview(caption)
        caption.frame = CGRect(x: centerBox.minX, y: centerBox.minY - 96, width: centerBox.width, height: 80)
        
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            caption.textColor = .black
            caption.textColor = .white
        case .dark:
            caption.textColor = .white
        }
        
        caption.font = UIFont(name: "Poppins-SemiBold", size: 16)
        caption.textAlignment = .center
        //caption.backgroundColor = .white
        caption.numberOfLines = 0
        
        setPositions()
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeHorizontally))
        swipeLeftGesture.direction = .left
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeHorizontally))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeLeftGesture)
        view.addGestureRecognizer(swipeRightGesture)
        
        
        let returnButton = UIButton(frame: CGRect(x: view.frame.width/2-40, y: view.frame.height-112, width: 80, height: 80))
        view.addSubview(returnButton)
        returnButton.setImage(UIImage(named: "cancel2"), for: .normal)
        returnButton.layer.cornerRadius = returnButton.frame.size.width / 2
        //returnButton.setBackgroundImage(UIImage(named: "cancel11"), for: .normal)
        returnButton.clipsToBounds = true
        returnButton.tintColor = .white
        returnButton.backgroundColor = .clear
        
        let returnTap = UITapGestureRecognizer(target: self, action: #selector(returnTapped))
        returnButton.addGestureRecognizer(returnTap)
        
        
        if userDataVM?.userData.value?.publicID != hexData?[0]?.postingUserID {
            let reportButton = UIButton()
            view.addSubview(reportButton)
            reportButton.setTitleColor(.white, for: .normal)
            reportButton.backgroundColor = .clear
            reportButton.imageView?.image?.withTintColor(.white)
            reportButton.isUserInteractionEnabled = true
            let reportTapped = UITapGestureRecognizer(target: self, action: #selector(reportButtonPressed))
            reportButton.addGestureRecognizer(reportTapped)
            reportButton.tintColor = .white
            reportButton.imageView?.tintColor = white
            reportButton.sizeToFit()
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                reportButton.setBackgroundImage(UIImage(named: "more"), for: .normal)
            //    reportButton.tintColor = .white
            case .dark:
                reportButton.setBackgroundImage(UIImage(named: "whiteDots"), for: .normal)
            }
            reportButton.frame = CGRect(x: self.view.frame.width-45, y: (centerBox.minY - 25)/2, width: 25, height: 25)
            
        }
        else {
            let crudButton = UIButton()
            view.addSubview(crudButton)
            crudButton.setTitleColor(.white, for: .normal)
            crudButton.backgroundColor = .clear
            crudButton.imageView?.image?.withTintColor(.black)
            crudButton.isUserInteractionEnabled = true
            let crudTapped = UITapGestureRecognizer(target: self, action: #selector(crudButtonPressed))
            crudButton.addGestureRecognizer(crudTapped)
            crudButton.tintColor = .white
            crudButton.imageView?.tintColor = white
            crudButton.sizeToFit()
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                crudButton.setBackgroundImage(UIImage(named: "more"), for: .normal)
            case .dark:
                crudButton.setBackgroundImage(UIImage(named: "whiteDots"), for: .normal)
            }
            crudButton.frame = CGRect(x: self.view.frame.width-45, y: (centerBox.minY - 25)/2, width: 25, height: 25)
        }
    }
    
    private func setBoxes() {
        let smallWidth = 7/12 * self.view.frame.width
        let smallHeight = 7/12 * self.view.frame.height
        leftBox = CGRect(x: -1/2 * self.view.frame.width, y: self.view.frame.midY - smallHeight / 2, width: smallWidth, height: smallHeight)
        rightBox = CGRect(x: 11/12 * self.view.frame.width, y: leftBox.minY, width: smallWidth, height: smallHeight)
        
        let largeWidth = view.frame.width * 3/4
        let largeHeight = view.frame.height * 5/8
        
        centerBox = CGRect(x: view.frame.midX - largeWidth / 2, y: view.frame.midY - largeHeight / 2, width: largeWidth, height: largeHeight)
    }
    
    
    func expandCurrentVC() {
        
    }
    
    func setPresentedViewControllers(vcIndex: Int) -> Bool {
        if viewControllers.isEmpty {
            return false
        }
        else if vcIndex < 0 {
            return false
        }
        else if vcIndex > viewControllers.count {
            return false
        }
        
        currentIndex = vcIndex
        
        for vc in visibleVCs {
            vc?.view.removeFromSuperview()
            vc?.removeFromParent()
        }
        visibleVCs = [nil, nil, nil]
        
        
        if vcIndex != 0 && vcIndex + 1 < viewControllers.count {
            visibleVCs = [viewControllers[vcIndex], viewControllers[vcIndex - 1], viewControllers[vcIndex + 1]]
        }
        else if vcIndex != 0 {
            visibleVCs = [viewControllers[vcIndex], viewControllers[vcIndex - 1], nil]
        }
        else if vcIndex + 1 < viewControllers.count {
            visibleVCs = [viewControllers[vcIndex], nil, viewControllers[vcIndex + 1]]
        }
        else {
            visibleVCs = [viewControllers[vcIndex], nil, nil]
        }
        
        for vc in visibleVCs {
            if vc == nil {
                continue
            }
            addChild(vc!)
            view.addSubview(vc!.view)
            vc!.view.layer.cornerRadius = vc!.view.frame.width / 20
            vc!.view.clipsToBounds = true
        }
        
        setPositions()
        
        return true
    }
    
    func setPositions() {
        
        var text = ""
        
        switch visibleVCs[0] {
            case (is ContentLinkVC):
                let linkVC = visibleVCs[0] as! ContentLinkVC
                text = linkVC.webHex?.text ?? ""
                
            case (is ContentImageVC):
                let imageVC = visibleVCs[0] as! ContentImageVC
                text = imageVC.photoHex?.text ?? ""
        
        case (is ContentCityVC):
            let imageVC = visibleVCs[0] as! ContentCityVC
            text = imageVC.cityHex?.text ?? ""
        case (is ContentBirthdayVC):
            let imageVC = visibleVCs[0] as! ContentBirthdayVC
            text = imageVC.birthdayHex?.text ?? ""
        case (is ContentRelationship):
            let imageVC = visibleVCs[0] as! ContentRelationship
            text = imageVC.relationshipHex?.text ?? ""
        case (is ContentCulturalVC):
            let imageVC = visibleVCs[0] as! ContentCulturalVC
            text = imageVC.cultureHex?.text ?? ""
        case (is ContentPhoneVC):
            let imageVC = visibleVCs[0] as! ContentPhoneVC
            text = imageVC.birthdayHex?.text ?? ""
                
            default:
                let videoVC = visibleVCs[0] as! ContentVideoVC
                text = videoVC.videoHex?.text ?? ""
        }
        
        caption.text = text
        
        visibleVCs[0]?.view.clipsToBounds = true
        visibleVCs[1]?.view.clipsToBounds = true
        visibleVCs[2]?.view.clipsToBounds = true
        
        visibleVCs[0]?.view.isUserInteractionEnabled = true
        visibleVCs[1]?.view.isUserInteractionEnabled = false
        visibleVCs[2]?.view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.25, animations:  {
            self.visibleVCs[0]?.view.frame = CGRect(x: self.centerBox.minX, y: self.centerBox.minY, width: self.centerBox.width, height: self.centerBox.height)
            self.visibleVCs[1]?.view.frame = CGRect(x: self.leftBox.minX, y: self.leftBox.minY, width: self.leftBox.width, height: self.leftBox.height)
            self.visibleVCs[2]?.view.frame = CGRect(x: self.rightBox.minX, y: self.rightBox.minY, width: self.rightBox.width, height: self.rightBox.height)
        })
    }
    func moveLeft() {
        if currentIndex! <= 0 {
            return
        }
        currentIndex! -= 1
        popRight(vc: visibleVCs[2])
        let vc = fetchLeft()
        visibleVCs[2] = visibleVCs[0]
        visibleVCs[0] = visibleVCs[1]
        visibleVCs[1] = vc
        setPositions()
        
    }
    
    
    func moveRight() {
        if currentIndex! >= viewControllers.count - 1 {
            return
        }
        currentIndex! += 1
        popLeft(vc: visibleVCs[1])
        let vc = fetchRight()
        visibleVCs[1] = visibleVCs[0]
        visibleVCs[0] = visibleVCs[2]
        visibleVCs[2] = vc
        setPositions()
        
    }
    
    func popLeft(vc: UIViewController?) {
        UIView.animate(withDuration: 0.25, animations: {
            vc?.view.frame = CGRect(x: self.leftBox.minX - self.leftBox.width, y: self.leftBox.minY, width: self.leftBox.width, height: self.leftBox.height)
        }, completion: { _ in
            vc?.view.removeFromSuperview()
            vc?.removeFromParent()
        })
        
    }
    
    func popRight(vc: UIViewController?) {
        UIView.animate(withDuration: 0.25, animations: {
            vc?.view.frame = CGRect(x: self.rightBox.maxX, y: self.rightBox.minY, width: self.rightBox.width, height: self.rightBox.height)
        }, completion: { _ in
            vc?.view.removeFromSuperview()
            vc?.removeFromParent()
        })
        
    }
    
    func fetchLeft() -> UIViewController? {
        if currentIndex == nil || currentIndex! <= 0 || currentIndex! - 1 >= viewControllers.count {
            return nil
        }
        
        let vc = viewControllers[currentIndex! - 1]
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.frame = CGRect(x: leftBox.minX - leftBox.width, y: leftBox.minY, width: leftBox.width, height: leftBox.height)
        vc.view.layer.cornerRadius = vc.view.frame.width / 20
        vc.view.clipsToBounds = true
        
        if currentIndex! - 2 >= 0 {
            viewControllers[currentIndex! - 2].viewDidLoad()
            if currentIndex! - 3 >= 0 {
                viewControllers[currentIndex! - 3].viewDidLoad()
            }
        }
        
        return vc
    }
    
    func fetchRight() -> UIViewController? {
        if currentIndex == nil || currentIndex! + 1 < 0 || currentIndex! + 1 >= viewControllers.count {
            return nil
        }
        let vc = viewControllers[currentIndex! + 1]
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.frame = CGRect(x: rightBox.maxX, y: rightBox.minY, width: rightBox.width, height: rightBox.height)
        vc.view.layer.cornerRadius = vc.view.frame.width / 20
        vc.view.clipsToBounds = true
        
        if currentIndex! + 2 < viewControllers.count {
            viewControllers[currentIndex! + 2].viewDidLoad()
            if currentIndex! + 3 < viewControllers.count {
                viewControllers[currentIndex! + 3].viewDidLoad()
            }
        }
        
        return vc
    }
    
    @objc func swipeHorizontally(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            moveRight()
        }
        
        else if sender.direction == .right {
            moveLeft()
        }
    }
    
    @objc func returnTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func prioritizeThisPost() {
        let currentVC = viewControllers[currentIndex!]
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
    
    func copyTextToResource() {
        let pasteboard = UIPasteboard.general
        let currentVC = viewControllers[currentIndex!]
        if currentVC is ContentLinkVC {
            let linkVC = currentVC as! ContentLinkVC
            pasteboard.string = linkVC.webHex?.resource
        }
    }
    
    func editMusicPost() {
            let currentVC = viewControllers[currentIndex!] as! ContentLinkVC
            let hex = currentVC.webHex
            let onePostPreviewVC = self.storyboard?.instantiateViewController(identifier: "editMusicPostVC") as! EditMusicPostVC
            onePostPreviewVC.userDataVM = self.userDataVM
            onePostPreviewVC.hexData = hex
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
//            let entireMusicString = hex!.resource
            let artistSongString = hex!.resource.chopPrefix(21)
            print("This is artistSongString \(artistSongString)")
            let artistSongComponents = artistSongString.components(separatedBy: "/")
            let artist = artistSongComponents[0]
            let song = artistSongComponents[1]
            let finalArist = artist.replacingOccurrences(of: "-", with: " ")
            let finalSong = song.replacingOccurrences(of: "-", with: " ")
            print("final artist \(finalArist)")
        print("final song \(finalSong)")
            onePostPreviewVC.captionTextField.text = hex!.text
            onePostPreviewVC.textOverlayTextField.text = hex!.coverText
            onePostPreviewVC.captionString = hex!.text
            onePostPreviewVC.textOverlayString = hex!.coverText
            onePostPreviewVC.linkTextField.text = finalArist
            onePostPreviewVC.songNameTextField.text = finalSong
            let isPrioritized = currentVC.webHex?.isPrioritized ?? false
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
        let currentVC = viewControllers[currentIndex!]
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
        let currentVC = viewControllers[currentIndex!] as! ContentLinkVC
        let hex = currentVC.webHex
        let onePostPreviewVC = self.storyboard?.instantiateViewController(identifier: "editLinkPostVC") as! EditLinkPostVC
        onePostPreviewVC.userDataVM = userDataVM
        onePostPreviewVC.hexData = hex
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
        let isPrioritized = currentVC.webHex?.isPrioritized ?? false
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
        let currentVC = viewControllers[currentIndex!] as! ContentImageVC
        let hex = currentVC.photoHex
        let onePostPreviewVC = self.storyboard?.instantiateViewController(identifier: "editPhotoPostVC") as! EditPhotoPostVC
        onePostPreviewVC.userDataVM = userDataVM
        onePostPreviewVC.hexData = hex
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
        let isPrioritized = currentVC.photoHex?.isPrioritized ?? false
        onePostPreviewVC.checkBoxStatus = isPrioritized
        if isPrioritized {
            onePostPreviewVC.checkBox.setImage(UIImage(named: "check-3"), for: .normal)
        }
        
        //   onePostPreviewVC.items
        //   picker.present(onePostPreviewVC, animated: false, completion: nil)
        present(onePostPreviewVC, animated: false,completion: nil)
        onePostPreviewVC.modalPresentationStyle = .fullScreen
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
            let currentVC = self.viewControllers[self.currentIndex!]
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
                let currentVC = self.viewControllers[self.currentIndex!]
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
                self.viewControllers.remove(at: self.currentIndex!)
                if self.currentIndex == self.viewControllers.count {
                    self.currentIndex! -= 1
                }
                if (self.currentIndex == -1 || self.viewControllers.count == 0) {
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    self.setPresentedViewControllers(vcIndex: self.currentIndex!)
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
