//
//  AddFriend.swift
//  Sleden
//
//  Created by Daniel Alvestad on 03/01/16.
//  Copyright © 2016 Daniel Alvestad. All rights reserved.
//

import Foundation
import Parse


class AddFriend {
    
    var user: User
    
    
    init(username: String, userID: String) {
        user = User(username: username, userID: userID, isFriend: userRelation.Friend)
        
        let queryFriends = PFQuery(className: "Friends")
        queryFriends.whereKey("User", equalTo: (PFUser.currentUser()?.objectId)!)
        
        queryFriends.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            
            
            
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
    
    
    
    
    
    
    
    
}