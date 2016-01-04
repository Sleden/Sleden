//
//  User.swift
//  Sleden
//
//  Created by Daniel Alvestad on 01/01/16.
//  Copyright © 2016 Daniel Alvestad. All rights reserved.
//

import Foundation
import Parse
import CoreData

class User {
    
    // Properties som kommer fra PFUser
    var username: String?
    var userID: String?

    var isFriend: userRelation?
    
    init(newUser: PFUser, isFriend: userRelation?){
        
        // Sjekker at brukernavnet og brukerID en som hentes fra databasen faktisk finnes (kan lagra bruker uten brukernavn)
        if let username = newUser["username"] as? String {
            self.username = username
        } else {
            self.username = nil
        }
        
        if let userID = newUser.objectId {
            self.userID = userID
        } else {
            self.userID = nil
        }
        
        // Setter hvilken type sammenheng brukeren har med denne brukeren
        self.isFriend = isFriend
    }
    
    convenience init(newUser: PFUser) {
        let isFriend: userRelation? = nil
        self.init(newUser: newUser, isFriend: isFriend)
    }

    
    // TODO: Lage en isEqual funksjon som kan bruke .contains() funksjonen nå table view skal refreshe
    
    
}