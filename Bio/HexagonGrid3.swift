//
//  HexagonGrid3.swift
//  Bio
//
//  Created by Ann McDonough on 6/24/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class HexagonGrid3: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var coordinateArray: [[CGFloat]] = []
    var coordinate: [CGFloat] = []
    var imageViewArray: [UIImageView] = []
    var index = 0
    var index1 = 0
      var tapGesture = UITapGestureRecognizer()
    //var fakeUserImageArray: [UIImage] = []
      var fakeUserImageArray = [UIImage(named: "beachex"),UIImage(named: "forest"),UIImage(named: "skiingex"),UIImage(named: "bcex"),UIImage(named: "concertex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex"),UIImage(named: "volcanoex"),UIImage(named: "pastureex"),UIImage(named: "instagram1ex"),UIImage(named: "instagram2ex"),UIImage(named: "instagram3ex")]
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
      
     // let tap = UITapGestureRecognizer(target: self, action: #selector(HexagonGrid3.imageTapped(sender:)))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))

       // scrollView.addGestureRecognizer(tap)
        
        
          // Do any additional setup after loading the view.
                let hexaDiameter : CGFloat = 150
                let hexaWidth = hexaDiameter * sqrt(3) * 0.5
                let hexaWidthDelta = (hexaDiameter - hexaWidth) * 0.5
                let hexaHeightDelta = hexaDiameter * 0.25
                let spacing : CGFloat = 5

        //        let rows = 10
        //        let firstRowColumns = 6

                let rows = 15
                let firstRowColumns = 15
                
                scrollView.contentSize = CGSize(width: spacing + CGFloat(firstRowColumns) * (hexaWidth + spacing),
                                          height: spacing + CGFloat(rows) * (hexaDiameter - hexaHeightDelta + spacing) + hexaHeightDelta)
        
        
        
//        self.scrollView.center.x = 946.8266739736607
//         self.scrollView.center.y = 902.5
         scrollView.backgroundColor = UIColor.black
           // scrollView.contentSize = imageView.bounds.size
         scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
         scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
         
        
        
        
        var reOrderedCoordinateArray: [[CGFloat]] = [[946.8266739736607, 902.5],[1081.7304845413264, 902.5], [1014.2785792574934, 1020.0],   [879.3747686898278,1020.0], [811.9228634059948,902.5], [879.3747686898278,785.0],[1014.2785792574934,785.0],[946.8266739736607, 667.5],[1081.7304845413264, 667.5], [1149.1823898251594, 785.0],  [1216.6342951089923, 902.5],[1149.1823898251594, 1020.0],   [1081.7304845413264, 1137.5], [1081.7304845413264, 1137.5],[946.8266739736607, 1137.5],[811.9228634059948, 1137.5],[744.4709581221618, 1020.0],[677.0190528383291, 902.5],[744.4709581221618, 785.0],  [811.9228634059948, 667.5]]
        
        index = 0
        for coordinates in reOrderedCoordinateArray {
            print(coordinates)
            let image = UIImageView(frame: CGRect(x: coordinates[0]-800,
                                                                 y: coordinates[1]-670,
                                                                 width: hexaDiameter,
                                                                 height: hexaDiameter))
                           image.contentMode = .scaleAspectFill
                           image.image = UIImage(named: "stickfigure1")
            image.isUserInteractionEnabled = true
              image.addGestureRecognizer(tap)
            var gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
            image.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
            view.addSubview(image)
            imageViewArray.append(image)
            imageViewArray[index].tag = index
            
        }
        print(imageViewArray)
        
        populateSocialMedia()
        populateFakeUserPhotos()
        
        
    }
    
    func populateSocialMedia() {
        imageViewArray[1].image = UIImage(named: "facebooklogo")
           imageViewArray[2].image = UIImage(named: "instagramLogo")
           imageViewArray[3].image = UIImage(named: "twitter")
           imageViewArray[4].image = UIImage(named: "spotifylogo")
           imageViewArray[5].image = UIImage(named: "snapchatlogo")
           imageViewArray[6].image = UIImage(named: "venmologo")
    }
   
    func populateFakeUserPhotos() {
        index1 = 0
        for image in fakeUserImageArray {
            imageViewArray[index1+7].image = fakeUserImageArray[index1]
        index1 = index1+1
        }
    }
    
    
    
//     @objc func imageTapped(_ sender: UITapGestureRecognizer){
//        print("I tapped image with tag \(sender.view!.tag)")
//       // let newImage.tag = sender.view!.tag
//
//    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer){
           print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
          // let newImage.tag = sender.view!.tag
           
       }
    
//    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//        // handling code
//    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("🎯🎯🎯🎯🎯Hello World")
        print("🎯🎯🎯🎯🎯🎯🎯I tapped image with tag \(sender.view!.tag)")
     }
    
    
}
