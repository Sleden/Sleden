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
    
    //var GetFriendsObject: GetFriends = GetFriends()
    var FriendsObject = FriendsModule(myFriends: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

        
        //tableView.backgroundView = BackgroundView()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:", name: "load", object: nil)
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }
    
    func configureView() {
        
        
        
        if PFUser.currentUser()?.username != user {
            
            user = PFUser.currentUser()!.username!
            self.FriendsObject.myFriends = []
            self.getFriends()
        } else {
            self.getFriends()
        }
    }

    override func viewWillAppear(animated: Bool) {
        configureView()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Get Friends frunctions
    
    func getFriends() {
        
        actInd.startAnimating()
        
        let friendsQuery1 = PFQuery(className: "Friends2")
        let friendsQuery2 = PFQuery(className: "Friends2")
        
        friendsQuery1.whereKey("User1", equalTo: PFUser.currentUser()!)
        friendsQuery2.whereKey("User2", equalTo: PFUser.currentUser()!)
        
        
        
        let query = PFQuery.orQueryWithSubqueries([friendsQuery1, friendsQuery2])
        query.findObjectsInBackgroundWithBlock { (returnRows: [PFObject]?, error: NSError?) -> Void in
            
            self.actInd.stopAnimating()
            
            if let rows = returnRows {
                
                for row in rows {
                    
                    if let user1AnyObject = row["User1"], user1 = user1AnyObject as? PFUser,
                        let user2AnyObject = row["User2"], user2 = user2AnyObject as? PFUser,
                        let friendRequestAnyObject = row["FriendRequestPending"], friendRequest = friendRequestAnyObject as? Bool {
                            
                            var friendRelation: userRelation = .Friend
                            
                            if friendRequest {
                                if let friendRequestFromAnyObject = row["FriendRequestFrom"], friendRequestFrom = friendRequestFromAnyObject as? PFUser {
                                    if friendRequestFrom == PFUser.currentUser() {
                                        friendRelation = userRelation.SendtFriendRequest
                                    } else {
                                        friendRelation = userRelation.RecivedFriendRequest
                                    }
                                }
                            }
                            
                            
                            
                            if user1 == PFUser.currentUser()! {
                                self.fetchDataForUser(user2, friendRelation: friendRelation)
                            } else {
                                self.fetchDataForUser(user1, friendRelation: friendRelation)
                            }
                    }
                }
                
                self.FriendsObject.lookForDeletedFriends(rows)
                self.tableView.reloadData()
                
            } else {
            
                print("Bruker har ingen venner")
                
                if error != nil {
                    print("Error: \(error)")
                }
                
            }
            
            
        }
    }
    
    
    func fetchDataForUser(user: PFUser, friendRelation: userRelation) {
        user.fetchIfNeededInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
            if let userPFObject = object, user = userPFObject as? PFUser {
                self.FriendsObject.addFriendToMyFriendsArray(user, friendRelation: friendRelation)
                self.tableView.reloadData()
            }
        })
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
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 1 {
            return self.FriendsObject.friendRequests().count
        } else {
            return self.FriendsObject.friends().count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            if self.FriendsObject.friendRequests()[indexPath.row].isFriend! == userRelation.SendtFriendRequest {
                let cellRequest = tableView.dequeueReusableCellWithIdentifier("cellSendtRequest", forIndexPath: indexPath) as! TableViewCellRequest
                cellRequest.nameLabel.text = self.FriendsObject.friendRequests()[indexPath.row].username!
                cellRequest.typeOfRequestLabel.text = self.FriendsObject.friendRequests()[indexPath.row].isFriend?.rawValue
                return cellRequest
            } else {
                let cellRequest = tableView.dequeueReusableCellWithIdentifier("cellRecivedRequest", forIndexPath: indexPath) as! TableViewCellRequest
                cellRequest.nameLabel.text = self.FriendsObject.friendRequests()[indexPath.row].username!
                
                cellRequest.acceptButton.tag = indexPath.row
                cellRequest.acceptButton.addTarget(self, action: "addFriend:", forControlEvents: .TouchUpInside)
                return cellRequest

            }
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
            cell.nameLabel.text = self.FriendsObject.friends()[indexPath.row].username!
            cell.profileImageView.image = UIImage(named: "bg")
            return cell
            
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Friend Requests"
        } else {
            return "Friends"
        }
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
    
    
    //MARK: - Table view actions
    
    
    @IBAction func addFriend(sender: UIButton) {
        
        let newFriend = self.FriendsObject.friendRequests()[sender.tag]
        
        newFriend.isFriend = .Friend
        
        self.tableView.reloadData()
        
        print("newUser")
        let addFriendQuery = PFQuery(className: "Friends2")
        if let currentUser = PFUser.currentUser(),
            let newUserID = newFriend.userID {
                
                let newUser = PFUser(withoutDataWithClassName: "_User", objectId: newUserID)
                
                addFriendQuery.whereKey("User1", containedIn: [currentUser, newUser]).whereKey("User2", containedIn: [currentUser, newUser])
        }
        
        addFriendQuery.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            
            print(object)
            
            if let friendObject = object {
                if let friendRequestPendingAnyObject = friendObject["FriendRequestPending"], friendRequestPending = friendRequestPendingAnyObject as? Bool  {
                    if friendRequestPending {
                        friendObject["FriendRequestPending"] = false
                        friendObject.saveInBackground()
                        
                    }
                }
            }
            
        }
        
        
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "tilVenn" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let user = self.FriendsObject.myFriends[indexPath.row]
                
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
