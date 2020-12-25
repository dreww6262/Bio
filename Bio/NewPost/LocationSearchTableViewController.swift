//
//  LocationSearchTableViewController.swift
//  Bio
//
//  Created by Ann McDonough on 12/16/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTableViewController : UITableViewController, MKLocalSearchCompleterDelegate {
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var searchTerms: [String] = []
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
    private var completer: MKLocalSearchCompleter = MKLocalSearchCompleter()

    // triggers the search-as-you-type
    //
    func searchFor(term: String) {
        completer.delegate = self
        completer.region = MKCoordinateRegion(.world)
        completer.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
        completer.queryFragment = term
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results.filter { result in
            guard result.title.contains(",") || !result.subtitle.isEmpty else { return false }
            guard !result.subtitle.contains("Nearby") else { return false }
            return true
        }
        self.searchTerms = results.map { $0.title + ($0.subtitle.isEmpty ? "" : ", " + $0.subtitle) }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchingItems.count
    }
    
    // cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     //   print("This is height for row at: \(self.view.frame.height/8)")
    //    return self.view.frame.height/8
        return view.frame.height/10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationCell
       // cell.frame.height = self.view.frame.height/10
      //  cell.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/10)
        //let cellTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))

        print("This is cell \(cell)")
        cell.label.text = parseAddress(selectedItem: (matchingItems[indexPath.row].placemark))
        //cell.label.text = "\(matchingItems[indexPath.row].placemark)"
     //   cell.textLabel.text = matchingItems[indexPath.row].placemark ?? ""
  
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("This is matching items.count \(matchingItems.count)")
//        return matchingItems.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! LocationCell
//        let selectedItem = matchingItems[indexPath.row].placemark
//     //   cell.textLabel?.text = selectedItem.name
//      //  cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
//        cell.label.text = selectedItem.name
//        print("This is cell.label.text \(cell.label.text)")
//        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//
//    }
    
}

    
   






