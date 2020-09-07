//
//  LoadingAnimationView1.swift
//  Bio
//
//  Created by Ann McDonough on 9/4/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class LoadingAnimationView1: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var loop = 0
        var loopLimit = 20
        //imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: gold, cornerRadius: imageView.frame.width/15)
        imageView.frame = CGRect(x: (view.frame.width/2) - (75), y: (view.frame.height/2) - (75), width: 150, height: 150)
        imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: gold, cornerRadius: imageView.frame.width/15)

        imageView.pulse(withIntensity: 1.2, withDuration: 1.2, loop: true)
        
     
       
    }
    
    

}


func doAnimation(image: UIImageView) {
    UIView.animate(withDuration: 1, animations: {
        image.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
           }) { (finished) in
               UIView.animate(withDuration: 1, animations: {
                image.transform = CGAffineTransform.identity
               })
           }
}

extension UIView {
    func pulse(withIntensity intensity: CGFloat, withDuration duration: Double, loop: Bool) {
        UIView.animate(withDuration: duration, delay: 0, options: [.repeat, .autoreverse], animations: {
            loop ? nil : UIView.setAnimationRepeatCount(10)
            self.transform = CGAffineTransform(scaleX: intensity, y: intensity)
        }) { (true) in
            self.transform = CGAffineTransform.identity
        }
    }
}
