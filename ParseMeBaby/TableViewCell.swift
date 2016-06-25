//
//  TableViewCell.swift
//  ParseMeBaby
//
//  Created by Héctor J. Vázquez on 6/21/16.
//  Copyright © 2016 Héctor J. Vázquez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var postedImageView: PFImageView!
    @IBOutlet weak var captionField: UILabel!
    
    
    
    var instagramPost: PFObject! {
        didSet {
            self.postedImageView.file = instagramPost["media"] as? PFFile
            self.postedImageView.loadInBackground()
            self.captionField.text = instagramPost["caption"] as? String
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
