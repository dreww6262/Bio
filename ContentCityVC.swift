//
//  ContentCityVC.swift
//  
//
//  Created by Ann McDonough on 12/27/20.
//
import UIKit
class ContentCityVC: UIViewController, UIScrollViewDelegate {
    
    var cityHex: HexagonStructData?
    var showOpenAppButton = false
    var scrollView = UIScrollView()
    var newImageView: UIImageView?
    var userDataVM: UserDataVM?
   // var captionTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpScrollView()
        setZoomScale()
        
        
        newImageView = UIImageView(image: UIImage(named: "homeCircle"))
        let cleanRef = cityHex!.thumbResource.replacingOccurrences(of: "/", with: "%2F")
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bio-social-media.appspot.com/o/\(cleanRef)?alt=media")
        newImageView!.sd_setImage(with: url!, completed: {_, error, _, _ in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
        scrollView.addSubview(newImageView!)
        scrollView.bringSubviewToFront(newImageView!)
        
       // let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 65)
      //  let smallframe = CGRect(x: view.frame.width/3, y: view.frame.height/12, width: view.frame.width/3, height: view.frame.width/3)
        let frame = CGRect(x: view.frame.width/6, y: view.frame.height/12, width: view.frame.width*(2/3), height: view.frame.width*(2/3))
        let birthdayFrame = CGRect(x: 0, y: frame.maxY + 5, width: view.frame.width, height: 20)
        let ageFrame = CGRect(x: 0, y: birthdayFrame.maxY + 5, width: view.frame.width, height: 20)
        let zodiacFrame = CGRect(x: 0, y: ageFrame.maxY + 5, width: view.frame.width, height: 20)
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
        
        let textView = UITextView()
        textView.text = "asdfkjlasdfjasdf"
        textView.textColor = .red
        // Do any additional setup after loading the view.
        
      //  captionTextField.frame = captionFrame
        
    }
    

    
    func setUpCaption() {
        var label1 = UILabel()
        var label2 = UILabel()
        var label3 = UILabel()
        scrollView.addSubview(label1)
        scrollView.addSubview(label2)
        scrollView.addSubview(label3)
        var currentCity = cityHex!.text
        var relationshipText = "\(cityHex!.resource) is living in"
        
        label1.text = relationshipText
        label2.text = currentCity
        label3.text = ""
        let captionFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 66)
        label1.font = UIFont(name: "DINAlternate-Bold", size: 28)
        label3.font = UIFont(name: "DINAlternate-Bold", size: 28)
        label2.font = UIFont(name: "DINAlternate-Bold", size: 28)
        let frame = CGRect(x: view.frame.width/3, y: view.frame.height/12, width: view.frame.width/3, height: view.frame.width/3)
        let label1Frame = CGRect(x: 0, y: (newImageView?.frame.maxY)! + 20, width: view.frame.width, height: 30)
        let label2Frame = CGRect(x: 0, y: label1Frame.maxY + 20, width: view.frame.width, height: 30)
        let label3Frame = CGRect(x: 0, y: label2Frame.maxY + 20, width: view.frame.width, height: 30)
        label1.frame = label1Frame
        label2.frame = label2Frame
        label3.frame = label3Frame
        label1.textColor = .white
        label2.textColor = .white
        label3.textColor = .white
        label1.textAlignment = .center
        label2.textAlignment = .center
        label3.textAlignment = .center
        
        
        
        label1.textAlignment = .center
        label1.isUserInteractionEnabled = false
        print("This is caption text \(relationshipText)")
        print("This is text field text \(label1.text)")
        label1.textColor = .white
     //   birthdayLabel.frame = captionFrame
    //    captionTextField.size
        
        print()
    }
    
    // viewdidload helper functions
    func setUpScrollView() {
        view.addSubview(scrollView)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 65)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.backgroundColor = .black
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
    
//    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        for view in view.subviews {
//            view.removeFromSuperview()
//        }
//        self.dismiss(animated: false, completion: nil)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
