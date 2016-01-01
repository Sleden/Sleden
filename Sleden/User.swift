//
//  User.swift
//  Sleden
//
//  Created by Daniel Alvestad on 01/01/16.
//  Copyright © 2016 Daniel Alvestad. All rights reserved.
//

import Foundation
import Parse

class User: PFUser {
    
    var userID: String
    var isFriend: userRelation
    
    init(userID: String, isFriend: userRelation){
        
        self.userID = userID
        self.isFriend = isFriend
        
        super.init()
    }
    
    
}