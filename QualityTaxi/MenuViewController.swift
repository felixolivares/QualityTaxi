//
//  MenuViewController.swift
//  QualityTaxi
//
//  Created by Felix Olivares on 11/4/15.
//  Copyright © 2015 Felix Olivares. All rights reserved.
//

import UIKit
import ChameleonFramework

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let buttonToTimeFrame:UIButton = UIButton()
    let buttonToStatus:UIButton = UIButton()
    let tableView:UITableView = UITableView()
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    var selectedMenuItem : Int = 0
    let viewNames:[String] = ["Inicio", "Perfil", "Historial", "Ajustes", "Salir"]
    let newTaskTextField:UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.view.backgroundColor = UIColor.clearColor()
        
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = CGRectMake(0, 64, 180, 400)
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollsToTop = false
        self.view.addSubview(tableView)
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: TableView Delegate Functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return viewNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.tintColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
        selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
        cell.selectedBackgroundView = selectedBackgroundView
        
        cell.textLabel?.text = viewNames[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("did select row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem) {
            return
        }
        
        selectedMenuItem = indexPath.row
        
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Main")
            sideMenuController()?.setContentViewController(destViewController)
        case 4:
            print("salir presionado")
//            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("login")
//            sideMenuController()?.setContentViewController(destViewController)
            let navController = sideMenuController() as! NavigationController
            navController.goToLogin()
        default:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Main")
            sideMenuController()?.setContentViewController(destViewController)
        }
        
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

