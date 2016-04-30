//
//  DestinationViewController.swift
//  QualityTaxi
//
//  Created by Developer on 4/28/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DestinationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var coloniaTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var backgroundContainer: UIView!
    @IBOutlet weak var continueButton: UIButton!
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    let regionRadius: CLLocationDistance = 200
    var location:CLLocation = CLLocation()
    var mapTasks = MapTasks()
    var didMovedMap:Bool = false
    var didEnterAddress:Bool = false
    var currentTripTime:String = ""
    var currentTrip:QualityTrip!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get current location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        viewMap.delegate = self
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
        viewMap.camera = camera
        
        backgroundContainer.layer.cornerRadius = 10
        searchButton.layer.cornerRadius = 10
        streetTextField.delegate = self
        coloniaTextField.delegate = self
        
        self.continueButton.alpha = 0
        
        print("current trip time \(currentTripTime)")
        
        let predicate:NSPredicate = NSPredicate(format: "createdAt == %@", currentTripTime)
        let request:NSFetchRequest = QualityTrip.MR_requestAllWithPredicate(predicate)
        let allTrips = QualityTrip.MR_executeFetchRequest(request)
        currentTrip = allTrips?.first as! QualityTrip
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchPressed(sender: AnyObject) {
        searchButton.lock()
        didEnterAddress = true
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
                self.viewMap.camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 16.0)
                self.searchButton.unlock()
                self.currentTrip.destinationStreet = self.streetTextField.text
                self.currentTrip.destinationColony = self.coloniaTextField.text
                self.saveContext()
                UIView.animateWithDuration(0.25) {
                    self.continueButton.alpha = 1
                }
            }
        })
    }

    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        if (didMovedMap && !didEnterAddress) {
            UIView.animateWithDuration(0.25) {
                self.continueButton.alpha = 1
            }
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
                if let address = response?.firstResult() {
                    let lines = address.lines! as [String]
                    print(lines)
                    //                self.addressLabel.text = lines.joinWithSeparator("\n")
                    self.streetTextField.text = lines.first
                    self.coloniaTextField.text = lines[1]
                    self.currentTrip.destinationStreet = lines.first
                    self.currentTrip.destinationColony = lines[1]
                    self.saveContext()
                }
            }
        }
        UIView.animateWithDuration(0.25) {
            //                    self.view.layoutIfNeeded()
            self.backgroundContainer.alpha = 1
        }
    }
    
    func saveContext(){
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    @IBAction func continuePressed(sender: AnyObject) {
        self.performSegueWithIdentifier("toSummary", sender: nil)
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc:SummaryTripViewController = segue.destinationViewController as! SummaryTripViewController
        vc.currentTripTime = self.currentTripTime
    }
    

}

extension DestinationViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            viewMap.myLocationEnabled = true
            viewMap.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            viewMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
        
    }
}

// MARK: - GMSMapViewDelegate
extension DestinationViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
        self.streetTextField.resignFirstResponder()
        self.coloniaTextField.resignFirstResponder()
    }
    
    // Moved map user interaction
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        if gesture{
            didMovedMap = true
            dispatch_async(dispatch_get_main_queue(),{
                UIView.animateWithDuration(0.5){
                    self.backgroundContainer.alpha = 0.2
                }
            })
        }
    }
    
}
