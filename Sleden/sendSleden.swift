//
//  sendSleden.swift
//  Sleden
//
//  Created by Daniel Alvestad on 08/01/16.
//  Copyright © 2016 Daniel Alvestad. All rights reserved.
//

import Foundation
import Parse

class SendSleden{
    
    let newSleden: Sleden
    
    init(fromUser: User, sledenUser: User, sledenType: SledenType) {
        self.newSleden = Sleden(fromUser: fromUser, sledenUser: sledenUser , sledenType: sledenType)
    }
    
    convenience init(fromUser: User, sledenUserByUsername: String, sledenType: SledenType) {
        
        let sledenUser = getUser(sledenUserByUsername)
        
        
    }
    
    
    func getUser(username: String) -> User {
        
        var returnUser: User = User()
        
        let query = PFUser.query()
        query?.whereKey("username", equalTo: username)
        query?.findObjectsInBackgroundWithBlock({ (users , error ) -> Void in
            if error == nil {
                
                if let user = users {
                    
                    returnUser = User(newUser: user[0] as! PFUser)

                }
                
                
                
            }
        })
        
        
        return returnUser
        
        
    }
    
    
}