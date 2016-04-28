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

class StartViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var viewMap: GMSMapView!
    
    @IBOutlet weak var coloniaTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var backgroundContainer: UIView!
    
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    
    let regionRadius: CLLocationDistance = 200
    var location:CLLocation = CLLocation()
    
    var mapTasks = MapTasks()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        // Get current location 
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
                
        viewMap.delegate = self
        
//        plotAddress()
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
        viewMap.camera = camera
     
        backgroundContainer.layer.cornerRadius = 10
        searchButton.layer.cornerRadius = 10
        streetTextField.delegate = self
        coloniaTextField.delegate = self
        
    }
    
    
    @IBAction func searchPressed(sender: AnyObject) {
        let address = streetTextField.text! + " " + coloniaTextField.text!
        print(address)
        self.mapTasks.geocodeAddress(address, withCompletionHandler: { (status, success) -> Void in
            if !success {
                print(status)
                
                if status == "ZERO_RESULTS" {
                    print("The location could not be found.")
                }
            }
            else {
                let coordinate = CLLocationCoordinate2D(latitude: self.mapTasks.fetchedAddressLatitude, longitude: self.mapTasks.fetchedAddressLongitude)
                self.viewMap.camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 14.0)
            }
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                print(lines)
//                self.addressLabel.text = lines.joinWithSeparator("\n")
                self.streetTextField.text = lines.first
                self.coloniaTextField.text = lines[1]
                UIView.animateWithDuration(0.25) {
//                    self.view.layoutIfNeeded()
                    self.backgroundContainer.alpha = 1
                }
            }
        }
    }
}

extension StartViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            viewMap.myLocationEnabled = true
            viewMap.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            viewMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
        
    }
}

// MARK: - GMSMapViewDelegate
extension StartViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
        self.streetTextField.resignFirstResponder()
        self.coloniaTextField.resignFirstResponder()
    }
    
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        dispatch_async(dispatch_get_main_queue(),{
            UIView.animateWithDuration(0.5){
                self.backgroundContainer.alpha = 0.2
            }
        })
    }
    
}