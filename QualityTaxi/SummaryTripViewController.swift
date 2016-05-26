//
//  SummaryTripViewController.swift
//  QualityTaxi
//
//  Created by Developer on 4/29/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class SummaryTripViewController: UIViewController {

    @IBOutlet weak var viewMap: GMSMapView!
    
    @IBOutlet weak var myTripMapView: GMSMapView!
    @IBOutlet weak var moneyLeftLabel: UILabel!
    @IBOutlet weak var askTaxiBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var originMarkerMyTrip:GMSMarker!
    var destinationMarkerMyTrip: GMSMarker!
    
    var routePolyline: GMSPolyline!
    var routePolylineMyTrip: GMSPolyline!
    
    var currentTripTime:String = ""
    var currentTrip:QualityTrip!
    var mapTasks = MapTasks()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        askTaxiBtn.layer.cornerRadius = 5
        viewMap.layer.cornerRadius = 5
        
        let predicate:NSPredicate = NSPredicate(format: "createdAt == %@", currentTripTime)
        let request:NSFetchRequest = QualityTrip.MR_requestAllWithPredicate(predicate)
        let allTrips = QualityTrip.MR_executeFetchRequest(request)
        currentTrip = allTrips?.first as! QualityTrip
        
        let origin = currentTrip.originStreet!
        let destination = currentTrip.destinationStreet!
        
        self.mapTasks.getDirections(origin, destination: destination, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
            if success {
                self.configureMapAndMarkersForRoute()
                self.drawRoute()
                self.displayRouteInfo()
            }
            else {
                print("status \(status)")
            }
        })
        
        moneyLeftLabel.text = String(format: "$%.2f", defaults.floatForKey("moneyLeft"))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveContext(){
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    func configureMapAndMarkersForRoute() {
        viewMap.camera = GMSCameraPosition.cameraWithTarget(mapTasks.originCoordinate, zoom: 11.0)
        originMarker = GMSMarker(position: self.mapTasks.originCoordinate)
        originMarker.map = self.viewMap
        originMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor()).imageScaledToSize(CGSizeMake(9.0, 17.0))
        originMarker.title = self.mapTasks.originAddress
        
        destinationMarker = GMSMarker(position: self.mapTasks.destinationCoordinate)
        destinationMarker.map = self.viewMap
        destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor()).imageScaledToSize(CGSizeMake(9.0, 17.0))
        destinationMarker.title = self.mapTasks.destinationAddress
        
        
        myTripMapView.camera = GMSCameraPosition.cameraWithTarget(mapTasks.originCoordinate, zoom: 11.0)
        originMarkerMyTrip = GMSMarker(position: self.mapTasks.originCoordinate)
        originMarkerMyTrip.map = (self.myTripMapView)
        originMarkerMyTrip.icon = GMSMarker.markerImageWithColor(UIColor.greenColor()).imageScaledToSize(CGSizeMake(9.0, 17.0))
//        originMarkerMyTrip.icon = UIImage.init(named: "pin")
        originMarkerMyTrip.title = self.mapTasks.originAddress
        
        destinationMarkerMyTrip = GMSMarker(position: self.mapTasks.destinationCoordinate)
        destinationMarkerMyTrip.map = self.myTripMapView
        destinationMarkerMyTrip.icon = GMSMarker.markerImageWithColor(UIColor.redColor()).imageScaledToSize(CGSizeMake(9.0, 17.0))
        destinationMarkerMyTrip.title = self.mapTasks.destinationAddress
    }
    
    func drawRoute() {
        let route = mapTasks.overviewPolyline["points"] as! String
        
        let path: GMSPath = GMSPath(fromEncodedPath: route)!
        routePolyline = GMSPolyline(path: path)
        routePolyline.map = viewMap
        
        let bounds:GMSCoordinateBounds = GMSCoordinateBounds.init(path: path)
        let update:GMSCameraUpdate = GMSCameraUpdate.fitBounds(bounds)
        viewMap.moveCamera(update)
        
        //
        let routeMyTrip = mapTasks.overviewPolyline["points"] as! String
        let pathMyTrip = GMSPath(fromEncodedPath: routeMyTrip)!
        routePolylineMyTrip = GMSPolyline(path: pathMyTrip)
        routePolylineMyTrip.map = myTripMapView
        let boundsMyTrip:GMSCoordinateBounds = GMSCoordinateBounds.init(path: pathMyTrip)
        let updateMyTrip:GMSCameraUpdate = GMSCameraUpdate.fitBounds(boundsMyTrip)
        myTripMapView.moveCamera(updateMyTrip)
    }

    func displayRouteInfo() {
//        lblInfo.text = mapTasks.totalDistance + "\n" + mapTasks.totalDuration
        print("distance: \(mapTasks.totalDistance) duration: \(mapTasks.totalDuration)")
        distanceLabel.text = mapTasks.totalDistance
        timeLabel.text = mapTasks.totalDuration
        currentTrip.totalDistance = mapTasks.totalDistance
        currentTrip.timeAprox = mapTasks.totalDuration
        currentTrip.rate = "$30.00"
        currentTrip.driverName = "Pedro Lopez"
        currentTrip.carKind = "Altima"
        currentTrip.carColor = "Amarillo"
        currentTrip.carPlates = "CMD-3246"
        self.saveContext()
        
    }
    

    @IBAction func askTaxiButtonPressed(sender: AnyObject) {
        defaults.setObject(currentTripTime, forKey: "currentTrip")
        defaults.synchronize()
        
        myTripMapView.hidden = false
        UIGraphicsBeginImageContextWithOptions(myTripMapView.frame.size, false, 0.0)
        self.myTripMapView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        guard let imageData = UIImageJPEGRepresentation(image, 1) else {
            // handle failed conversion
            print("jpg error")
            return
        }
        print("image saved = \(image)")
        currentTrip.tripImage = imageData
        self.saveContext()
        UIGraphicsEndImageContext()
        myTripMapView.hidden = true
        
        performSegueWithIdentifier("toFindTaxi", sender: self)
        /*
        let popupView = createPopupview()
        
        let popupConfig = STZPopupViewConfig()
        popupConfig.dismissTouchBackground = false
        popupConfig.cornerRadius = 5
        popupConfig.overlayColor = UIColor(hexString: "000000", withAlpha: 0.2)!
        popupConfig.showAnimation = .FadeIn
        popupConfig.dismissAnimation = .FadeOut        
        popupConfig.showCompletion = { popupView in
            print("show")
        }
        popupConfig.dismissCompletion = { popupView in
            print("dismiss")
        }
        
        presentPopupView(popupView, config: popupConfig)*/
    }
    
    func createPopupview() -> UIView {
        
        let popupView = UIView(frame: CGRectMake((self.view.frame.size.width - (self.view.frame.size.width - 100)) / 2, (self.view.frame.size.height - (self.view.frame.size.height - 200)) / 2, self.view.frame.size.width - 100, 200))
        popupView.backgroundColor = UIColor(hexString: "#2C2A2A")!        
        
        //Title
        let title = UILabel(frame: CGRectMake((popupView.frame.size.width - 200) / 2, 15, 200, 30))
        title.text = "Se sustraeran de tu saldo:"
        title.numberOfLines = 0
        title.textColor = UIColor.whiteColor()
        title.textAlignment = NSTextAlignment.Center
        title.font = UIFont(name: "Helvetica", size: 16)
        popupView.addSubview(title)
        
        //Price
        let price = UILabel(frame: CGRectMake((popupView.frame.size.width - 100)/2, title.frame.origin.y + title.frame.size.height + 10, 100, 60))
        price.text = "$35.00"
        price.numberOfLines = 1
        price.textColor = UIColor.whiteColor()
        price.textAlignment = NSTextAlignment.Center
        price.font = UIFont(name: "Helvetica", size: 25)
        popupView.addSubview(price)
    
        // Close button
        let button = UIButton(type: .System)
        button.frame = CGRectMake(popupView.frame.size.width - 30, 5, 30, 30)
        button.setTitle(" x ", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(touchClose), forControlEvents: UIControlEvents.TouchUpInside)
        popupView.addSubview(button)
        
        // OK button
        let okButton = UIButton(type: .Custom)
        okButton.frame = CGRectMake((popupView.frame.size.width - 60)/2, popupView.frame.size.height - 25 - 10 , 60, 25)
        okButton.setTitle("Aceptar", forState: .Normal)
        okButton.titleLabel!.font = UIFont(name:"Helvetica-Bold", size: 14)
        okButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        okButton.addTarget(self, action: #selector(acceptPressed), forControlEvents: .TouchUpInside)
        popupView.addSubview(okButton)
        
        return popupView
    }
    
    func touchClose() {
        dismissPopupView()
    }
    
    func acceptPressed(){
        dismissPopupView()
        performSegueWithIdentifier("toFindTaxi", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc:FindTaxiViewController = segue.destinationViewController as! FindTaxiViewController
        vc.currentTripTime = self.currentTripTime
        vc.fromMyTrips = false
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
