//
//  FriendsModule.swift
//  Sleden
//
//  Created by Daniel Alvestad on 14/01/16.
//  Copyright © 2016 Daniel Alvestad. All rights reserved.
//

import Foundation
import Parse

class FriendsModule {
    
    var myFriends: [User]
    
    init(myFriends: [User]) {
        self.myFriends = myFriends
    }
    
    
    func addFriendToMyFriendsArray(user: PFUser, friendRelation: userRelation) {
        
        let friend = User(newUser: user, isFriend: friendRelation)
    
        if !isContainedInMyFriendsArray(friend) {
            
            self.myFriends.append(friend)
        }
    
    }
    
    private func isContainedInMyFriendsArray(user: User) -> Bool {
        
        for friend in self.myFriends {
            
            if let userID = user.userID where userID == friend.userID {
                
                if friend.isFriend != user.isFriend {
                    friend.isFriend = user.isFriend
                }
                
                return true
            }
        }
        
        return false
        
    }
    
    
    func lookForDeletedFriends(venner: [PFObject]) {
        
        if venner.count != self.myFriends.count {
            // Delete friends that is not contained in usersThatIsContained
            
            var index = 0
            
            for userInMyFriends in self.myFriends {
                
                var isContained = false

                for venn in venner {
                    
                    if let venn1 = venn["User1"], venn1IDAny = venn1.objectId, venn1ID = venn1IDAny,
                        let venn2 = venn["User2"], venn2IDAny = venn2.objectId, venn2ID = venn2IDAny,
                        let friendLocalArray = userInMyFriends.userID {
                    
                    
                            print("BOOL: \(venn1ID == friendLocalArray ), \(venn2ID == friendLocalArray), \(venn1ID),\(venn2ID), \(friendLocalArray)")
                    
                            if venn1ID == friendLocalArray || venn2ID == friendLocalArray {
                                isContained = true
                            }
                    } else {
                        print("Feilet å unwrappe raden eller lokale listen")
                    }
                }
                
            
                if !isContained {
                    self.myFriends.removeAtIndex(index)
                    index--
                }
                
                index++
                
            }
            
        }
    }
    
    //MARK: - Functions for getting friends based on request
    
    func friends() -> [User] {
        
        var friends: [User] = []
        
        for friend in self.myFriends {
            
            if friend.isFriend == userRelation.Friend {
                friends.append(friend)
            }
            
        }
        
        return friends
        
    }
    
    func friendRequests() -> [User] {
        var friendRequests: [User] = []
        
        for user in self.myFriends {
            if user.isFriend == userRelation.RecivedFriendRequest || user.isFriend == userRelation.SendtFriendRequest {
                friendRequests.append(user)
            }
        }
        
        return friendRequests
    }
    
    
    
    
}