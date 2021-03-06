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
import Foundation

class StartViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var viewMap: GMSMapView!
    
    @IBOutlet weak var moneyLeftLabel: UILabel!
    @IBOutlet weak var coloniaTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var backgroundContainer: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var resultsTableView: UITableView!
    
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    let regionRadius: CLLocationDistance = 200
    var location:CLLocation = CLLocation()
    var mapTasks = MapTasks()
    var didMovedMap:Bool = false
    var didEnterAddress:Bool = false
    var lastTime:String!
    var currentTrip:QTTrip!
    let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let kResultsCellIdentifier = "ResultsCellIdentifier"
    var restultsArray:[GMSReverseGeocodeResponse]!
    var allResults : Array<Dictionary<NSObject, AnyObject>> = []
    let marker = GMSMarker()
    var searchTimer = NSTimer()
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        // Get current location 
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
                
        viewMap.delegate = self
        
        backgroundContainer.layer.cornerRadius = 5
        searchButton.layer.cornerRadius = 5
        streetTextField.delegate = self
//        coloniaTextField.delegate = self
        
        continueButton.alpha = 0
        continueButton.layer.cornerRadius = 5
        
        lastTime = String(format: "%.0f", NSDate().timeIntervalSince1970 * 1000)
        print("last time \(lastTime)")
        
//        currentTrip = QualityTrip.MR_createEntity()
//        currentTrip.createdAt = lastTime
        QTUserManager.sharedInstance.currentUser.trip = QualityTrip.MR_createEntity()
        currentTrip = QTTrip()
        
        currentTrip.createdAt = lastTime
        
        //Regiser custom Results cell
        let registerNib = UINib(nibName: "ResultsTableViewCell", bundle: nil)
        resultsTableView.registerNib(registerNib, forCellReuseIdentifier: kResultsCellIdentifier)
        resultsTableView.alpha = 0
        resultsTableView.layer.cornerRadius = 5
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StartViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
        moneyLeftLabel.text = String(format: "$%.2f", defaults.floatForKey("moneyLeft"))
        
        marker.map = self.viewMap
        marker.draggable = true
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.flat = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.searchTimer.invalidate()
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.searchAction()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.searchTimer.invalidate()
        self.searchTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.searchAction), userInfo: nil, repeats: false)
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("text field got focus")
        if streetTextField.text?.characters.count > 0 {
            self.showTableViewAnimated()
        }
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        self.hideTableViewAnimated()
        return true
    }
    
    @IBAction func searchPressed(sender: AnyObject) {
        self.searchAction()
    }
    
    func searchTest(){
        print("triggered search after a second")
    }
    
    func searchAction(){
        searchButton.lock()
        self.dismissKeyboard()
        if allResults.count == 0{
            self.showTableViewAnimated()
        }
        
        didEnterAddress = true
        let locality = defaults.objectForKey("passengerLocality") as! String
        let administrativeArea = defaults.objectForKey("passengerAdministrativeArea") as! String
        let address = streetTextField.text! + " " + locality + " " + administrativeArea
        //        let address = streetTextField.text!
        print("address to search \(address)")
        self.mapTasks.geocodeAddress(address, withCompletionHandler: { (status, success) -> Void in
            if !success {
                print(status)
                
                if status == "ZERO_RESULTS" {
                    print("The location could not be found.")
                }
            }
            else {
                self.allResults = self.mapTasks.allResults
                self.resultsTableView.reloadData()
                self.searchButton.unlock()
                /*
                 for lookupAddressResults in self.allResults{
                 var fetchedFormattedAddress: String!
                 var fetchedAddressLongitude: Double!
                 var fetchedAddressLatitude: Double!
                 
                 fetchedFormattedAddress = lookupAddressResults["formatted_address"] as! String
                 let geometry = lookupAddressResults["geometry"] as! Dictionary<NSObject, AnyObject>
                 fetchedAddressLongitude = ((geometry["location"] as! Dictionary<NSObject, AnyObject>)["lng"] as! NSNumber).doubleValue
                 fetchedAddressLatitude = ((geometry["location"] as! Dictionary<NSObject, AnyObject>)["lat"] as! NSNumber).doubleValue
                 
                 print("-results: \(fetchedFormattedAddress) \(fetchedAddressLongitude) \(fetchedAddressLatitude)")
                 }*/
                
                
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
    
    func showTableViewAnimated(){
        self.tableViewTopConstraint.constant = -2
        self.tableViewBottomConstraint.constant = 10
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
            self.resultsTableView.alpha = 1
            self.continueButton.alpha = 0
        }) { (value) in
            self.tableViewTopConstraint.constant = 0
            self.tableViewBottomConstraint.constant = 8
            UIView.animateWithDuration(0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func hideTableViewAnimated(){
        self.tableViewTopConstraint.constant = -50
        self.tableViewBottomConstraint.constant = 42
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
            self.resultsTableView.alpha = 0
            self.continueButton.alpha = 1
        })
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
//        if (didMovedMap && !didEnterAddress) {
        if (didMovedMap) {
            UIView.animateWithDuration(0.25) {
                self.continueButton.alpha = 1
            }
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
                if let address = response?.firstResult() {
                    let lines = address.lines! as [String]
//                    let coordinates = address.coordinate
//                    print("address-1: \(address)")
//                    print("response result \(response?.results())")
                    //                self.addressLabel.text = lines.joinWithSeparator("\n")
                    self.streetTextField.text = lines.joinWithSeparator(" ")
//                    self.coloniaTextField.text = lines[1]
                    
//                    self.currentTrip.originStreet = lines.joinWithSeparator(" ")
//                    self.currentTrip.originColony = lines[1]
//                    self.currentTrip.originLatitude = String(coordinate.latitude)
//                    self.currentTrip.originLongitude = String(coordinate.longitude)
                    
                     self.currentTrip.originStreet =       lines.joinWithSeparator(" ")
                     self.currentTrip.originColony =       lines[1]
                     self.currentTrip.originLatitude =     String(coordinate.latitude)
                     self.currentTrip.originLongitude =    String(coordinate.longitude)
                    QTUserManager.sharedInstance.updateTrip(self.currentTrip)
//                    self.saveContext()
                }
            }
        }
        UIView.animateWithDuration(0.25) {
            //                    self.view.layoutIfNeeded()
            self.backgroundContainer.alpha = 1
        }
    }
    
    func reverseGeocodeCoordinateGetCountry(coordinate: CLLocationCoordinate2D) {
        print("get country location")
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
//                print("address-2: \(response)")
//                print("response results \(response?.results())")
                let locality = address.locality
                let administrativeArea = address.administrativeArea
                self.defaults.setObject(locality, forKey: "passengerLocality")
                self.defaults.setObject(administrativeArea, forKey: "passengerAdministrativeArea")
                self.defaults.synchronize()
                //                self.addressLabel.text = lines.joinWithSeparator("\n")
            }
        }
    }
    
    func saveContext(){
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc:DestinationViewController = segue.destinationViewController as! DestinationViewController
        vc.currentTripTime = lastTime
    }
    
    //Mark: - TableView Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ResultsTableViewCell = self.resultsTableView.dequeueReusableCellWithIdentifier(kResultsCellIdentifier) as! ResultsTableViewCell
        
        let address = self.allResults[indexPath.row]["formatted_address"] as? String
        let addressArray = address!.characters.split{$0 == ","}.map(String.init)
        var extraInfoString = ""
        for index in 2..<addressArray.count{
            print(index)
            extraInfoString += addressArray[index].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) + " "
        }
        cell.resultLabel.text = addressArray.first! + ", " + addressArray[1]
        cell.extraInfoLabel.text = extraInfoString
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let lookupAddressResults = self.allResults[indexPath.row]
        var fetchedFormattedAddress: String!
        var fetchedAddressLongitude: Double!
        var fetchedAddressLatitude: Double!
        
        fetchedFormattedAddress = lookupAddressResults["formatted_address"] as! String
        let geometry = lookupAddressResults["geometry"] as! Dictionary<NSObject, AnyObject>
        fetchedAddressLongitude = ((geometry["location"] as! Dictionary<NSObject, AnyObject>)["lng"] as! NSNumber).doubleValue
        fetchedAddressLatitude = ((geometry["location"] as! Dictionary<NSObject, AnyObject>)["lat"] as! NSNumber).doubleValue
        
//        let coordinate = CLLocationCoordinate2D(latitude: self.mapTasks.fetchedAddressLatitude, longitude: self.mapTasks.fetchedAddressLongitude)
        let coordinate = CLLocationCoordinate2D(latitude: fetchedAddressLatitude, longitude: fetchedAddressLongitude)
        self.viewMap.camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 16.0)
        self.streetTextField.text = fetchedFormattedAddress
//        self.currentTrip.originStreet = fetchedFormattedAddress
         currentTrip.originStreet = fetchedFormattedAddress
        //                self.currentTrip.originColony = self.coloniaTextField.text
        QTUserManager.sharedInstance.updateTrip(currentTrip)
        self.saveContext()
        self.view.endEditing(true)
        self.hideTableViewAnimated()
        
//        self.marker.position = coordinate
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.dismissKeyboard()
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
            print("did update locations")
            self.reverseGeocodeCoordinateGetCountry(location.coordinate)
            viewMap.camera = GMSCameraPosition(target: location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
            
            
//            marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            
        }
    }
}

// MARK: - GMSMapViewDelegate
extension StartViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        print("map idle at camera position target: \(position.target)")
        reverseGeocodeCoordinate(position.target)
        self.streetTextField.resignFirstResponder()
//        self.coloniaTextField.resignFirstResponder()
    }
    
    // Moved map user interaction
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        print("map moving")
        if gesture{
            didMovedMap = true
            dispatch_async(dispatch_get_main_queue(),{
                UIView.animateWithDuration(0.5){
                    self.backgroundContainer.alpha = 0.2
                }
            })
        }
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        print("marker tap")
        return true
    }
    
    func mapView(mapView: GMSMapView, didEndDraggingMarker marker: GMSMarker) {
        didMovedMap = true
        print("position \(marker.position)")
//        reverseGeocodeCoordinate(marker.position)
    }
    
    func mapView(mapView: GMSMapView, didBeginDraggingMarker marker: GMSMarker) {
        print("start dragging")
    }
    
    func didTapMyLocationButtonForMapView(mapView: GMSMapView) -> Bool {
        locationManager.startUpdatingLocation()
        didMovedMap = true
        print("my location button tapped \(mapView.camera.target)")
        reverseGeocodeCoordinate(mapView.camera.target)
        return true
    }
    
//    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
//        didMovedMap = true
//        print("coordinates \(coordinate)")
//        marker.position = coordinate
//        reverseGeocodeCoordinate(coordinate)
//    }
    
}