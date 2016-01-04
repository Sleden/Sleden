//
//  AddFriends.swift
//  Sleden
//
//  Created by Daniel Alvestad on 03/01/16.
//  Copyright © 2016 Daniel Alvestad. All rights reserved.
//

import UIKit
import Parse

class AddFriends: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBAction func addFriendButton(sender: AnyObject) {
        
        var username: String
        
        if let usernameTemp = usernameTextField.text {
            
            username = usernameTemp
            
        } else {
            print("Ikke langt nok brukernavn")
            return
            
        }
        
        
        if (username.utf16.count < 4) {
            print("Ikke langt nok brukernavn")
            return
            
        }
        
        
        let query = PFUser.query()
        query?.whereKey("username", equalTo: username)
        query?.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                if let user = objects?[0] as? PFUser {
                    print(user)
                    GetFriends.addFriend(self, user: user)
                    
                } else {
                    
                    print("fant ikke bruker")
                    
                }
                
                
            } else {
                print(error)
            }
            
            
            
        })
        
        
        
        
    }
}
