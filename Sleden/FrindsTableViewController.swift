//
//  FrindsTableViewController.swift
//  Sleden
//
//  Created by Daniel Alvestad on 01/01/16.
//  Copyright © 2016 Daniel Alvestad. All rights reserved.
//

import UIKit
import Parse

class FrindsTableViewController: UITableViewController {

    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    
    
    var user: String?
    
    var GetFriendsObject: GetFriends = GetFriends()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

        
        tableView.backgroundView = BackgroundView()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:", name: "load", object: nil)
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }
    
    func configureView() {
        
        
        if PFUser.currentUser()?.username != user {
            user = PFUser.currentUser()!.username!
            GetFriendsObject.myFriends = []
            GetFriendsObject.getFriends(tableView, actInt: actInd)
            GetFriendsObject.findIfUserIsDeleted(tableView)
            tableView.reloadData()
        } else {
            GetFriendsObject.getFriends(tableView, actInt: actInd)
            GetFriendsObject.findIfUserIsDeleted(tableView)
            tableView.reloadData()
        }

        
        
        
    }

    override func viewWillAppear(animated: Bool) {
        configureView()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Refresh Control and Updating
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        configureView()
        refreshControl.endRefreshing()
    }
    
    func loadList(notification: NSNotification) {
        
        configureView()
        
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.GetFriendsObject.myFriends.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        cell.nameLabel.text = self.GetFriendsObject.myFriends[indexPath.row].username
        cell.profileImageView.image = UIImage(named: "bg")
        return cell
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "tilVenn" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let user = GetFriendsObject.myFriends[indexPath.row]
                
                // Sender over objektet som tilsvarer raden som bli klikket i table viewet
                (segue.destinationViewController as! detailVennViewController).user = user
                
            }
            
            
        } else if segue.identifier == "addFriend" {
            
            if !UIAccessibilityIsReduceTransparencyEnabled() {
                //self.view.backgroundColor = UIColor.clearColor()
                
                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                //always fill the view
                blurEffectView.frame = self.view.frame
                blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
                
                self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
            }
            else {
                self.view.backgroundColor = UIColor.blackColor()
            }

            
            
            let modalViewController = AddFriends()
            modalViewController.modalPresentationStyle = .OverCurrentContext
            presentViewController(modalViewController, animated: true, completion: nil)
            
            
            
            
        }
        
        
    }
    

}
