//
//  StartViewController.swift
//  QualityTaxi
//
//  Created by Felix Olivares on 11/7/15.
//  Copyright © 2015 Felix Olivares. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class StartViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var viewMap: GMSMapView!
    
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    
    let regionRadius: CLLocationDistance = 200
    var location:CLLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let initialLocation = CLLocation(latitude: 21.5083, longitude: -104.89306)
//        centerMapOnLocation(initialLocation)
        // Do any additional setup after loading the view.
        
        
        // Get current location 
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
//        plotAddress()
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
        viewMap.camera = camera
        viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            viewMap.myLocationEnabled = true
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            viewMap.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 10.0)
            viewMap.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
    }
    
    
/*
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last as CLLocation!
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
//        self.map.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
//        let userLocation:CLLocation = locations[0] as CLLocation
        
//        centerMapOnLocation(location)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    // MARK: - location manager to authorize user location for Maps app
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    func plotAddress(){
        let address = "Lago Erie 74, Tepic Nayarit, Mexico"
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                //                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                self.centerMapOnLocation(placemark.location!)
            }
        })
        self.locationManager.stopUpdatingLocation()
    }
    
    @IBAction func showCurrentLocation(sender: AnyObject) {
        self.locationManager.startUpdatingLocation()
        centerMapOnLocation(location)
    }
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
