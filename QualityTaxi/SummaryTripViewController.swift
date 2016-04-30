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
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    var originMarker: GMSMarker!
    
    var destinationMarker: GMSMarker!
    
    var routePolyline: GMSPolyline!
    
    var currentTripTime:String = ""
    var currentTrip:QualityTrip!
    var mapTasks = MapTasks()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let predicate:NSPredicate = NSPredicate(format: "createdAt == %@", currentTripTime)
        let request:NSFetchRequest = QualityTrip.MR_requestAllWithPredicate(predicate)
        let allTrips = QualityTrip.MR_executeFetchRequest(request)
        currentTrip = allTrips?.first as! QualityTrip
        
        let origin = currentTrip.originStreet! + " " + currentTrip.originColony!
        let destination = currentTrip.destinationStreet! + " " + currentTrip.destinationColony!
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureMapAndMarkersForRoute() {
        viewMap.camera = GMSCameraPosition.cameraWithTarget(mapTasks.originCoordinate, zoom: 11.0)
        originMarker = GMSMarker(position: self.mapTasks.originCoordinate)
        originMarker.map = self.viewMap
        originMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
        originMarker.title = self.mapTasks.originAddress
        
        destinationMarker = GMSMarker(position: self.mapTasks.destinationCoordinate)
        destinationMarker.map = self.viewMap
        destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        destinationMarker.title = self.mapTasks.destinationAddress
    }
    
    func drawRoute() {
        let route = mapTasks.overviewPolyline["points"] as! String
        
        let path: GMSPath = GMSPath(fromEncodedPath: route)!
        routePolyline = GMSPolyline(path: path)
        routePolyline.map = viewMap
        
        let bounds:GMSCoordinateBounds = GMSCoordinateBounds.init(path: path)
        let update:GMSCameraUpdate = GMSCameraUpdate.fitBounds(bounds)
        viewMap.moveCamera(update)
    }

    func displayRouteInfo() {
//        lblInfo.text = mapTasks.totalDistance + "\n" + mapTasks.totalDuration
        print("distance: \(mapTasks.totalDistance) duration: \(mapTasks.totalDuration)")
        distanceLabel.text = mapTasks.totalDistance
        timeLabel.text = mapTasks.totalDuration
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
