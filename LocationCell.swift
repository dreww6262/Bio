//
//  LocationCell.swift
//  
//
//  Created by Ann McDonough on 12/21/20.
//

import UIKit
import Firebase
import FirebaseFirestore
import AVFoundation

class LocationCell: UITableViewCell {
    
    //  UI objects

    let label = UILabel()
    
    let db = Firestore.firestore()
    
    let circularMask = UIImageView()
    
    // default func
    override func layoutSubviews() {
        contentView.addSubview(label)
        self.backgroundColor = .white
        let cellHeight: CGFloat = self.contentView.frame.height
        print("This is cellHeight \(cellHeight)")
        label.frame = CGRect(x: 10, y: 0, width: contentView.frame.width - 20, height: 25)
        label.textColor = .black
     
       

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
      //  interactiveTextField.text = ""
    }
    
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
   
}
