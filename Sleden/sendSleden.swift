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
    
    let sleden: Sleden
    
    init(fromUser: User, sledenUser: User, sledenType: SledenType) {
        self.sleden = Sleden(fromUser: fromUser, sledenUser: sledenUser , sledenType: sledenType)
        sendSleden()
    }
    
    
    func sendSleden() {
        
        let newSleden = PFObject(className: "Sleden")
        
        
        newSleden["sendtUser"] = self.sleden.fromUser
        newSleden["sledenUser"] = self.sleden.sledenUser
        newSleden["sledenType"] = self.sleden.sledenType.rawValue

        
            
        newSleden.saveInBackgroundWithBlock { (saved: Bool, error: NSError?) -> Void in

            if saved {
                
                print("Sendt a \(self.sleden.sledenType.rawValue) to \(self.sleden.sledenUser.username)")
                
                
            } else {
                if error != nil {
                    print("error: \(error)")
                } else {
                    print("somthing went wrong")
                }
            }
        }
        
        
    }
    
    /*
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
    */
    
}