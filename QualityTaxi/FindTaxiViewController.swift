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
    var locations = [CLLocationCoordinate2D]()
    var timerLocations:NSTimer!
    var i:Int = 0
    var locationMarker: GMSMarker!
    var bounds:GMSCoordinateBounds!
    var update:GMSCameraUpdate!
    
    @IBOutlet weak var secondTab: UIView!
    @IBOutlet weak var informationIconLabel: UILabel!
    @IBOutlet weak var informationIcon: UILabel!
    @IBOutlet weak var informationIconLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var informationIconHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstTab: UIView!
    @IBOutlet weak var mapIconHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapIconLabel: UILabel!
    
    @IBOutlet weak var mapIconLabelBottomConstraint: NSLayoutConstraint!
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
    @IBOutlet weak var mapIcon: UILabel!
    @IBOutlet weak var mainContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: false)
        
//        segmentedControl.alpha = 0
        viewMap.delegate = self
        viewMap.alpha = 0
        viewMap.layer.cornerRadius = 5
        goToStartBtn.layer.cornerRadius = 5
        goToStartBtn.alpha = 0
        infoContainerView.alpha = 0
        
        driverDetailsContainer.layer.cornerRadius = 5
        driverDetailsContainer.layer.borderColor = UIColor(hexString: "D3D5D5").CGColor
        driverDetailsContainer.layer.borderWidth = 1
        // Do any additional setup after loading the view.
        EZLoadingActivity.show("Solicitando Taxi", disableUI: false)
        
        taskTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(FindTaxiViewController.runTimedCode), userInfo: nil, repeats: true)
        
        moneyLeftLabel.text = String(format: "$%.2f", defaults.floatForKey("moneyLeft"))
        
        let tapMap = UITapGestureRecognizer(target: self, action: #selector(pressedMapTab))
        tapMap.delegate = self
        firstTab.addGestureRecognizer(tapMap)
        
        let tapInformation = UITapGestureRecognizer(target: self, action: #selector(pressedInformationTab))
        tapInformation.delegate = self
        secondTab.addGestureRecognizer(tapInformation)
            
        
        mapIcon.font = UIFont.fontAwesomeOfSize(14)
        mapIcon.text = String.fontAwesomeIconWithCode("fa-map-marker")
        mapIcon.textColor = UIColor(hexString: "F7F7F7")
        mapIconLabel.alpha = 0
        
        informationIcon.font = UIFont.fontAwesomeOfSize(14)
        informationIcon.text = String.fontAwesomeIconWithCode("fa-taxi")
        informationIcon.textColor = UIColor(hexString: "F7F7F7")
        informationIconLabel.alpha = 0
        
        
        self.mapIconLabel.alpha = 0
        self.mapIcon.textColor = UIColor(hexString: "F7F7F7")
        
        //Information tab is always hidden at the begining
        informationIconLabel.alpha = 0
        informationIcon.textColor = UIColor(hexString: "7F7F7F")
        
        mainContainer.layer.borderWidth = 1
        mainContainer.layer.borderColor = UIColor(hexString: "E4E4E4").CGColor
        
        self.addLocations()
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
    
    func pressedMapTab(){
        if !isMapTabActive {
            //Map fade in
            self.mapFadeIn()
            
            //Information fade out
            self.informationFadeOut()
            
            UIView.animateWithDuration(0.2, animations: {
                self.infoContainerView.alpha = 0
                self.viewMap.alpha = 1
                }, completion: { (complete) in
                    UIView.animateWithDuration(0.1, animations: {
                        
                    })
            })
        }
    }
    
    func pressedInformationTab(){
        if !isInformationTabActive{
            //Information fade out
            self.informationFadeIn()
            
            //Map fade in
            self.mapFadeOut()
            
            UIView.animateWithDuration(0.2, animations: {
                self.viewMap.alpha = 0
                self.infoContainerView.alpha = 1
                }, completion: { (complete) in
                    UIView.animateWithDuration(0.1, animations: {
                        
                    })
            })
        }
    }

    func mapFadeIn(){
        mapIconHorizontalConstraint.constant -= 4
        mapIconLabelBottomConstraint.constant += 7
        UIView.animateWithDuration(0.2) {
            self.mapIconLabel.alpha = 1
            self.mapIcon.textColor = UIColor(hexString: "F7F7F7")
            self.view.layoutIfNeeded()
        }
        isMapTabActive = true
    }
    
    func mapFadeOut(){
        mapIconHorizontalConstraint.constant += 4
        mapIconLabelBottomConstraint.constant -= 7
        UIView.animateWithDuration(0.2) {
            self.view.layoutIfNeeded()
            self.mapIconLabel.alpha = 0
            self.mapIcon.textColor = UIColor(hexString: "7F7F7F")
        }
        isMapTabActive = false
    }
    
    func informationFadeOut(){
        informationIconHorizontalConstraint.constant += 4
        informationIconLabelBottomConstraint.constant -= 7
        UIView.animateWithDuration(0.2) {
            self.view.layoutIfNeeded()
            self.informationIconLabel.alpha = 0
            self.informationIcon.textColor = UIColor(hexString: "7F7F7F")
        }
        isInformationTabActive = false
    }
    
    func informationFadeIn(){
        informationIconHorizontalConstraint.constant -= 4
        informationIconLabelBottomConstraint.constant += 7
        UIView.animateWithDuration(0.2) {
            self.informationIconLabel.alpha = 1
            self.informationIcon.textColor = UIColor(hexString: "F7F7F7")
            self.view.layoutIfNeeded()
        }
        isInformationTabActive = true
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
            self.timerLocations = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.updateTaxiLocation), userInfo: nil, repeats: true)
        }
        self.mapFadeIn()
        defaults.setBool(true, forKey: "onGoingTrip")
        self.showNewBalance()
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
        UIView.animateWithDuration(1) {
            marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        }
        marker.opacity = 0.75

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
