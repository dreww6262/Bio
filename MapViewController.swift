//
//  MapViewController.swift
//  Bio
//
//  Created by Ann McDonough on 10/13/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var spot: Spot!
    let regionDistance: CLLocationDistance = 750
    var userDataVM: UserDataVM?
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    // MARK: - Search
    
    fileprivate var searchController: UISearchController!
    fileprivate var localSearchRequest: MKLocalSearch.Request!
    fileprivate var localSearch: MKLocalSearch!
    fileprivate var localSearchResponse: MKLocalSearch.Response!
    
    // MARK: - Map variables
    
    fileprivate var annotation: MKAnnotation!
    //  fileprivate var locationManager: CLLocationManager!
    fileprivate var isCurrentLocation: Bool = false
    
    // MARK: - Activity Indicator
    
    fileprivate var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - UIViewController's methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        mapView.frame = CGRect(x: 0, y: searchBar.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - searchBar.frame.height)
        
        
        let currentLocationButton = UIBarButtonItem(title: "Current Location", style: UIBarButtonItem.Style.plain, target: self, action: #selector(MapViewController.currentLocationButtonAction(_:)))
        self.navigationItem.leftBarButtonItem = currentLocationButton
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(MapViewController.searchButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = searchButton
        
        mapView.delegate = self
        mapView.mapType = .hybrid
        
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.center = self.view.center
    }
    
    // MARK: - Actions
    
    func updateUserInterface() {
        updateMap()
    }
    
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(spot)
        mapView.setCenter(spot.coordinate, animated: true)
    }
    
    @objc func currentLocationButtonAction(_ sender: UIBarButtonItem) {
        if (CLLocationManager.locationServicesEnabled()) {
            if locationManager == nil {
                locationManager = CLLocationManager()
            }
            locationManager?.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            isCurrentLocation = true
        }
    }
    
    // MARK: - Search
    
    @objc func searchButtonAction(_ button: UIBarButtonItem) {
        if searchController == nil {
            searchController = UISearchController(searchResultsController: nil)
        }
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { [weak self] (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil {
                let alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
                alert.show()
                return
            }
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = searchBar.text
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            
            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self!.mapView.centerCoordinate = pointAnnotation.coordinate
            self!.mapView.addAnnotation(pinAnnotationView.annotation!)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !isCurrentLocation {
            return
        }
        
        isCurrentLocation = false
        
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = location!.coordinate
        pointAnnotation.title = ""
        mapView.addAnnotation(pointAnnotation)
    }

}

extension MapViewController: CLLocationManagerDelegate {
    func getLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
        
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            print("I'm sorry - can't show location. User has not authorized it.")
        case .restricted:
            print("Access deined. Likely parental controls restrict location services in this app.")
            showAlert(title: "Access Denied.", message: "Likely parental controls restrict location services in this app.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard spot.name == "" else {
//            return
////        }
//    let geoCoder = CLGeocoder()
//        var name = ""
//        var address = ""
//        currentLocation = locations.last
//        spot.coordinate = currentLocation.coordinate
//        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {placemarks, error in
//            if placemarks != nil {
//            let placemark = placemarks?.last
//            name = placemark?.name ?? "name unknown"
//            //need to import conetacts to use this code
//
//        if let postalAddress = placemark?.postalAddress {
//            address = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
//        }
//    } else {
//    print("error retreiving place. error code: \(error!.localizedDescription)")
//    }
//    self.spot.name = name
//    self.spot.address = address
//    self.updateUserInterface()
//    })
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to get user location")
}

}
