//
//  CreateAndDragTextViewVC.swift
//  Dart1
//
//  Created by Ann McDonough on 6/11/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

//import UIKit
//
//class CreateAndDragTextViewVC: UIViewController {
//
//    @IBOutlet weak var usernameTxt: UITextField!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //Draggable textfields
//        let gesture = UIPanGestureRecognizer(target: self, action: #selector(userDragged(gesture:)))
//
//        bottomTextView.addGestureRecognizer(gesture)
//                bottomTextView.isUserInteractionEnabled = true
//
//    }
//
//    @objc func userDragged(gesture: UIPanGestureRecognizer){
//        let loc = gesture.location(in: self.view)
//        self.bottomTextView.center = loc
//
//    }
//
//}
