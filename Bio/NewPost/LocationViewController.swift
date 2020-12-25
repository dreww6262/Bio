//
//  LocationViewController.swift
//  Bio
//
//  Created by Ann McDonough on 12/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController : UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
//    var resultSearchController:UISearchController? = nil
    var searchBar = UISearchBar()
    var searchArray = [String]()
    var matchingItems:[MKMapItem] = []
    var mapView = MKMapView()
  //  var tableView = UITableView()
    @IBOutlet weak var tableView: UITableView!
    var userDataVM: UserDataVM?
     let locationManager = CLLocationManager()
  //  var mapView = MKMapView()
     
     override func viewDidLoad() {
         super.viewDidLoad()
        
        view.addSubview(searchBar)
        searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/12)
        searchBar.delegate = self
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.requestWhenInUseAuthorization()
         locationManager.requestLocation()
//         resultSearchController = UISearchController(searchResultsController: tableView!)
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: view.frame.height/12, width: view.frame.width, height: view.frame.height*(11/12))
        tableView.delegate = self
        tableView.dataSource = self
        //resultSearchController?.searchResultsUpdater = locationSearchTable as? UISearchResultsUpdating
//         let searchBar = resultSearchController!.searchBar
//         searchBar.sizeToFit()
//         searchBar.placeholder = "Search for places"
//         navigationItem.titleView = resultSearchController?.searchBar
//         resultSearchController?.hidesNavigationBarDuringPresentation = false
//         resultSearchController?.dimsBackgroundDuringPresentation = true
//         definesPresentationContext = true
  //      present(locationSearchTable, animated: false)
         //locationSearchTable.mapView = mapView
     }
    
    

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
   updateSearchResultsForSearchController()
    }
    
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      //  searchArray = blockedArray
   //     sortSearchArray()
        tableView.reloadData()
    }
    

    
    
    func updateSearchResultsForSearchController() {
        print("in update search results")
            //guard let mapView = mapView,
           guard let searchBarText = searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                print("returning")
                return
            }
            self.matchingItems = response.mapItems
            print("This is matching items \(self.matchingItems)")
            self.tableView.reloadData()
        }
    }
    
    
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchBarText = searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = self.matchingItems[indexPath.row]
        print("This is selected Location \(selectedLocation)")
        
  
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchingItems.count
    }
    
    // cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     //   print("This is height for row at: \(self.view.frame.height/8)")
    //    return self.view.frame.height/8
        return view.frame.height/10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationCell
       // cell.frame.height = self.view.frame.height/10
      //  cell.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/10)
        //let cellTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))

      //  print("l \(cell)")
       
        cell.label.text = matchingItems[indexPath.row].name
     //   cell.textLabel.text = matchingItems[indexPath.row].placemark ?? ""
  
        return cell
    }

    
    
    
    
    
 }

 extension LocationViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
             locationManager.requestLocation()
         }
     }
     
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         if let location = locations.first {
//            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//            let region = MKCoordinateRegion(center: location.coordinate, span: span)
//            mapView.setRegion(region, animated: true)
         //   mapView = MKMapView()
            print("Location data received.")
                   print(location)
         }
     }
     
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error)")
     }
 }
