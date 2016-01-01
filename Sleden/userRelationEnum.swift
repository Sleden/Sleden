//
//  userRelationEnum.swift
//  sleden2
//
//  Created by Daniel Alvestad on 19/12/15.
//  Copyright © 2015 Daniel Alvestad. All rights reserved.
//

import Foundation


enum userRelation {
    case Friend, SendtFriendRequest, RecivedFriendRequest, notFriends
    
    // Muligheter for funksjoner
    func acceptFriendRequest() {
        print("Friend request accepted")
    }
    
    func declineFriendRequest() {
        print("Friend request declined")
    }
}
