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

class DestinationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var moneyLeftLabel: UILabel!
    @IBOutlet weak var coloniaTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var backgroundContainer: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    let regionRadius: CLLocationDistance = 200
    var location:CLLocation = CLLocation()
    var mapTasks = MapTasks()
    var didMovedMap:Bool = false
    var didEnterAddress:Bool = false
    var currentTripTime:String = ""
    var currentTrip:QTTrip!
    let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let kResultsCellIdentifier = "ResultsCellIdentifier"
    var allResults : Array<Dictionary<NSObject, AnyObject>> = []
    var searchTimer = NSTimer()
    var comingFromSummary:Bool = Bool()
    
    @IBAction func unwindToSetDestination(segue: UIStoryboardSegue) {}
    
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
        
        backgroundContainer.layer.cornerRadius = 5
        searchButton.layer.cornerRadius = 5
        streetTextField.delegate = self
//        coloniaTextField.delegate = self
        
        continueButton.alpha = 0
        continueButton.layer.cornerRadius = 5
        
        //Regiser custom Results cell
        let registerNib = UINib(nibName: "ResultsTableViewCell", bundle: nil)
        resultsTableView.registerNib(registerNib, forCellReuseIdentifier: kResultsCellIdentifier)
        resultsTableView.alpha = 0
        resultsTableView.layer.cornerRadius = 5
        
        moneyLeftLabel.text = String(format: "$%.2f", defaults.floatForKey("moneyLeft"))
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        currentTrip = QTUserManager.sharedInstance.getCurrentTrip()
        if comingFromSummary == true {
            self.navigationItem.setHidesBackButton(true, animated: false)
            print("coming from summary")
        }else{
            print("normal flow")
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchPressed(sender: AnyObject) {
        self.searchAction()
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
                    print(lines)
                    //                self.addressLabel.text = lines.joinWithSeparator("\n")
                    self.streetTextField.text = lines.joinWithSeparator(" ")
//                    self.coloniaTextField.text = lines[1]
                    
                    self.currentTrip.destinationStreet = lines.joinWithSeparator(" ")
                    self.currentTrip.destinationColony = lines[1]
                    self.currentTrip.destinationLatitude = String(coordinate.latitude)
                    self.currentTrip.destinationLongitude = String(coordinate.longitude)
                    
//                     self.currentTrip.destinationStreet =      lines.joinWithSeparator(" ")
//                     self.currentTrip.destinationColony =      lines[1]
//                     self.currentTrip.destinationLatitude =    String(coordinate.latitude)
//                     self.currentTrip.destinationLongitude =   String(coordinate.longitude)
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
    
    func saveContext(){
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    @IBAction func continuePressed(sender: AnyObject) {
        if comingFromSummary {
            self.performSegueWithIdentifier("fromDestinationToSummary", sender: nil)
        }else{
            self.performSegueWithIdentifier("toSummary", sender: nil)
        }
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSummary" {
            let vc:SummaryTripViewController = segue.destinationViewController as! SummaryTripViewController
            vc.currentTripTime = self.currentTripTime
        }else{
            let vc:FindTaxiViewController = segue.destinationViewController as! FindTaxiViewController
            vc.currentTripTime = self.currentTripTime
            vc.fromMyTrips = false
        }
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
//        self.currentTrip.destinationStreet = fetchedFormattedAddress
        currentTrip.destinationStreet = fetchedFormattedAddress
        QTUserManager.sharedInstance.updateTrip(currentTrip)
        //                self.currentTrip.originColony = self.coloniaTextField.text
//        self.saveContext()
        self.view.endEditing(true)
        self.hideTableViewAnimated()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.dismissKeyboard()
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
//        self.coloniaTextField.resignFirstResponder()
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
