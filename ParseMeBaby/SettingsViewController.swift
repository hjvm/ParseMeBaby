//
//  SettingsViewController.swift
//  ParseMeBaby
//
//  Created by Héctor J. Vázquez on 6/21/16.
//  Copyright © 2016 Héctor J. Vázquez. All rights reserved.
//

import Parse
import UIKit

class SettingsViewController: UIViewController {

    @IBAction func logoutPressed(sender: AnyObject) {
    
        PFUser.logOutInBackgroundWithBlock ( { (error: NSError?) -> Void in } )
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("loginScreen") as! LoginViewController
        self.presentViewController(vc, animated:true, completion: nil)
        


    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

