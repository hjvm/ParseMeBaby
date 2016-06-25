//
//  DetailsViewController.swift
//  ParseMeBaby
//
//  Created by Héctor J. Vázquez on 6/22/16.
//  Copyright © 2016 Héctor J. Vázquez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var photoView: PFImageView!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    var post: PFObject?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let post = post {
            self.photoView.file = post["media"] as? PFFile
            self.photoView.loadInBackground()
            self.overviewLabel.text = String(post["caption"])
            self.usernameLabel.text = post["author"].username
            
            //Timestamp
            let createdAt = post.createdAt
    //        post.createdAt
    //        print("\(createdAt)")
            if let timestamp = createdAt{
                self.timestampLabel.text = "Posted on: \(timestamp) UTC"

            }
            
        }
        
        
    }
    
    
    
}
