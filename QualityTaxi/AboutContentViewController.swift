//
//  AboutContentViewController.swift
//  QualityTaxi
//
//  Created by Developer on 6/27/16.
//  Copyright © 2016 Felix Olivares. All rights reserved.
//

import UIKit

class AboutContentViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
//    let url = NSBundle.mainBundle().URLForResource("Privacy", withExtension:"html")
    var url = NSURL()
    var type = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch type {
        case "terms":
            url = NSBundle.mainBundle().URLForResource("Terms", withExtension:"html")!
            title = "Condiciones de Uso"
        case "privacy":
            title = "Aviso de Privacidad"
            url = NSBundle.mainBundle().URLForResource("Privacy", withExtension:"html")!
        default:
            url = NSBundle.mainBundle().URLForResource("Privacy", withExtension:"html")!
        }
        
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
