//
//  HexagonGrid2.swift
//  Bio
//
//  Created by Ann McDonough on 6/24/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class HexagonGrid2: UIViewController, UIScrollViewDelegate {

    //@IBOutlet weak var view1: UIView!
    
    //@IBOutlet var view1: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var coordinateArray: [[CGFloat]] = []
    var coordinate: [CGFloat] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.center.x = 946.8266739736607
        self.scrollView.center.y = 902.5
        scrollView.backgroundColor = UIColor.black
          // scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        
        
        
        
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

        for y in 0..<rows {
            let cellsInRow = y % 2 == 0 ? firstRowColumns : firstRowColumns - 1
            let rowXDelta = y % 2 == 0 ? 0.0 : (hexaWidth + spacing) * 0.5
            for x in 0..<cellsInRow {
                let image = UIImageView(frame: CGRect(x: rowXDelta + CGFloat(x) * (hexaWidth + spacing) + spacing - hexaWidthDelta,
                                                      y: CGFloat(y) * (hexaDiameter - hexaHeightDelta + spacing) + spacing,
                                                      width: hexaDiameter,
                                                      height: hexaDiameter))
                image.contentMode = .scaleAspectFill
                image.image = UIImage(named: "red")
              // print("These are the coordinates of image \(image.frame.midX)
                               //   \(image.frame.midY))")"
                print("These are the coordinates of the image \(image.frame.midX), \(image.frame.midY)")
                if image.frame.midX == 946.8266739736607 && image.frame.midY == 902.5 {
                    print("I want this to be first 🎲🎲🎲🎲🎲🎲")
                    image.image = UIImage(named: "stickfigure1")
                }
                
                
                
                if image.frame.midX == 1081.7304845413264 && image.frame.midY == 902.5 {
                    print("I want this to be second 🎲🎲🎲🎲🎲🎲")
                    image.image = UIImage(named: "instagramLogo")
                }
                
                if image.frame.midX == 1014.2785792574934 && image.frame.midY == 1020.0 {
                    print("I want this to be third 🎲🎲🎲🎲🎲🎲")
                    image.image = UIImage(named: "snapchatlogo")
                }
             
                if image.frame.midX == 879.3747686898278 && image.frame.midY == 1020.0 {
                                                  print("I want this to be 4th 🎲🎲🎲🎲🎲🎲")
                                                  image.image = UIImage(named: "venmologo")
                                              }
               
                if image.frame.midX == 811.9228634059948 && image.frame.midY == 902.5 {
                                                                 print("I want this to be 5th 🎲🎲🎲🎲🎲🎲")
                                                                 image.image = UIImage(named: "spotifylogo")
                                                             }
                
                
            
                if image.frame.midX == 879.3747686898278 && image.frame.midY == 785.0 {
                                   print("I want this to be 6th 🎲🎲🎲🎲🎲🎲")
                                   image.image = UIImage(named: "facebooklogo")
                               }

             
                if image.frame.midX == 1014.2785792574934 && image.frame.midY == 785.0 {
                                   print("I want this to be seventh 🎲🎲🎲🎲🎲🎲")
                                   image.image = UIImage(named: "twitterlogo")
                               }
                if image.frame.midX == 946.8266739736607 && image.frame.midY == 667.5 {
                                                 print("I want this to be 8th 🎲🎲🎲🎲🎲🎲")
                                                 image.image = UIImage(named: "stickfigure1")
                                             }
                
                if image.frame.midX == 1081.7304845413264 && image.frame.midY == 667.5 {
                                   print("I want this to be 9th 🎲🎲🎲🎲🎲🎲")
                                   image.image = UIImage(named: "stickfigure1")
                               }
                
                if image.frame.midX == 1149.1823898251594 && image.frame.midY == 785.0 {
                                                  print("I want this to be 10th 🎲🎲🎲🎲🎲🎲")
                                                  image.image = UIImage(named: "stickfigure1")
                                              }
   
                if image.frame.midX == 1216.6342951089923 && image.frame.midY == 902.5 {
                                                     print("I want this to be 11th 🎲🎲🎲🎲🎲🎲")
                                                     image.image = UIImage(named: "stickfigure1")
                                                 }
                
                if image.frame.midX == 1149.1823898251594 && image.frame.midY == 1020.0 {
                    print("I want this to be 12th 🎲🎲🎲🎲🎲🎲")
                    image.image = UIImage(named: "stickfigure1")
                }
                
                if image.frame.midX == 1081.7304845413264 && image.frame.midY == 1137.5 {
                    print("I want this to be 13th 🎲🎲🎲🎲🎲🎲")
                    image.image = UIImage(named: "stickfigure1")
                }
                
                if image.frame.midX == 946.8266739736607 && image.frame.midY == 1137.5 {
                                  print("I want this to be 15th 🎲🎲🎲🎲🎲🎲")
                                  image.image = UIImage(named: "stickfigure1")
                              }
                
                if image.frame.midX == 811.9228634059948 && image.frame.midY == 1137.5 {
                                               print("I want this to be 16th 🎲🎲🎲🎲🎲🎲")
                                               image.image = UIImage(named: "stickfigure1")
                                           }
                if image.frame.midX == 744.4709581221618 && image.frame.midY == 1020.0 {
                    print("I want this to be 17th 🎲🎲🎲🎲🎲🎲")
                    image.image = UIImage(named: "stickfigure1")
                }
                   
                if image.frame.midX == 677.0190528383291 && image.frame.midY == 902.5 {
                              print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                              image.image = UIImage(named: "stickfigure1")
                          }
                
                if image.frame.midX == 744.4709581221618 && image.frame.midY == 785.0 {
                    print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                    image.image = UIImage(named: "stickfigure1")
                }
                
                if image.frame.midX == 811.9228634059948 && image.frame.midY == 667.5 {
                    print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                    image.image = UIImage(named: "stickfigure1")
                }
                
                if image.frame.midX == 879.3747686898278 && image.frame.midY == 550.0 {
                                 print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                 image.image = UIImage(named: "stickfigure1")
                             }
                
                if image.frame.midX == 1014.2785792574934 && image.frame.midY == 550.0 {
                    print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                    image.image = UIImage(named: "stickfigure1")
                }
                
                if image.frame.midX == 1149.1823898251594 && image.frame.midY == 550.0 {
                                  print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                  image.image = UIImage(named: "stickfigure1")
                              }
                if image.frame.midX == 1216.6342951089923 && image.frame.midY == 667.5 {
                                                 print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                                 image.image = UIImage(named: "stickfigure1")
                            }
                
                if image.frame.midX == 1284.0862003928253 && image.frame.midY == 785.0 {
                                                                print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                                                image.image = UIImage(named: "stickfigure1")
                                           }
                
                if image.frame.midX == 1351.5381056766582 && image.frame.midY == 902.5 {
                                     print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                     image.image = UIImage(named: "stickfigure1")
                }
                
                if image.frame.midX == 1284.0862003928253 && image.frame.midY == 1020.0 {
                                                  print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                                  image.image = UIImage(named: "stickfigure1")
                             }
                if image.frame.midX == 1216.6342951089923 && image.frame.midY == 1137.5 {
                                                                 print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                                                 image.image = UIImage(named: "stickfigure1")
                }
                
                
        if image.frame.midX == 1149.1823898251594 && image.frame.midY == 1255.0 {
                             print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                             image.image = UIImage(named: "stickfigure1")
        }
            
                
                if image.frame.midX == 1014.2785792574934 && image.frame.midY == 1255.0 {
                                            print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                            image.image = UIImage(named: "stickfigure1")
                       }
                
                if image.frame.midX == 879.3747686898278 && image.frame.midY == 1255.0 {
                                     print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                     image.image = UIImage(named: "stickfigure1")
                }
                
                if image.frame.midX == 744.4709581221618 && image.frame.midY == 1255.0 {
                                                    print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                                    image.image = UIImage(named: "stickfigure1")
                               }
                if image.frame.midX == 677.0190528383291 && image.frame.midY == 1137.5 {
                                                                 print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                                                 image.image = UIImage(named: "stickfigure1")
                                            }
                
                if image.frame.midX == 609.5671475544962 && image.frame.midY == 1020.0 {
                                     print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                     image.image = UIImage(named: "stickfigure1")
                }
                
                if image.frame.midX == 542.1152422706632 && image.frame.midY == 902.5 {
                                                    print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                                    image.image = UIImage(named: "stickfigure1")
                               }
              
                if image.frame.midX == 609.5671475544962 && image.frame.midY == 785.0 {
                                     print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                     image.image = UIImage(named: "stickfigure1")
                }
                
                if image.frame.midX == 677.0190528383291 && image.frame.midY == 667.5 {
                                                   print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                                   image.image = UIImage(named: "stickfigure1")
                              }
                if image.frame.midX == 744.4709581221618 && image.frame.midY == 550.0 {
                                                                  print("I want this to be 18th 🎲🎲🎲🎲🎲🎲")
                                                                  image.image = UIImage(named: "kbit")
                                             }
                
                if image.frame.midX == 811.9228634059948 && image.frame.midY == 432.5 {
                                     print("I want this to be 19th 🎲🎲🎲🎲🎲🎲")
                                     image.image = UIImage(named: "kbit")
                }
                
                if image.frame.midX == 946.8266739736607 && image.frame.midY == 432.5 {
                                                   print("I want this to be 20th 🎲🎲🎲🎲🎲🎲")
                                                   image.image = UIImage(named: "kbit")
                              }
                
                if image.frame.midX == 1081.7304845413264 && image.frame.midY == 432.5 {
                                                                 print("I want this to be 21th 🎲🎲🎲🎲🎲🎲")
                                                                 image.image = UIImage(named: "kbit")
                                            }
                if image.frame.midX == 1216.6342951089923 && image.frame.midY == 432.5 {
                                                                                print("I want this to be 22th 🎲🎲🎲🎲🎲🎲")
                                                                                image.image = UIImage(named: "kbit")
                                                           }
                
                if image.frame.midX == 1284.0862003928253 && image.frame.midY == 550.0 {
                                                                                             print("I want this to be 23th 🎲🎲🎲🎲🎲🎲")
                                                                                             image.image = UIImage(named: "kbit")
                                                                        }
                if image.frame.midX == 1351.5381056766582 && image.frame.midY == 667.5 {
                                     print("I want this to be 24th 🎲🎲🎲🎲🎲🎲")
                                     image.image = UIImage(named: "kbit")
                }
                
                if image.frame.midX == 1418.990010960491 && image.frame.midY == 785.0 {
                                     print("I want this to be 25th 🎲🎲🎲🎲🎲🎲")
                                     image.image = UIImage(named: "kbit")
                }
                
                if image.frame.midX == 1486.441916244324 && image.frame.midY == 902.5 {
                                                  print("I want this to be 26th 🎲🎲🎲🎲🎲🎲")
                                                  image.image = UIImage(named: "kbit")
                             }
                
                if image.frame.midX == 1418.990010960491 && image.frame.midY == 1020.0 {
                                     print("I want this to be 27th 🎲🎲🎲🎲🎲🎲")
                                     image.image = UIImage(named: "kbit")
                }
                
                if image.frame.midX == 1351.5381056766582 && image.frame.midY == 1137.5 {
                                                   print("I want this to be 27th 🎲🎲🎲🎲🎲🎲")
                                                   image.image = UIImage(named: "kbit")
                              }
                
                if image.frame.midX == 1284.0862003928253 && image.frame.midY == 1255.0 {
                                                                 print("I want this to be 28th 🎲🎲🎲🎲🎲🎲")
                                                                 image.image = UIImage(named: "kbit")
                                            }
                
                if image.frame.midX == 1216.6342951089923 && image.frame.midY == 1372.5 {
                                                                                print("I want this to be 29th 🎲🎲🎲🎲🎲🎲")
                                                                                image.image = UIImage(named: "kbit")
                                                           }
                
                if image.frame.midX == 1081.7304845413264 && image.frame.midY == 1372.5 {
                                                                                               print("I want this to be 30th 🎲🎲🎲🎲🎲🎲")
                                                                                               image.image = UIImage(named: "kbit")
                                                                          }
                if image.frame.midX == 946.8266739736607 && image.frame.midY == 1372.5 {
                                                                                                              print("I want this to be 30th 🎲🎲🎲🎲🎲🎲")
                                                                                                              image.image = UIImage(named: "kbit")
                    }
            
                if image.frame.midX == 811.9228634059948 && image.frame.midY == 1372.5 {
                                                                                                                             print("I want this to be 31th 🎲🎲🎲🎲🎲🎲")
                                                                                                                             image.image = UIImage(named: "kbit")
                                   }
                
                if image.frame.midX == 677.0190528383291 && image.frame.midY == 1372.5 {
                                                                                                          print("I want this to be 32th 🎲🎲🎲🎲🎲🎲")
                                                                                                          image.image = UIImage(named: "kbit")
                }
                
                if image.frame.midX == 609.5671475544962 && image.frame.midY == 1255.0 {
                                                                                                                         print("I want this to be 33th 🎲🎲🎲🎲🎲🎲")
                                                                                                                         image.image = UIImage(named: "kbit")
                               }
                
                if image.frame.midX == 542.1152422706632 && image.frame.midY == 1137.5 {
                                                                                                          print("I want this to be 34th 🎲🎲🎲🎲🎲🎲")
                                                                                                          image.image = UIImage(named: "kbit")
                }
                
                if image.frame.midX == 474.6633369868303 && image.frame.midY == 1020.0 {
                                                                                                                        print("I want this to be 35th 🎲🎲🎲🎲🎲🎲")
                                                                                                                        image.image = UIImage(named: "kbit")
                              }
                               
                if image.frame.midX == 407.2114317029974 && image.frame.midY == 902.5 {
                                                                                                                                       print("I want this to be 36th 🎲🎲🎲🎲🎲🎲")
                                                                                                                                       image.image = UIImage(named: "kbit")
                                             }
                
                if image.frame.midX == 474.6633369868303 && image.frame.midY == 785.0 {
                                                                                                          print("I want this to be 37th 🎲🎲🎲🎲🎲🎲")
                                                                                                          image.image = UIImage(named: "kbit")
                }
                
                if image.frame.midX == 542.1152422706632 && image.frame.midY == 667.5 {
                                                                                                                 print("I want this to be 38th 🎲🎲🎲🎲🎲🎲")
                                                                                                                 image.image = UIImage(named: "kbit")
                       }
                
                if image.frame.midX == 609.5671475544962 && image.frame.midY == 550.0 {
                                                                                                                               print("I want this to be 39th 🎲🎲🎲🎲🎲🎲")
                                                                                                                               image.image = UIImage(named: "kbit")
                                     }
                
            if image.frame.midX == 677.0190528383291 && image.frame.midY == 432.5 {
                                                                                                                                         print("I want this to be 40th 🎲🎲🎲🎲🎲🎲")
                                                                                                                                         image.image = UIImage(named: "whiteMag")
                                               }
                
    if image.frame.midX == 677.0190528383291 && image.frame.midY == 432.5 {
                                                                                                            print("I want this to be 40th 🎲🎲🎲🎲🎲🎲")
                                                                                                                                 image.image = UIImage(named: "whiteMag")
    }
    
                
                let fourthRowArray: [CGPoint] = [CGPoint(x: 744.4709581221618, y: 315.0), CGPoint(x: 879.3747686898278,y: 315.0), CGPoint(x: 1014.2785792574934,y: 315.0), CGPoint(x: 1149.1823898251594,y: 315.0), CGPoint(x:1284.0862003928253,y: 315.0),
                                                 CGPoint(x: 1351.5381056766582, y: 432.5), CGPoint(x: 1418.990010960491, y: 550.0),
                                                 CGPoint(x: 1486.441916244324, y: 667.5), CGPoint(x: 1553.8938215281566, y: 785.0),
                                                 CGPoint(x: 1621.3457268119896, y: 902.5), CGPoint(x: 1553.8938215281566, y: 1020.0), CGPoint(x: 1486.441916244324, y: 1137.5), CGPoint(x: 1418.990010960491, y: 1255.0), CGPoint(x: 1351.5381056766582, y: 1372.5), CGPoint(x: 1284.0862003928253, y: 1490.0), CGPoint(x: 1149.1823898251594,y: 1490.0), CGPoint(x: 1014.2785792574934, y: 1490.0), CGPoint(x: 879.3747686898278,y: 1490.0), CGPoint(x: 744.4709581221618,y: 1490.0), CGPoint(x: 609.5671475544962, y: 1490.0),      CGPoint(x: 542.1152422706632, y: 1372.5), CGPoint(x: 474.6633369868303, y: 1255.0), CGPoint(x: 407.2114317029974, y: 1137.5), CGPoint(x: 339.7595264191645, y: 1020.0), CGPoint(x: 272.3076211353316, y: 902.5),CGPoint(x: 339.7595264191645, y: 785.0), CGPoint(x: 407.2114317029974, y: 667.5), CGPoint(x: 474.6633369868303, y: 550.0), CGPoint(x: 542.1152422706632,y: 432.5),CGPoint(x: 609.5671475544962,y: 315.0)]
                                                 
//                CGPoint(x: 339.7595264191645, y: 785.0), CGPoint(x: 407.2114317029974, y: 667.5), CGPoint(x: 474.6633369868303, y: 550.0), CGPoint(x: 542.1152422706632,y: 432.5)
                
                

                
               
             //   CGPoint(x: 542.1152422706632, y: 1372.5), CGPoint(x: 474.6633369868303, y: 1255.0), CGPoint(x: 407.2114317029974, y: 1137.5), CGPoint(x: 339.7595264191645, y: 1020.0), CGPoint(x: 272.3076211353316, y: 902.5)
                
                
                                    
                
                var _: [CGPoint] = [CGPoint(x: 1149.1823898251594, y: 1490.0),  CGPoint(x: 1081.7304845413264, y: 1372.5), CGPoint(x: 1284.0862003928253, y: 1255.0), CGPoint(x: 1216.6342951089923, y: 1137.5), CGPoint(x: 1149.1823898251594, y:  1020.0), CGPoint(x: 1081.7304845413264, y: 902.5), CGPoint(x: 1149.1823898251594,y: 785.0), CGPoint(x: 1216.6342951089923, y: 667.5), CGPoint(x: 1284.0862003928253, y: 550.0), CGPoint(x: 1351.5381056766582,y: 432.5), CGPoint(x: 1418.990010960491,y: 315.0)]
        
                if fourthRowArray.contains(image.center) {
                    print("I want this in row 4")
                    image.image = UIImage(named: "vscologo1")
                }
           
       
    
     
               
                
// redone 4th row left to right
   //             [744.4709581221618, 315.0], [879.3747686898278, 315.0], [1014.2785792574934, 315.0], [1149.1823898251594, 315.0], [1284.0862003928253, 315.0]
                
//// real next 5 more left more right
//[1351.5381056766582, 432.5]
//[1418.990010960491, 550.0]
//                [1486.441916244324, 667.5]
//                [1553.8938215281566, 785.0

                
// real next 4 less x same y
//    [744.4709581221618, 1490.0], [879.3747686898278, 1490.0], [1014.2785792574934, 1490.0], [1149.1823898251594, 1490.0]
    

  //fake
//starting 4th row here
//top left to right

          
                
                coordinate.append(image.frame.midX)
                coordinate.append(image.frame.midY)
                coordinateArray.append(coordinate)
                coordinate = []
                let gold = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
                image.setupHexagonMask(lineWidth: 10.0, color: gold, cornerRadius: 10.0)
                view.addSubview(image)
                print(coordinateArray)
                print(coordinateArray.count)
            }
        }
        
    ///////////
        
        
        
        
        
        

        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 4.0
        scrollView.zoomScale = 1.0
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//extension UIBezierPath {
//    convenience init(roundedPolygonPathInRect rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat = 0, rotationOffset: CGFloat = 0) {
//        self.init()
//
//        let theta: CGFloat = 2.0 * CGFloat.pi / CGFloat(sides) // How much to turn at every corner
//        let width = min(rect.size.width, rect.size.height)        // Width of the square
//
//        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
//
//        // Radius of the circle that encircles the polygon
//        // Notice that the radius is adjusted for the corners, that way the largest outer
//        // dimension of the resulting shape is always exactly the width - linewidth
//        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
//
//        // Start drawing at a point, which by default is at the right hand edge
//        // but can be offset
//        var angle = CGFloat(rotationOffset)
//
//        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
//        move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))
//
//        for _ in 0 ..< sides {
//            angle += theta
//
//            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
//            let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
//            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
//            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
//
//            addLine(to: start)
//            addQuadCurve(to: end, controlPoint: tip)
//        }
//
//        close()
//    }
//}
//
//extension UIImageView {
//    func setupHexagonMask(lineWidth: CGFloat, color: UIColor, cornerRadius: CGFloat) {
//        let path = UIBezierPath(roundedPolygonPathInRect: bounds, lineWidth: lineWidth, sides: 6, cornerRadius: cornerRadius, rotationOffset: CGFloat.pi / 2.0).cgPath
//
//        let mask = CAShapeLayer()
//        mask.path = path
//        mask.lineWidth = lineWidth
//        mask.strokeColor = UIColor.clear.cgColor
//        mask.fillColor = UIColor.white.cgColor
//        layer.mask = mask
//
//        let border = CAShapeLayer()
//        border.path = path
//        border.lineWidth = lineWidth
//        border.strokeColor = color.cgColor
//        border.fillColor = UIColor.clear.cgColor
//        layer.addSublayer(border)
//    }
//}
