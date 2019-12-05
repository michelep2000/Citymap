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
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
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
    
    func getLocation() {
        
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = addressField.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start{ (response, error) in
            
            if response == nil{
                print("ERROR")
            }else{
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                self.location = CLLocation(latitude: latitude!, longitude: longitude!)
                let annotation = MKPointAnnotation()
                annotation.title = self.addressField.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.mapView.setRegion(region, animated: true)
                self.getDirection()
                print("COMPLETADO")
            }
        }
        
        
    }
    
    func getDirection(){
        guard  let location = locationManager.location?.coordinate else { return }
        let request = self.createDirectionRequest(from: location)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
            
        directions.calculate{ [unowned self] (response, error) in
            guard let respose = response else { return }
                
            for route in (response?.routes)! {
                self.mapView.add(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func resetMapView(withNew directions: MKDirections){
        mapView.removeOverlays(mapView.overlays)
    }
    
    
    func createDirectionRequest(from location: CLLocationCoordinate2D) -> MKDirectionsRequest{
        
        let destinationCoordinate = self.location?.coordinate
        let startingLocation = MKPlacemark(coordinate: location)
        let destination = MKPlacemark(coordinate: destinationCoordinate!)
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    @IBAction func goButtonTapped(_ sender: Any) {
        if addressField.text != "" {
            getLocation()
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

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue

        return renderer
    }
}

