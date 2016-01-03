//
//  User.swift
//  Sleden
//
//  Created by Daniel Alvestad on 01/01/16.
//  Copyright © 2016 Daniel Alvestad. All rights reserved.
//

import Foundation
import Parse

class User{
    
    var username: String
    var userID: String
    var isFriend: userRelation
    
    init(username: String, userID: String, isFriend: userRelation){
        
        self.username = username
        self.userID = userID
        self.isFriend = isFriend
    }
    
    
}