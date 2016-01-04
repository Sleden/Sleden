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
    
    func getFriends(table: UITableView, actInt: UIActivityIndicatorView) {
        
        
        
        let queryFriends = PFQuery(className: "Friends")
        queryFriends.whereKey("UserID", equalTo: (PFUser.currentUser()?.objectId)!)
        actInt.startAnimating()
        
        queryFriends.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            
            actInt.stopAnimating()
            
            if error == nil {
                
                if let user = objects?[0]{
                    
                    if let friends = user["friends"] as? [PFUser] {
                        for friend in friends {
                            
                            
                            friend.fetchInBackgroundWithBlock({ (thisFriend: PFObject?, error: NSError?) -> Void in
                                
                                if let thisUser = thisFriend as? PFUser {
                                
                                    let user: User = User(newUser: thisUser, isFriend: userRelation.Friend)
                                    
                                    var isContained = false
                                    
                                    for i in self.myFriends {
                                        
                                        if i.userID == user.userID! {
                                            
                                            isContained = true
                                            break
                                            
                                        }
                                        
                                    }
                                    
                                    
                                    
                                    if !isContained {
                                        print(self.myFriends.count)
                                        self.myFriends.append(user)
                                    }
                                    
                                    // TODO: Bør bruke en self.myFriends.contains(user), men den endrer append funksjonen
                                    
                                
                                }
                                
                                table.reloadData()
                            })
                            
                        }
                        
                    }
                }
                
                
            } else {
                print(error)
            }
            
            
        })
        
    }
    
    static func addFriend(view: UIViewController, user: PFUser) {
        
        //let newFriend = User(username: username, userID: userID, isFriend: userRelation.Friend)
        
        addFriendWithUserObject(view, newFriend: user)
        
        
    }
    
    
    static func addFriendWithUserObject(view: UIViewController, newFriend: PFUser) {
        
        //if newFriend.isFriend != userRelation.Friend {
        //    newFriend.isFriend = userRelation.Friend
        //}
        
        let queryFriends = PFQuery(className: "Friends")
        queryFriends.whereKey("UserID", equalTo: (PFUser.currentUser()?.objectId)!)
        
        queryFriends.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            
            print("Ine i blokken")
            if error == nil {
                print(objects)
                
                if let user = objects {
                    
                    if user.count == 1 {
                    
                        print("Feiler her?")
                    
                        if var friends = user[0]["friends"] as? [PFUser] {
                            
                            for friend in friends {
                                
                                if friend.objectId == newFriend.objectId {
                                    
                                    print("Bruker alerede venn")
                                    
                                    return
                                    
                                }
                                
                            }
                            
                            friends.append(newFriend)
                            user[0]["friends"] = friends
                            user[0].saveInBackground()
                            print("Added friend: \(newFriend.username!))")
                        
                        } else {
                        
                            print("feiler her")
                        
                        }
                    } else {
                    
                        print(user.count)
                    
                        let newObject = PFObject(className: "Friends")
                        let friends: [PFUser] = [newFriend]
                        let friendRequests: [AnyObject] = []
                    
                        newObject["friends"] = friends
                        newObject["UserID"] = (PFUser.currentUser()?.objectId)!
                        newObject["friendRequests"] = friendRequests
                        print("ender her?")
                        newObject.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                            
                            if (success) {
                                
                                print("La til venn, og nytt felt")
                                
                            }
                            
                            if error != nil {
                                print("funket ikke!!")
                                print(error)
                                
                                
                            }
                        })
                    
                        
                    
                    }
                } else {
                    
                    print("Feilet ved pakke ut optional")
                    
                }
            } else {
                print("her?")
                print(error)
            }
            
        })

        
        
    }
    
    
}