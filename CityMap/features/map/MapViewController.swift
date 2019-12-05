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
    @IBOutlet weak var addressField: UITextField!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 0.05
    var previousLocation: CLLocation?
    
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
            startTrackingUserLocation()
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
    
    func startTrackingUserLocation(){
        mapView.showsUserLocation = true
        centerViewUserLocation()
        locationManager.startUpdatingLocation()

    }
    
    func getLocation() -> CLLocation {
        var latitude: CLLocationDegrees?
        var longitude: CLLocationDegrees?
        let geoCoder = CLGeocoder()
        print("----------1111--------")
        
        let address = "London, England"
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            print("0----------\(longitude)--------\(latitude)---------0")
            }
        
        return CLLocation(latitude: latitude!, longitude: longitude!)
    }
    
    func getDirection(){
        
        guard  let location = locationManager.location?.coordinate else { return }
            let request = self.createDirectionRequest(from: location)
            let directions = MKDirections(request: request)
            
            directions.calculate{ [unowned self] (response, error) in
                guard let respose = response else { return }
                
                for route in (response?.routes)! {
                    self.mapView.add(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
        }
    
    
    func createDirectionRequest(from location: CLLocationCoordinate2D) -> MKDirectionsRequest{
        
        let destinationCoordinate = getLocation().coordinate
        print("PASO getLocation")
        let startingLocation = MKPlacemark(coordinate: location)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    @IBAction func goButtonTapped(_ sender: Any) {
        getDirection()
        print("--------------------------------------------")
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

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue

        return renderer
    }
}

