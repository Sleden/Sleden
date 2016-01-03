//
//  GetFriends.swift
//  sleden2
//
//  Created by Daniel Alvestad on 19/12/15.
//  Copyright © 2015 Daniel Alvestad. All rights reserved.
//

import Foundation
import Parse

class GetFriends {
    
    var myFriends: [User] = []
    
    func getFriends(table: UITableView, actInt: UIActivityIndicatorView) {
        
        
        
        let queryFriends = PFQuery(className: "Friends")
        queryFriends.whereKey("User", equalTo: (PFUser.currentUser()?.objectId)!)
        actInt.startAnimating()
        
        queryFriends.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            
            actInt.stopAnimating()
            
            if error == nil {
                
                if let user = objects?[0]{
                    
                    if let friends = user["friends"] as? [User] {
                        for friend in friends {
                            self.myFriends.append(friend)
                        }
                        
                    }
                }
                
                
            } else {
                print(error)
            }
            
            table.reloadData()
            
        })
        
    }
    
    static func addFriend(view: UIViewController, username: String, userID: String) {
        
        let newFriend = User(username: username, userID: userID, isFriend: userRelation.Friend)
        
        addFriendWithUserObject(view, newFriend: newFriend)
        
        
    }
    
    
    static func addFriendWithUserObject(view: UIViewController, newFriend: User) {
        
        if newFriend.isFriend != userRelation.Friend {
            newFriend.isFriend = userRelation.Friend
        }
        
        let queryFriends = PFQuery(className: "Friends")
        queryFriends.whereKey("User", equalTo: (PFUser.currentUser()?.objectId)!)
        
        queryFriends.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let user = objects?[0]{
                    if var friends = user["friends"] as? [User] {
        
                        friends.append(newFriend)
                        user["friends"] = friends
                        user.saveInBackground()
                        print("Added friend: \(newFriend.username))")
                        
                    }
                } else {
                    let newObject = PFObject(className: "Frinds")
                    let friends: [User] = [newFriend]
                    let friendRequests: [User] = []
                    
                    newObject["friends"] = friends
                    newObject["UserID"] = (PFUser.currentUser()?.objectId)!
                    newObject["friendRequests"] = friendRequests
                    
                }
            } else {
                print(error)
            }
            
        })

        
        
    }
    
    
}