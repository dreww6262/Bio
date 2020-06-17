//
//  homeVC.swift
//  Dart1
//
//  Created by Ann McDonough on 5/13/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import Parse


class homeVC: UICollectionViewController {

    // refresher variable
    var refresher : UIRefreshControl!
    
    // size of page
    var page : Int = 12
    
    // arrays to hold server information
    var uuidArray = [String]()
    var picArray = [PFFile]()
    
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // always vertical scroll
        self.collectionView?.alwaysBounceVertical = true
        
        // background color
        collectionView?.backgroundColor = .white

        // title at the top
        self.navigationItem.title = PFUser.current()?.username?.uppercased()
        
        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(homeVC.refresh), for: UIControl.Event.valueChanged)
        collectionView?.addSubview(refresher)
        
        // receive notification from editVC
        NotificationCenter.default.addObserver(self, selector: #selector(homeVC.reload(_:)), name: NSNotification.Name(rawValue: "reload"), object: nil)
        
        
        // load posts func
        loadPosts()
    }
    
    internal static func setupHexagonImageView(imageView: UIImageView) {
         let lineWidth: CGFloat = 5
         let path = roundedPolygonPath(rect: imageView.bounds, lineWidth: lineWidth, sides: 6, cornerRadius: 10, rotationOffset: CGFloat(M_PI / 2.0))

         let mask = CAShapeLayer()
         mask.path = path.cgPath
         mask.lineWidth = lineWidth
         mask.strokeColor = UIColor.clear.cgColor
         mask.fillColor = UIColor.white.cgColor
         imageView.layer.mask = mask

         let border = CAShapeLayer()
         border.path = path.cgPath
         border.lineWidth = lineWidth
         border.strokeColor = UIColor.white.cgColor
         border.fillColor = UIColor.clear.cgColor
         imageView.layer.addSublayer(border)
     }
     
     internal static func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0)
      -> UIBezierPath {
         let path = UIBezierPath()
         let theta: CGFloat = CGFloat(2.0 * M_PI) / CGFloat(sides) // How much to turn at every corner
         let offset: CGFloat = cornerRadius * tan(theta / 2.0)     // Offset from which to start rounding corners
         let width = min(rect.size.width, rect.size.height)        // Width of the square

         let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)

         // Radius of the circle that encircles the polygon
         // Notice that the radius is adjusted for the corners, that way the largest outer
         // dimension of the resulting shape is always exactly the width - linewidth
         let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0

         // Start drawing at a point, which by default is at the right hand edge
         // but can be offset
         var angle = CGFloat(rotationOffset)

         let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
         path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))

         for _ in 0 ..< sides {
             angle += theta

             let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
             let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
             let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
             let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))

             path.addLine(to: start)
             path.addQuadCurve(to: end, controlPoint: tip)
         }

         path.close()

         // Move the path to the correct origins
         let bounds = path.bounds
        // let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0, y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
         let transform = CGAffineTransform(translationX: 0,
         y: 0)
         path.apply(transform)

         return path
     }
    
    
    // refreshing func
    @objc func refresh() {
        
        // reload posts
        loadPosts()
        
        // stop refresher animating
        refresher.endRefreshing()
    }
    
    
    // reloading func after received notification
    @objc func reload(_ notification:Notification) {
        collectionView?.reloadData()
    }
    
        
    // load posts func
    func loadPosts() {
        
        // request infomration from server
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.limit = page
        query.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil {
                
                // clean up
                self.uuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
                // find objects related to our request
                for object in objects! {
                    
                    // add found data to arrays (holders)
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.picArray.append(object.value(forKey: "pic") as! PFFile)
                }
                
                self.collectionView?.reloadData()

            } else {
                print(error!.localizedDescription)
            }
        })
        
    }
    
    
    // load more while scrolling down
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height {
            loadMore()
        }
    }
    
    
    // paging
    func loadMore() {
        
        // if there is more objects
        if page <= picArray.count {
            
            // increase page size
            page = page + 12
            
            // load more posts
            let query = PFQuery(className: "posts")
            query.whereKey("username", equalTo: PFUser.current()!.username!)
            query.limit = page
            query.findObjectsInBackground(block: { (objects, error) -> Void in
                if error == nil {
                    
                    // clean up
                    self.uuidArray.removeAll(keepingCapacity: false)
                    self.picArray.removeAll(keepingCapacity: false)
                    
                    // find related objects
                    for object in objects! {
                        self.uuidArray.append(object.value(forKey: "uuid") as! String)
                        self.picArray.append(object.value(forKey: "pic") as! PFFile)
                    }
                    
                    self.collectionView?.reloadData()
                    
                } else {
                    print(error?.localizedDescription ?? String())
                }
            })

        }
        
    }
    
    
    // cell numb
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3)
        return size
    }
    
    
    // cell config
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // define cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell
        
        // get picture from the picArray
        picArray[indexPath.row].getDataInBackground { (data, error) -> Void in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
                homeVC.setupHexagonImageView(imageView: cell.picImg)
            }
        }
        
        return cell
    }

    
    // header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! headerView
        
        
        // STEP 1. Get user data
        // get users data with connections to collumns of PFuser class
        header.fullnameLbl.text = (PFUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        header.webTxt.text = PFUser.current()?.object(forKey: "web") as? String
        header.webTxt.sizeToFit()
        header.bioLbl.text = PFUser.current()?.object(forKey: "bio") as? String
        header.bioLbl.sizeToFit()
        let avaQuery = PFUser.current()?.object(forKey: "ava") as! PFFile
        avaQuery.getDataInBackground { (data, error) -> Void in
            header.avaImg.image = UIImage(data: data!)
            homeVC.setupHexagonImageView(imageView: header.avaImg)
        }
        header.button.setTitle("edit profile", for: UIControl.State())
        
        
        // STEP 2. Count statistics
        // count total posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: PFUser.current()!.username!)
        posts.countObjectsInBackground (block: { (count, error) -> Void in
            if error == nil {
                header.posts.text = "\(count)"
            }
        })
        
        // count total followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("following", equalTo: PFUser.current()!.username!)
        followers.countObjectsInBackground (block: { (count, error) -> Void in
            if error == nil {
                header.followers.text = "\(count)"
            }
        })
        
        // count total followings
        let followings = PFQuery(className: "follow")
        followings.whereKey("follower", equalTo: PFUser.current()!.username!)
        followings.countObjectsInBackground (block: { (count, error) -> Void in
            if error == nil {
                header.followings.text = "\(count)"
            }
        })
        
        
        // STEP 3. Implement tap gestures
        // tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.postsTap))
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        // tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.followersTap))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        // tap followings
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.followingsTap))
        followingsTap.numberOfTapsRequired = 1
        header.followings.isUserInteractionEnabled = true
        header.followings.addGestureRecognizer(followingsTap)
        
        return header
    }
    
    
    // taped posts label
    @objc func postsTap() {
        if !picArray.isEmpty {
            let index = IndexPath(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: index, at: UICollectionView.ScrollPosition.top, animated: true)
        }
    }
    
    // tapped followers label
    @objc func followersTap() {
        
        user = PFUser.current()!.username!
        category = "followers"
        
        // make references to followersVC
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
        // present
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    // tapped followings label
    @objc func followingsTap() {
        
        user = PFUser.current()!.username!
        category = "followings"
        
        // make reference to followersVC
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC

        // present
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    
    // clicked log out
    @IBAction func logout(_ sender: AnyObject) {
    
        // implement log out
        PFUser.logOutInBackground { (error) -> Void in
            if error == nil {
                
                // remove logged in user from App memory
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.synchronize()
                
                let signin = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! signInVC
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = signin
                
            }
        }
        
    }
    
    
    // go post
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // send post uuid to "postuuid" variable
        postuuid.append(uuidArray[indexPath.row])
        
        // navigate to post view controller
        let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
        self.navigationController?.pushViewController(post, animated: true)
    }
    
}
