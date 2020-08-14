//
//  NewPostOptionsVC.swift
//  Bio
//
//  Created by Ann McDonough on 8/3/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import FMPhotoPicker

class NewPostOptionsVC: UIViewController, FMPhotoPickerViewControllerDelegate {
    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
        if photos.isEmpty {
            self.dismiss(animated: true, completion: nil)
        }
        else {

            // TODO: Learn how to implement video
            let uploadPreviewVC = storyboard?.instantiateViewController(identifier: "uploadPreviewVC") as! UploadPreviewVC
            print(photos)
            uploadPreviewVC.userData = userData
            uploadPreviewVC.photos = photos
            self.dismiss(animated: false, completion: nil)
            self.present(uploadPreviewVC, animated: false, completion: nil)
           // uploadPreviewVC.modalPresentationStyle = .fullScreen
            uploadPreviewVC.modalPresentationStyle = .overFullScreen
            
        }
    }
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var pic1: UIButton!
    
    @IBOutlet weak var pic2: UIButton!
    
    @IBOutlet weak var pic3: UIButton!
    
    @IBOutlet weak var pic4: UIButton!
    
    @IBOutlet weak var pic5: UIButton!
    
    @IBOutlet weak var pic6: UIButton!
    
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l4: UILabel!
    @IBOutlet weak var l5: UILabel!
    @IBOutlet weak var l6: UILabel!
    
    var customTabBar: TabNavigationMenu!
    
    let config = FMPhotoPickerConfig()
    
    var userData: UserData?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        formatPicturesAndLabels()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPhotoPressed(_ sender: UIButton) {
      //  sender.sendActions(for: .touchUpInside)
        let picker = FMPhotoPickerViewController(config: config)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    @IBAction func addLinkPressed(_ sender: UIButton) {
        let linkVC = storyboard?.instantiateViewController(identifier: "linkVC") as! AddLinkVCViewController
        linkVC.userData = userData
        show(linkVC, sender: nil)
        linkVC.modalPresentationStyle = .fullScreen
    }
    
    @IBAction func addSocialMediaPressed(_ sender: UIButton) {
        let addSocialMediaVC = storyboard?.instantiateViewController(identifier: "addSocialMediaVC") as! AddSocialMediaVC
           addSocialMediaVC.userData = userData
       // addSocialMediaVC.publicID = userData?.publicID
           show(addSocialMediaVC, sender: nil)
           addSocialMediaVC.modalPresentationStyle = .fullScreen
    }
    
    
    func formatPicturesAndLabels(){
        titleLabel.frame = CGRect(x: 10.0, y: 10.0, width: self.view.frame.width, height: 66.0)
        pic1.frame = CGRect(x: 10.0, y: titleLabel.frame.maxY + 20.0, width: self.view.frame.width/3, height: self.view.frame.width/6)
        l1.frame = CGRect(x: 10.0, y: pic1.frame.maxY + 20.0, width: self.view.frame.width/3, height: 33.0)
        l1.text = "Add Photo/Video"
         l2.text = "Add Song/Playlist"
         l3.text = "Write A Blog"
         l4.text = "Add Social Media"
         l5.text = "Add Link"
         l6.text = "Add Badge"
        
        pic2.frame = CGRect(x: ((self.view.frame.width*2/3)-30.0), y: titleLabel.frame.maxY + 20.0, width: self.view.frame.width/3, height: self.view.frame.width/6)
        l2.frame = CGRect(x: ((self.view.frame.width*2/3)-30.0), y: pic1.frame.maxY + 20.0, width: self.view.frame.width/3, height: 33.0)
        
        pic3.frame = CGRect(x: 10.0, y: pic1.frame.maxY + 100.0, width: self.view.frame.width/3, height: self.view.frame.width/6)
          l3.frame = CGRect(x: 10.0, y: pic3.frame.maxY + 20.0, width: self.view.frame.width/3, height: 33.0)
          pic4.frame = CGRect(x: ((self.view.frame.width*2/3)-30.0), y: pic2.frame.maxY + 100.0, width: self.view.frame.width/3, height: self.view.frame.width/6)
          l4.frame = CGRect(x: ((self.view.frame.width*2/3)-30.0), y: pic4.frame.maxY + 20.0, width: self.view.frame.width/3, height: 33.0)
        
        pic5.frame = CGRect(x: 10.0, y: pic3.frame.maxY + 100.0, width: self.view.frame.width/3, height: self.view.frame.width/6)
               l5.frame = CGRect(x: 10.0, y: pic5.frame.maxY + 20.0, width: self.view.frame.width/3, height: 33.0)
               pic6.frame = CGRect(x: ((self.view.frame.width*2/3)-30.0), y: pic4.frame.maxY + 100.0, width: self.view.frame.width/3, height: self.view.frame.width/6)
               l6.frame = CGRect(x: ((self.view.frame.width*2/3)-30.0), y: pic6.frame.maxY + 20.0, width: self.view.frame.width/3, height: 33.0)
        
        
//         pic1.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
//         pic2.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
//         pic3.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
//         pic4.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
//         pic5.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
//         pic6.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
        
        
        
        
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
