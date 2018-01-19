//
//  ViewController.swift
//  Venue Search
//
//  Created by Mudasar Javed on 15/1/18.
//  Copyright © 2018 RA1N ENTERTAINMENT. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, LocationProtocol {
    
    //Search button
    let button: UIButton = {
        let attributes = UIButton()
        attributes.translatesAutoresizingMaskIntoConstraints = false
        attributes.setTitle("Search", for: .normal)
        attributes.backgroundColor = UIColor.black
        attributes.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        return attributes
    }()
    
    //Main mapView
    let mapView: MKMapView = MKMapView()

    //Location manage
    let locationManager = CLLocationManager()
    
    //Current latitude and longitude
    var currentLat = 0.0
    var currentLong = 0.0
    
    //Has initial location been set?
    var initialLocation = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set mapView's attributes
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        mapView.center = view.center
        
        view.addSubview(mapView)
        view.addSubview(button)
        layoutConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Request location permission
        locationManager.requestWhenInUseAuthorization()
        //If granted
        if ( CLLocationManager.locationServicesEnabled() ) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }

    //Called when current user's location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Set current lat & long
        let location = locations.first
        currentLat = location!.coordinate.latitude
        currentLong = location!.coordinate.longitude
        //If initial location hasn't been set, create a pin on the current location then zoom in on it
        if (self.initialLocation == false) {
            let currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake( location!.coordinate.latitude, location!.coordinate.longitude)
            mapView.setRegion(MKCoordinateRegionMake(currentLocation, MKCoordinateSpanMake(0.05, 0.05)), animated: true)
            let annotation = Annotation(title: "Current Location", subtitle: "",coordinate: currentLocation)
            self.mapView.addAnnotation(annotation)
        }
        //Set initial location to true
        self.initialLocation = true
    }
    
    //Protocol function called by searchView controller to add a pin and zoom in on it
    func setLocation(location: JSON) {
        //Create annotation and add it
        let annotation = Annotation(
            title: location["venue"]["name"].string!, subtitle: "Address: \(location["venue"]["location"]["address"].exists() ? location["venue"]["location"]["address"].string! : "Private Address") || Distance: \(location["venue"]["location"]["distance"].intValue)m",
            coordinate: CLLocationCoordinate2DMake(location["venue"]["location"]["lat"].doubleValue, location["venue"]["location"]["lng"].doubleValue))
        self.mapView.addAnnotation(annotation)
        //Zoom in on annotation
        self.mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpanMake(0.0, 0.0)), animated: true)
    }
    
    //Set up constraints
    func layoutConstraints() {
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.50).isActive = true
    }
    
    //Called when an annotation is selected
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.mapView.setRegion(MKCoordinateRegion(center: view.annotation!.coordinate, span:  MKCoordinateSpanMake(0.05, 0.05)), animated: true)
    }
    
    //Search button pressed
    @objc func searchPressed(sender: UIButton) {
        //Set title, pass current position and declare location protocol for receiveing the selected venue
        let searchViewController = SearchViewController()
        searchViewController.title = "Search"
        searchViewController.currentLong = currentLong
        searchViewController.currentLat = currentLat
        searchViewController.locationProtocol = self
        //Push searchView ontop of current view
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
}

