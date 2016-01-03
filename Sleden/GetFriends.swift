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
    var myFriendsUsername: NSMutableArray {
        
        let usernames = NSMutableArray()
        for friend in myFriends {
            if let username = friend.username {
                usernames.addObject(username)
            }
        }
        return usernames
    }
    
}