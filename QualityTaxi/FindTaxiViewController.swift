//
//  FindTaxiViewController.swift
//  QualityTaxi
//
//  Created by Developer on 4/29/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit
import FontAwesome_swift
import CoreLocation


class FindTaxiViewController: UIViewController, UIGestureRecognizerDelegate, GMSMapViewDelegate {

    var taskTimer: NSTimer!
    let defaults = NSUserDefaults.standardUserDefaults()
    var moneyLeft = Float()
    var isMapTabActive:Bool = false
    var isInformationTabActive:Bool = false
    var isOptionsTabActive:Bool = false
    var locations = [CLLocationCoordinate2D]()
    var timerLocations:NSTimer!
    var i:Int = 0
    var locationMarker: GMSMarker!
    var bounds:GMSCoordinateBounds!
    var update:GMSCameraUpdate!
    var currentTripTime:String = ""
    var currentTrip:QTTrip!
    var fromMyTrips:Bool!
    
    //Tab bar
    @IBOutlet weak var secondIconLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondIconHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondIconLabel: UILabel!
    @IBOutlet weak var secondIcon: UILabel!
    @IBOutlet weak var firstIconHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstIconLabel: UILabel!
    @IBOutlet weak var firstIcon: UILabel!
    @IBOutlet weak var secondTab: UIView!
    
    @IBOutlet weak var thirdIcon: UILabel!
    @IBOutlet weak var thirdIconLabel: UILabel!
    @IBOutlet weak var thirdIconLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdIconHorizontalContstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdTab: UIView!
    
    @IBOutlet weak var optionsContainerView: UIView!
//    @IBOutlet weak var secondIconLabel: UILabel!
//    @IBOutlet weak var secondIcon: UILabel!
//    @IBOutlet weak var secondIconLabelBottomConstraint: NSLayoutConstraint!
//    @IBOutlet weak var secondIconHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstTab: UIView!
//    @IBOutlet weak var firstIconHorizontalConstraint: NSLayoutConstraint!
//    @IBOutlet weak var firstIconLabel: UILabel!
    
    @IBOutlet weak var mainContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeAproxLabel: UILabel!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var carPlatesLabel: UILabel!
    @IBOutlet weak var carColorLabel: UILabel!
    @IBOutlet weak var carKindLabel: UILabel!
    @IBOutlet weak var firstIconLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taxiImage: UIImageView!
    @IBOutlet weak var driverDetailsContainer: UIView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var goToStartBtn: UIButton!
    @IBOutlet weak var moneyLeftLabel: UILabel!
//    @IBOutlet weak var firstIcon: UILabel!
    @IBOutlet weak var mainContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentTrip = QTUserManager.sharedInstance.getCurrentTrip()
        
//        segmentedControl.alpha = 0
        viewMap.delegate = self
        viewMap.alpha = 0
        viewMap.layer.cornerRadius = 5
        goToStartBtn.layer.cornerRadius = 5
        goToStartBtn.alpha = 0
        infoContainerView.alpha = 0
        optionsContainerView.alpha = 0
        
        driverDetailsContainer.layer.cornerRadius = 5
        driverDetailsContainer.layer.borderColor = UIColor(hexString: "D3D5D5").CGColor
        driverDetailsContainer.layer.borderWidth = 1
        
        moneyLeftLabel.text = String(format: "$%.2f", defaults.floatForKey("moneyLeft"))
        
        let tapFirst = UITapGestureRecognizer(target: self, action: #selector(pressedFirstTab))
        tapFirst.delegate = self
        firstTab.addGestureRecognizer(tapFirst)
        
        let tapSecond = UITapGestureRecognizer(target: self, action: #selector(pressedSecondTab))
        tapSecond.delegate = self
        secondTab.addGestureRecognizer(tapSecond)
        
        let tapThird = UITapGestureRecognizer(target: self, action: #selector(pressedThirdTab))
        tapThird.delegate = self
        thirdTab.addGestureRecognizer(tapThird)
            
        
        firstIcon.font = UIFont.fontAwesomeOfSize(14)
        firstIcon.text = String.fontAwesomeIconWithCode("fa-map-marker")
        firstIcon.textColor = UIColor(hexString: "F7F7F7")
        firstIconLabel.alpha = 0
        
        secondIcon.font = UIFont.fontAwesomeOfSize(14)
        secondIcon.text = String.fontAwesomeIconWithCode("fa-taxi")
        secondIcon.textColor = UIColor(hexString: "F7F7F7")
        secondIconLabel.alpha = 0
        
        thirdIcon.font = UIFont.fontAwesomeOfSize(14)
        thirdIcon.text = String.fontAwesomeIconWithCode("fa-cog")
        thirdIcon.textColor = UIColor(hexString: "F7F7F7")
        thirdIconLabel.alpha = 0
        
        
        self.firstIconLabel.alpha = 0
        self.firstIcon.textColor = UIColor(hexString: "F7F7F7")
        
        //Information tab and message tab are always hidden at the begining
        secondIconLabel.alpha = 0
        secondIcon.textColor = UIColor(hexString: "7F7F7F")
        thirdIconLabel.alpha = 0
        thirdIcon.textColor = UIColor(hexString: "7F7F7F")
        
        mainContainer.layer.borderWidth = 1
        mainContainer.layer.borderColor = UIColor(hexString: "E4E4E4").CGColor
        
        self.addLocations()
        
//        let predicate:NSPredicate = NSPredicate(format: "createdAt == %@", currentTripTime)
//        let request:NSFetchRequest = QualityTrip.MR_requestAllWithPredicate(predicate)
//        let allTrips = QualityTrip.MR_executeFetchRequest(request)
//        currentTrip = allTrips?.first as! QualityTrip
        
        
        driverName.text = currentTrip.driverName
        carKindLabel.text = currentTrip.carKind
        carColorLabel.text = currentTrip.carColor
        carPlatesLabel.text = currentTrip.carPlates
        timeAproxLabel.text = currentTrip.timeAprox
        
//        driverName.text = QTUserManager.sharedInstance.currentUser.trip?.driverName
//        carKindLabel.text = QTUserManager.sharedInstance.currentUser.trip?.carKind
//        carColorLabel.text = QTUserManager.sharedInstance.currentUser.trip?.carColor
//        carPlatesLabel.text = QTUserManager.sharedInstance.currentUser.trip?.carPlates
//        timeAproxLabel.text = QTUserManager.sharedInstance.currentUser.trip?.timeAprox
        
        if !fromMyTrips {
            self.navigationItem.setHidesBackButton(true, animated: false)
//            EZLoadingActivity.show("Solicitando Taxi", disableUI: false)
            mainContainerBottomConstraint.constant = 65
            taskTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(FindTaxiViewController.runTimedCode), userInfo: nil, repeats: true)
        }else{
            goToStartBtn.hidden = true
            mainContainerBottomConstraint.constant = 10
//            let isActive:Bool = currentTrip.isActive as! Bool
            let isActive:Bool = currentTrip.isActive!
            self.showElementsFromMyTrips(isActive)
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.timerLocations.invalidate()
    }
    
    func addLocations(){
        let location1:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.513785, longitude: -104.890915)
        locations.append(location1)
        
        let location2:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.513202, longitude: -104.891144)
        locations.append(location2)
        
        let location3:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.512972, longitude: -104.891255)
        locations.append(location3)
        
        let location4:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.512792, longitude: -104.891314)
        locations.append(location4)
        
        let location5:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.512448, longitude: -104.891470)
        locations.append(location5)
        
        let location6:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.512198, longitude: -104.891304)
        locations.append(location6)
        
        let location7:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.512129, longitude: -104.891057)
        locations.append(location7)
        
        let location8:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.512022, longitude: -104.890791)
        locations.append(location8)
        
        let location9:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.511805, longitude: -104.890772)
        locations.append(location9)
        
        let location10:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.511426, longitude: -104.890895)
        locations.append(location10)
        
        let location11:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.511079, longitude: -104.890890)
        locations.append(location11)
        
        let location12:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.510937, longitude: -104.890517)
        locations.append(location12)
        
        let location13:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.510750, longitude: -104.889967)
        locations.append(location13)
        
        let location14:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.510480, longitude: -104.890047)
        locations.append(location14)
        
        let location15:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.510071, longitude: -104.890264)
        locations.append(location15)
        
        self.locationMarker = GMSMarker(position: location1)
        self.viewMap.camera = GMSCameraPosition(target: location1, zoom: 16, bearing: 0, viewingAngle: 0)
        
        bounds = GMSCoordinateBounds.init(coordinate: location1, coordinate: location15)
        update = GMSCameraUpdate.fitBounds(bounds)
        viewMap.moveCamera(update)
    }
    
    func pressedFirstTab(){
        if !isMapTabActive {
            //Map fade in
            self.firstFadeIn()
            
            //Information and Options fade out
            if isInformationTabActive {
                self.secondFadeOut()
            }
            if isOptionsTabActive {
                self.thirdFadeOut()
            }
            
            UIView.animateWithDuration(0.2, animations: {
                self.infoContainerView.alpha = 0
                self.optionsContainerView.alpha = 0
                self.viewMap.alpha = 1
                }, completion: { (complete) in
                    UIView.animateWithDuration(0.1, animations: {
                        
                    })
            })
        }
    }
    
    func pressedSecondTab(){
        if !isInformationTabActive{
            //Information fade in
            self.secondFadeIn()
            
            //Map and Options fade out
            if isMapTabActive{
                self.firstFadeOut()
            }
            if isOptionsTabActive {
                self.thirdFadeOut()
            }
            
            UIView.animateWithDuration(0.2, animations: {
                self.viewMap.alpha = 0
                self.optionsContainerView.alpha = 0
                self.infoContainerView.alpha = 1
                }, completion: { (complete) in
                    UIView.animateWithDuration(0.1, animations: {
                        
                    })
            })
        }
    }
    
    func pressedThirdTab(){
        if !isOptionsTabActive{
            //Options fade out
            self.thirdFadeIn()
            
            //Map and Info fade out
            if isMapTabActive{
                self.firstFadeOut()
            }
            if isInformationTabActive {
                self.secondFadeOut()
            }
            
            UIView.animateWithDuration(0.2, animations: { 
                self.viewMap.alpha = 0
                self.infoContainerView.alpha = 0
                self.optionsContainerView.alpha = 1
                }, completion: { (complete) in
                    
            })
            
        }
    }

    func firstFadeIn(){
        firstIconHorizontalConstraint.constant -= 4
        firstIconLabelBottomConstraint.constant += 7
        UIView.animateWithDuration(0.2) {
            self.firstIconLabel.alpha = 1
            self.firstIcon.textColor = UIColor(hexString: "F7F7F7")
//            self.view.layoutIfNeeded()
        }
        isMapTabActive = true
    }
    
    func firstFadeOut(){
        firstIconHorizontalConstraint.constant += 4
        firstIconLabelBottomConstraint.constant -= 7
        UIView.animateWithDuration(0.2) {
            self.view.layoutIfNeeded()
            self.firstIconLabel.alpha = 0
            self.firstIcon.textColor = UIColor(hexString: "7F7F7F")
        }
        isMapTabActive = false
    }
    
    func secondFadeIn(){
        secondIconHorizontalConstraint.constant -= 4
        secondIconLabelBottomConstraint.constant += 7
        UIView.animateWithDuration(0.2) {
            self.secondIconLabel.alpha = 1
            self.secondIcon.textColor = UIColor(hexString: "F7F7F7")
            self.view.layoutIfNeeded()
        }
        isInformationTabActive = true
    }
    
    func secondFadeOut(){
        secondIconHorizontalConstraint.constant += 4
        secondIconLabelBottomConstraint.constant -= 7
        UIView.animateWithDuration(0.2) {
            self.view.layoutIfNeeded()
            self.secondIconLabel.alpha = 0
            self.secondIcon.textColor = UIColor(hexString: "7F7F7F")
        }
        isInformationTabActive = false
    }
    
    func thirdFadeIn(){
        thirdIconHorizontalContstraint.constant -= 4
        thirdIconLabelBottomConstraint.constant += 7
        UIView.animateWithDuration(0.3) { 
            self.view.layoutIfNeeded()
            self.thirdIconLabel.alpha = 1
            self.thirdIcon.textColor = UIColor(hexString: "F7F7F7")
        }
        isOptionsTabActive = true
    }
    
    func thirdFadeOut(){
        thirdIconHorizontalContstraint.constant += 4
        thirdIconLabelBottomConstraint.constant -= 7
        UIView.animateWithDuration(0.2) { 
            self.view.layoutIfNeeded()
            self.thirdIconLabel.alpha = 0
            self.thirdIcon.textColor = UIColor(hexString: "7F7F7F")
        }
        isOptionsTabActive = false
    }
    
    func runTimedCode(){
        EZLoadingActivity.hide()
        taskTimer.invalidate()
        
        UIView.animateWithDuration(0.3) {
//            self.segmentedControl.alpha = 1
            self.viewMap.alpha = 1
            self.goToStartBtn.alpha = 1
            self.titleLabel.text = "Hemos asignado un taxi para ti y ahora mismo va en camino!"
            self.view.layoutIfNeeded()
            self.locationMarker = GMSMarker(position: self.locations[0] as CLLocationCoordinate2D)
            self.timerLocations = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(self.updateTaxiLocation), userInfo: nil, repeats: true)
            self.currentTrip.isActive = true
            QTUserManager.sharedInstance.updateTrip(self.currentTrip)
//            self.saveContext()
        }
        self.firstFadeIn()
        defaults.setBool(true, forKey: "onGoingTrip")
        self.showNewBalance()
    }
    
    func showElementsFromMyTrips(isActive:Bool){
        UIView.animateWithDuration(0.3) {
            if isActive{
                self.titleLabel.text = "El taxi que hemos asignado para ti ahora mismo va en camino!"
            }else{
                self.titleLabel.text = "Esta es la información de tu viaje previo."
            }
            self.viewMap.alpha = 1
            self.goToStartBtn.alpha = 1
            self.view.layoutIfNeeded()
            self.locationMarker = GMSMarker(position: self.locations[0] as CLLocationCoordinate2D)
            self.timerLocations = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(self.updateTaxiLocation), userInfo: nil, repeats: true)
            self.saveContext()
        }
        self.firstFadeIn()
    }
    
    func taxiLocationDetachThread(){
        NSThread.detachNewThreadSelector(#selector(self.updateTaxiLocation), toTarget: self, withObject: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToStartPressed(sender: AnyObject) {
        performSegueWithIdentifier("unwindToStart", sender: self)
    }
    
    func saveContext(){
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    func showNewBalance(){
        moneyLeft = defaults.floatForKey("moneyLeft")
        moneyLeft = moneyLeft - 35.00
        defaults.setFloat(moneyLeft, forKey: "moneyLeft")
        defaults.synchronize()
        UIView.animateWithDuration(0.4, animations: {
            self.moneyLeftLabel.alpha = 0
            self.balanceTitleLabel.alpha = 0
            }) { (complete) in
                UIView.animateWithDuration(0.4, animations: {
                    self.moneyLeftLabel.text = String(format: "$%.2f", self.moneyLeft)
                    self.balanceTitleLabel.text = "Saldo Actualizado:"
                    self.moneyLeftLabel.alpha = 1
                    self.balanceTitleLabel.alpha = 1
                })
        }
    }
    
    @IBAction func segmentedControlAction(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("info")
            UIView.animateWithDuration(0.3, animations: {
                self.viewMap.alpha = 0
                }, completion: { (complete) in
                    UIView.animateWithDuration(0.2, animations: {
                        self.infoContainerView.alpha = 1
                    })
            })
        case 1:
            print("map")
            UIView.animateWithDuration(0.3, animations: {
                self.infoContainerView.alpha = 0
                }, completion: { (complete) in
                    UIView.animateWithDuration(0.2, animations: {
                        self.viewMap.alpha = 1
                    })
            })
        default:
            print("default")
        }
    }
    
    func updateTaxiLocation(){
//        print("update taxi locations")
        print("i value = \(i)")
//        print("locations count = \(locations.count)")
        
        if i < locations.count && timerLocations.valid {
            let location = locations[i]
            self.setupLocationMarker(location, marker:self.locationMarker)
            i += 1
        }else{
            timerLocations.invalidate()
            return
        }
    }
    
    func setupLocationMarker(coordinate:CLLocationCoordinate2D, marker:GMSMarker){
        marker.position = coordinate
        marker.map = viewMap
        UIView.animateWithDuration(3) {
            marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        }
        marker.opacity = 0.75

    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToDestination"{
            print("unwind segue to destination")
            let vc:DestinationViewController = segue.destinationViewController as! DestinationViewController
            vc.comingFromSummary = true
        }
    }
}
