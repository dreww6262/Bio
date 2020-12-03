//
//  PersonDetailViewController.swift
//  
//
//  Created by Ann McDonough on 12/3/20.
//

import UIKit

class PersonDetailViewController: UIViewController {
var title1 = UILabel()
var detailString = ""
var circlePhoto = UIImageView()
    var circlePhotoWidth = CGFloat(150.0)
    var spacing = CGFloat(20.0)
var detailStrings: [String] = []

    @IBOutlet weak var image1: UIImageView!
    var image1Label = UILabel()
    var image1Label2 = UILabel()
    var image1Label3 = UILabel()
    
    
    var image2 = UIImageView()
    var image2Label = UILabel()
    var image3 = UIImageView()
    var image3Label = UILabel()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("before")
        image1.contentMode = .scaleAspectFill
        image2.contentMode = .scaleAspectFill
        image3.contentMode = .scaleAspectFill
        
        
        setUpTitle()
       // setup1Image()
      //  setup3Image()
        setupBirthday()

        // Do any additional setup after loading the view.
    }
    
    func setUpTitle() {
        print("im in here")
        //view.addSubview(titleLabel)
        view.backgroundColor = .black
        titleLabel.frame = CGRect(x: 0, y: view.frame.height/6 , width: self.view.frame.width, height: 25)
        titleLabel.text = "Ethnicity"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "DINAlternate-Bold", size: 30)
        titleLabel.textColor = .white
        //view.addSubview(image)
        
        
    }
    
    func setup1Image() {
        self.image1.frame =  CGRect(x: (view.frame.width - CGFloat(circlePhotoWidth))/2, y: titleLabel.frame.maxY + 20 , width: CGFloat(circlePhotoWidth), height: CGFloat(circlePhotoWidth))
        image1.clipsToBounds = true
        image1.layer.cornerRadius = image1.frame.width/2
        image1.image = UIImage(named: "usa")
        
        view.addSubview(image1Label)
        image1Label.frame = CGRect(x: image1.frame.minX, y: image1.frame.maxY + 5, width: circlePhotoWidth, height: 44)
        image1Label.text = "American"
        image1Label.font = UIFont(name: "DINAlternate-Bold", size: 20)
        image1Label.textColor = .white
        image1Label.textAlignment = .center
    }
    
    func setup2Image() {
        self.image1.frame =  CGRect(x: (view.frame.width/2) - circlePhotoWidth - (spacing/2), y: titleLabel.frame.maxY + 20 , width: CGFloat(circlePhotoWidth), height: CGFloat(circlePhotoWidth))
        image1.clipsToBounds = true
        image1.layer.cornerRadius = image1.frame.width/2
        image1.image = UIImage(named: "usa")
        
        view.addSubview(image1Label)
        image1Label.frame = CGRect(x: image1.frame.minX, y: image1.frame.maxY + 5, width: circlePhotoWidth, height: 44)
        image1Label.text = "American"
        image1Label.font = UIFont(name: "DINAlternate-Bold", size: 20)
        image1Label.textColor = .white
        image1Label.textAlignment = .center
        
        view.addSubview(image2)
        self.image2.frame =  CGRect(x: (view.frame.width/2) + (spacing/2), y: titleLabel.frame.maxY + 20 , width: CGFloat(circlePhotoWidth), height: CGFloat(circlePhotoWidth))
        image2.clipsToBounds = true
        image2.layer.cornerRadius = image1.frame.width/2
        image2.image = UIImage(named: "lebanonCircle")
        
        view.addSubview(image2Label)
        image2Label.frame = CGRect(x: image2.frame.minX, y: image2.frame.maxY + 5, width: circlePhotoWidth, height: 44)
        image2Label.text = "Lebanese"
        image2Label.font = UIFont(name: "DINAlternate-Bold", size: 20)
        image2Label.textColor = .white
        image2Label.textAlignment = .center
        
    }
    
    func setup3Image() {
        circlePhotoWidth = CGFloat(120.0)
        var totalWidth: CGFloat = (3*circlePhotoWidth) + spacing
        
        self.image1.frame = CGRect(x: (view.frame.width - totalWidth)/2, y: titleLabel.frame.maxY + 20, width: CGFloat(circlePhotoWidth), height: CGFloat(circlePhotoWidth))
        image1.clipsToBounds = true
        image1.layer.cornerRadius = image1.frame.width/2
        image1.image = UIImage(named: "usa")
        
        view.addSubview(image1Label)
        image1Label.frame = CGRect(x: image1.frame.minX, y: image1.frame.maxY + 5, width: circlePhotoWidth, height: 44)
        image1Label.text = "American"
        image1Label.font = UIFont(name: "DINAlternate-Bold", size: 20)
        image1Label.textColor = .white
        image1Label.textAlignment = .center
        
        view.addSubview(image2)
        self.image2.frame =  CGRect(x: image1.frame.maxX + (spacing)/2, y: titleLabel.frame.maxY + 20 , width: CGFloat(circlePhotoWidth), height: CGFloat(circlePhotoWidth))
        image2.clipsToBounds = true
        image2.layer.cornerRadius = image1.frame.width/2
        image2.image = UIImage(named: "lebanonCircle")
        
        view.addSubview(image2Label)
        image2Label.frame = CGRect(x: image2.frame.minX, y: image2.frame.maxY + 5, width: circlePhotoWidth, height: 44)
        image2Label.text = "Lebanese"
        image2Label.font = UIFont(name: "DINAlternate-Bold", size: 20)
        image2Label.textColor = .white
        image2Label.textAlignment = .center
        
        view.addSubview(image3)
        self.image3.frame =  CGRect(x: image2.frame.maxX + (spacing)/2, y: titleLabel.frame.maxY + 20 , width: CGFloat(circlePhotoWidth), height: CGFloat(circlePhotoWidth))
        image3.clipsToBounds = true
        image3.layer.cornerRadius = image1.frame.width/2
        image3.image = UIImage(named: "lebanonCircle")
        
        view.addSubview(image3Label)
        image3Label.frame = CGRect(x: image3.frame.minX, y: image3.frame.maxY + 5, width: circlePhotoWidth, height: 44)
        image3Label.text = "Lebanese"
        image3Label.font = UIFont(name: "DINAlternate-Bold", size: 20)
        image3Label.textColor = .white
        image3Label.textAlignment = .center
        
        
    }
    
    func setupBirthday() {
        titleLabel.text = "DOB"
        self.image1.frame =  CGRect(x: (view.frame.width - CGFloat(circlePhotoWidth))/2, y: titleLabel.frame.maxY + 20 , width: CGFloat(circlePhotoWidth), height: CGFloat(circlePhotoWidth))
        image1.clipsToBounds = true
        image1.layer.cornerRadius = image1.frame.width/2
        image1.image = UIImage(named: "cancer")
        
        view.addSubview(image1Label)
        image1Label.frame = CGRect(x: image1.frame.minX, y: image1.frame.maxY + 5, width: circlePhotoWidth, height: 44)
        image1Label.text = "19 October 1997"
        image1Label.font = UIFont(name: "DINAlternate-Bold", size: 20)
        image1Label.textColor = .white
        image1Label.textAlignment = .center
        
        view.addSubview(image1Label2)
        image1Label2.frame = CGRect(x: image1Label.frame.minX, y: image1Label.frame.maxY + 5, width: circlePhotoWidth, height: 44)
        image1Label2.text = "23"
        image1Label2.font = UIFont(name: "DINAlternate-Bold", size: 20)
        image1Label2.textColor = .white
        image1Label2.textAlignment = .center
        
        view.addSubview(image1Label3)
        image1Label3.frame = CGRect(x: image1Label2.frame.minX, y: image1Label2.frame.maxY + 5, width: circlePhotoWidth, height: 44)
        image1Label3.text = "Libra"
        image1Label3.font = UIFont(name: "DINAlternate-Bold", size: 20)
        image1Label3.textColor = .white
        image1Label3.textAlignment = .center
    }
    
    
    

}
