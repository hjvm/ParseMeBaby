//
//  HomeViewController.swift
//  ParseMeBaby
//
//  Created by Héctor J. Vázquez on 6/20/16.
//  Copyright © 2016 Héctor J. Vázquez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    //Variables and outlets
    @IBOutlet var tableView: UITableView!
    var postTexts : [PFObject]?
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    let refreshControl = UIRefreshControl()
    var skip = 0
    var offset = 0




    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add pull to refresh + infinite scrolling
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        
        //Table view data sources
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        refreshControlAction(refreshControl)
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //Set up Table Header
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! TableViewCell
        
        cell.instagramPost = postTexts![indexPath.section]
        return cell
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let postTexts = postTexts {
            return postTexts.count
        } else {
            return 0
        }
    
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vw = UITableViewHeaderFooterView()
        vw.contentView.backgroundColor = UIColor.clearColor()
        let post = postTexts![section]
        if let user = post["author"]{
            vw.textLabel?.text = user.username
            vw.textLabel?.textColor = UIColor.blackColor()
        }
        return vw
    }

    
    
    
    
    

    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        if (!isMoreDataLoading) {
            skip = 0
        }

        
        // ... Create the NSURLRequest (myRequest) ...
        self.loadData()
        
        // Reload the tableView now that there is new data
        self.tableView.reloadData()
                                                                        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    
    
    
    
    
    
    
    
    func loadData() {
        let query = PFQuery(className: "Post", predicate: nil)
        
        //Retrieve the most recent ones
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.includeKey("_created_at")
        query.limit = 20 + skip
    
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.postTexts = posts
                self.tableView.reloadData()
                
                // do something with the array of object returned by the call
                self.loadingMoreView?.stopAnimating()
                self.isMoreDataLoading = false
                
            } else {
                print(error?.localizedDescription)
                let alertController = UIAlertController(title: "No Network Connection", message:
                    "There was an error loading image resuts", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    
    //Infinite scrolling
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                offset += 5
                skip = offset
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // ... Code to load more results ...
                refreshControlAction(refreshControl)
            }
            
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Prepare for segue called")
        
        let cell = sender as! TableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let post = postTexts![indexPath!.section]
        print("PREPARE FOR SEGUE")
        print("\(post["caption"])")
        let detailsViewController = segue.destinationViewController as! DetailsViewController
         detailsViewController.post = post

    }


}
