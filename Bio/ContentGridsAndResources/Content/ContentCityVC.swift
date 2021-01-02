//
//  ContentCityVC.swift
//  
//
//  Created by Ann McDonough on 12/27/20.
//
import UIKit
var offWhite1 = #colorLiteral(red: 1, green: 1, blue: 0.9490196078, alpha: 1)
var offWhite2 = #colorLiteral(red: 0.9843137255, green: 0.968627451, blue: 0.9607843137, alpha: 1)
var offWhite3 = #colorLiteral(red: 0.9764705882, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
var offWhite4 = #colorLiteral(red: 0.9764705882, green: 0.9450980392, blue: 0.9450980392, alpha: 1)



class ContentCityVC: UIViewController, UIScrollViewDelegate {
    
    var cityHex: HexagonStructData?
    var showOpenAppButton = false
    var scrollView = UIScrollView()
    var newImageView: UIImageView?
    var userDataVM: UserDataVM?
   // var captionTextField = UITextField()
    
    var viewHasLoaded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewHasLoaded {
            return
        }
        viewHasLoaded = true
        view.backgroundColor = .white
        setUpScrollView()
        setZoomScale()
        
        
        newImageView = UIImageView(image: UIImage(named: cityHex!.thumbResource))
        let cleanRef = cityHex!.thumbResource.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
//        newImageView!.sd_setImage(with: url!, completed: {_, error, _, _ in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//        })
        scrollView.addSubview(newImageView!)
        scrollView.bringSubviewToFront(newImageView!)
        
       // let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 65)
      //  let smallframe = CGRect(x: view.frame.width/3, y: view.frame.height/12, width: view.frame.width/3, height: view.frame.width/3)
        let frame = CGRect(x: view.frame.width/6, y: view.frame.height/12, width: view.frame.width*(2/3), height: view.frame.width*(2/3))

//        captionTextField.font = UIFont(name: "DINAlternate-Bold", size: 28)
//        captionTextField.textAlignment = .center
//        captionTextField.isUserInteractionEnabled = false
        newImageView!.frame = frame
        newImageView?.layer.cornerRadius = (frame.width)/2
        newImageView!.backgroundColor = .black
        
        newImageView!.contentMode = .scaleAspectFit
        newImageView!.isUserInteractionEnabled = true
        setUpCaption()
        //let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //newImageView.addGestureRecognizer(tap)
        
        
    }
    

    let label1 = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()
    func setUpCaption() {
        
        scrollView.addSubview(label1)
        scrollView.addSubview(label2)
        scrollView.addSubview(label3)
        let currentCity = cityHex!.text
        let relationshipText = "\(cityHex!.resource) is living in"
        
        label1.text = relationshipText
        label2.text = currentCity
        label3.text = ""
        
        
        //let captionFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 66)
        label1.font = UIFont(name: "DINAlternate-Bold", size: 23)
        label3.font = UIFont(name: "DINAlternate-Bold", size: 23)
        label2.font = UIFont(name: "DINAlternate-Bold", size: 23)
        let label1Frame = CGRect(x: 0, y: (newImageView?.frame.maxY)! + 20, width: view.frame.width, height: 30)
        let label2Frame = CGRect(x: 0, y: label1Frame.maxY + 20, width: view.frame.width, height: 30)
        let label3Frame = CGRect(x: 0, y: label2Frame.maxY + 20, width: view.frame.width, height: 30)
        label1.frame = label1Frame
        label2.frame = label2Frame
        label3.frame = label3Frame
        label1.textColor = .black
        label2.textColor = .black
        label3.textColor = .black
        label1.textAlignment = .center
        label2.textAlignment = .center
        label3.textAlignment = .center
        
        
        
        label1.textAlignment = .center
        label1.isUserInteractionEnabled = false
        print("This is caption text \(relationshipText)")
        print("This is text field text \(label1.text)")
        label1.textColor = .black
     //   birthdayLabel.frame = captionFrame
    //    captionTextField.size
        
        print()
    }
    
    override func loadView() {
        view = scrollView
    }
    override func viewDidLayoutSubviews() {
        let frame = CGRect(x: view.frame.width/6, y: view.frame.height/12, width: view.frame.width*(2/3), height: view.frame.width*(2/3))

        newImageView!.frame = frame
        newImageView?.layer.cornerRadius = (frame.width)/2
        newImageView?.clipsToBounds = true 
        newImageView!.backgroundColor = .white
        
        newImageView!.contentMode = .scaleAspectFit
        newImageView!.isUserInteractionEnabled = true
        
        let label1Frame = CGRect(x: 0, y: (newImageView?.frame.maxY)! + 20, width: view.frame.width, height: 30)
        let label2Frame = CGRect(x: 0, y: label1Frame.maxY + 20, width: view.frame.width, height: 30)
        let label3Frame = CGRect(x: 0, y: label2Frame.maxY + 20, width: view.frame.width, height: 30)
        label1.frame = label1Frame
        label2.frame = label2Frame
        label3.frame = label3Frame
        
        label1.numberOfLines = 0
        label2.numberOfLines = 0
        label3.numberOfLines = 0
    }
    
    
    // viewdidload helper functions
    func setUpScrollView() {
        //view.addSubview(scrollView)
        //scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 65)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.backgroundColor = white
        //scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentMode = .scaleAspectFit
        scrollView.bouncesZoom = false
        
    }
    
    func setZoomScale() {

        scrollView.maximumZoomScale = 60
        scrollView.minimumZoomScale = 1
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = newImageView!.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height)/2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width)/2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return newImageView
    }
    

}
