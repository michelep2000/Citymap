//
//  MapViewController.swift
//  CityMap
//
//  Created by Michele Alfonso Pardo Pezzullo on 4/12/19.
//  Copyright © 2019 MICHELE ALFONSO PARDO PEZZULLO. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 0.05
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewUserLocation(){
        if let location = locationManager.location?.coordinate{
            let span    = MKCoordinateSpan(latitudeDelta: regionInMeters, longitudeDelta: regionInMeters)
            let region  = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            print("----------------------------------------------------------")
        }
        print("------------------------ERROR---------------------------")
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            //setup location manager
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            //alert
        }
    }
    
    func  checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //do map stuff
            mapView.showsUserLocation = true
            centerViewUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            //alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span   = MKCoordinateSpan(latitudeDelta: regionInMeters, longitudeDelta: regionInMeters)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}

