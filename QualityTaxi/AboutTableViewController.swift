//
//  AboutTableViewController.swift
//  QualityTaxi
//
//  Created by Developer on 6/27/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit
import ChameleonFramework

class AboutTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    var viewTouchOverlayFull = UIView()
    var shadowView = UIView()
    var menuOpened:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.tableFooterView = UIView()
        
        viewTouchOverlayFull = UIView(frame: self.view.frame)
        viewTouchOverlayFull.backgroundColor = UIColor.clearColor()
        self.view.addSubview(viewTouchOverlayFull)
        let tapOverlay = UITapGestureRecognizer(target: self, action: #selector(touchViewOverlayPressed))
        tapOverlay.delegate = self
        viewTouchOverlayFull.addGestureRecognizer(tapOverlay)
        viewTouchOverlayFull.hidden = true
        
        shadowView = UIView(frame: CGRectMake(UIScreen.mainScreen().bounds.origin.x,UIScreen.mainScreen().bounds.origin.y,5,UIScreen.mainScreen().bounds.size.height))
        //        shadowView.backgroundColor = UIColor(hexString: "2C2A2A")
        shadowView.backgroundColor = GradientColor(UIGradientStyle.LeftToRight, frame: shadowView.frame, colors: [UIColor.blackColor(), UIColor.clearColor()])
        shadowView.hidden = true
        self.navigationController!.view.addSubview(shadowView)
        
        
        if self.revealViewController() != nil {
            //            menuButton.target = self.revealViewController()
            //            menuButton.action = #selector(self.menuPressed)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().toggleAnimationType = .Spring
            self.revealViewController().rearViewRevealOverdraw = 0
        }
    }

    func touchViewOverlayPressed(){
        viewTouchOverlayFull.hidden = true
        shadowView.hidden = true
        self.revealViewController().revealToggle(self)
        menuOpened = !menuOpened
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openMenuPressed(sender: AnyObject) {
        self.revealViewController().revealToggle(self)
        if !menuOpened {
            viewTouchOverlayFull.hidden = false
            shadowView.hidden = false
        }else{
            viewTouchOverlayFull.hidden = true
            shadowView.hidden = true
        }
        menuOpened = !menuOpened
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc:AboutContentViewController = segue.destinationViewController as! AboutContentViewController
        vc.type = segue.identifier!
    }
    // MARK: - Table view data source
/*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
