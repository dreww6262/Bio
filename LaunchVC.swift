//
//  LaunchVC.swift
//  Bio
//
//  Created by Ann McDonough on 10/26/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "bioBlue")
        imageView.frame = CGRect(x: (view.frame.width/2) - (75), y: (view.frame.height/2) - (75), width: 150, height: 150)
        imageView.setupHexagonMask(lineWidth: imageView.frame.width/15, color: myCoolBlue, cornerRadius: imageView.frame.width/15)

        imageView.pulse(withIntensity: 1.2, withDuration: 1.2, loop: true)
        
        
    }
    



}
