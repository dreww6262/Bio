//
//  DummyVCForPopUp.swift
//  Bio
//
//  Created by Ann McDonough on 6/28/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class DummyVCForPopUp: UIPresentationController {
    
    @IBOutlet weak var signUpLabel: UILabel!
    
    @IBOutlet weak var mottoLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var emailButton: UIButton!
    
    
    //class ForgotPasswordPresentationController: UIPresentationController{
        let blurEffectView: UIVisualEffectView!
        var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    @objc func dismiss(){
            self.presentedViewController.dismiss(animated: true, completion: nil)
        }
        override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.blurEffectView.isUserInteractionEnabled = true
            self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
        }
        override var frameOfPresentedViewInContainerView: CGRect{
            return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height/2), size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height/2))
        }
        override func dismissalTransitionWillBegin() {
            self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
                self.blurEffectView.alpha = 0
            }, completion: { (UIViewControllerTransitionCoordinatorContext) in
                self.blurEffectView.removeFromSuperview()
            })
        }
        override func presentationTransitionWillBegin() {
            self.blurEffectView.alpha = 0
            self.containerView?.addSubview(blurEffectView)
            self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
                self.blurEffectView.alpha = 1
            }, completion: { (UIViewControllerTransitionCoordinatorContext) in

            })
        }
        override func containerViewWillLayoutSubviews() {
            super.containerViewWillLayoutSubviews()
            presentedView!.layer.masksToBounds = true
            presentedView!.layer.cornerRadius = 10
        }
        override func containerViewDidLayoutSubviews() {
            super.containerViewDidLayoutSubviews()
            self.presentedView?.frame = frameOfPresentedViewInContainerView
            blurEffectView.frame = containerView!.bounds
        }
    }
    
//
//
//    public enum PopupPosition {
//        /// Align center X, center Y with offset param
//        case center(CGPoint?)
//
//        /// Top left anchor point with offset param
//        case topLeft(CGPoint?)
//
//        /// Top right anchor point with offset param
//        case topRight(CGPoint?)
//
//        /// Bottom left anchor point with offset param
//        case bottomLeft(CGPoint?)
//
//        /// Bottom right anchor point with offset param
//        case bottomRight(CGPoint?)
//
//        /// Top anchor, align center X with top padding param
//        case top(CGFloat)
//
//        /// Left anchor, align center Y with left padding param
//        case left(CGFloat)
//
//        /// Bottom anchor, align center X with bottom padding param
//        case bottom(CGFloat)
//
//        /// Right anchor, align center Y with right padding param
//        case right(CGFloat)
//    }
//
//    /// Popup width, it's nil if width is determined by view's intrinsic size
//    private(set) public var popupWidth: CGFloat?
//
//    /// Popup height, it's nil if width is determined by view's intrinsic size
//    private(set) public var popupHeight: CGFloat?
//
//    /// Popup position, default is center
//    private(set) public var position: PopupPosition = .center(nil)
//
//    /// Background alpha, default is 0.5
//    public var backgroundAlpha: CGFloat = 0.5
//
//    /// Background color, default is black
//    public var backgroundColor = UIColor.black
//
//    /// Allow tap outside popup to dismiss, default is true
//    public var canTapOutsideToDismiss = true
//
//    /// Corner radius, default is 0 (no rounded corner)
//    public var cornerRadius: CGFloat = 0
//
//    /// Shadow enabled, default is true
//    public var shadowEnabled = true
//
//    /// The pop up view controller. It's not mandatory.
//    private(set) public var contentController: UIViewController?
//
//    /// The pop up view
//    private(set) public var contentView: UIView?
//
//
//    private var containerView = UIView()
//
//    @IBOutlet weak var examplePopUp: SignUpPopUpView!
//
//    public init(contentController: UIViewController, position: PopupPosition = .center(nil), popupWidth: CGFloat? = nil, popupHeight: CGFloat? = nil) {
//        super.init(nibName: nil, bundle: nil)
//        self.contentController = contentController
//        self.contentView = contentController.view
//        self.popupWidth = popupWidth
//        self.popupHeight = popupHeight
//        self.position = position
//
//        commonInit()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//   private func commonInit() {
//          modalPresentationStyle = .overFullScreen
//          modalTransitionStyle = .crossDissolve
//      }
//
//}


