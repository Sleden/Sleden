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
                    
                    var usersThatIsContained: [PFUser] = []
                    
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
                                        
                                        self.myFriends.append(user)
                                        usersThatIsContained.append(friend)
                                    } else {
                                        usersThatIsContained.append(friend)
                                    }
                                    
                                    
                                    // TODO: Bør bruke en self.myFriends.contains(user), men den endrer append funksjonen
                                    
                                }
                                table.reloadData()
                            })
                        }
                        
                    }
                    
                    if usersThatIsContained.count != self.myFriends.count {
                        var deleteAtIndexArray: [Int]?
                        var myFriendsIndex = 0
                        for myFriendsUser in self.myFriends {
                            
                            for userThatIsContained in usersThatIsContained {
                                
                                if myFriendsUser.userID == userThatIsContained.objectId {
                                    deleteAtIndexArray?.append(myFriendsIndex)
                                }
                                
                            }
                            myFriendsIndex++
                            
                        }
                        
                        if let deleteAtIndexArray = deleteAtIndexArray {
                            
                            for deleteAtIndex in deleteAtIndexArray {
                                
                                self.myFriends.removeAtIndex(deleteAtIndex)
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
                
                table.reloadData()
                
                
            } else {
                print(error)
            }
            
            
        })
        
    }
    
    static func addFriend(view: UIViewController, user: PFUser) {
        
        //let newFriend = User(username: username, userID: userID, isFriend: userRelation.Friend)
        
        addFriendWithPFUserObject(view, newFriend: user)
        
        
    }
    
    
    static func addFriendWithPFUserObject(view: UIViewController, newFriend: PFUser) {
        
        //if newFriend.isFriend != userRelation.Friend {
        //    newFriend.isFriend = userRelation.Friend
        //}
        
        let queryFriends = PFQuery(className: "Friends")
        
        queryFriends.whereKey("UserID", containedIn: [(PFUser.currentUser()?.objectId)!, newFriend.objectId!])
        queryFriends.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            
            let currentUser = PFUser.currentUser()!
            
            if let objects = objects {
                
                if objects.count == 2 {
                    
                    
                    
                    if objects[0].objectId == currentUser.objectId {
                        
                        self.addFriendToDatabase(currentUser, newFriend: newFriend, friendObject: objects[0], view:  view)
                        self.addFriendToDatabase(newFriend, newFriend: currentUser, friendObject: objects[1], view: view)
                        
                    } else {
                        self.addFriendToDatabase(currentUser, newFriend: newFriend, friendObject: objects[1], view: view)
                        self.addFriendToDatabase(newFriend, newFriend: currentUser, friendObject: objects[0], view: view)
                    }
                    
                    
                } else if objects.count == 1 {
                    
                    if objects[0] == currentUser.objectId {
                        
                        self.addFriendToDatabase(currentUser, newFriend: newFriend, friendObject: objects[0], view: view)
                        self.createAndAddFriendToDatabase(newFriend, newFriend: currentUser, view: view)
                        
                    } else {
                        
                        self.addFriendToDatabase(newFriend, newFriend: currentUser, friendObject: objects[0], view: view)
                        self.createAndAddFriendToDatabase(currentUser, newFriend: newFriend, view: view)
                        
                    }
                    
                }
                
                
            } else {
                
                if error != nil {
                    print("Error: \(error)")
                } else {
                    print("Noe gikk galt med henting av brukere i Friends tabellen")
                }
                
            }
            
            
            if error == nil {
                if let user = objects {
                    if user.count == 1 {
                        if var friends = user[0]["friends"] as? [PFUser] {
                            for friend in friends {
                                if friend.objectId == newFriend.objectId {

                                    AlertView.showAlertWithOK(view, title: "Invalide", message: "Bruker alerede venn")
                                    print("Bruker alerede venn")
                                    return
                                    
                                }
                            }
                            
                            friends.append(newFriend)
                            user[0]["friends"] = friends
                            user[0].saveInBackground()
                            AlertView.showAlertWithOK(view, title: "Success", message: "Added friend: \(newFriend.username!)")
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
                                AlertView.showAlertWithOK(view, title: "Success", message: "Added friend: \(newFriend.username!)")
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
                print(error)
            }
            
        })

        
        
    }
    

    static func createAndAddFriendToDatabase(user: PFUser, newFriend: PFUser, view: UIViewController) {
        
        let newObject = PFObject(className: "Friends")
        let friends: [PFUser] = [newFriend]
        let friendRequests: [AnyObject] = []
        
        newObject["friends"] = friends
        newObject["UserID"] = (PFUser.currentUser()?.objectId)!
        newObject["friendRequests"] = friendRequests
        print("ender her?")
        newObject.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            
            if (success) {
                AlertView.showAlertWithOK(view, title: "Success", message: "Added friend: \(newFriend.username!)")
                print("La til venn, og nytt felt")
                
            }
            
            if error != nil {
                print("funket ikke!!")
                print(error)
                
                
            }
        })

        
    }
    
    
    static func addFriendToDatabase(user: PFUser, newFriend: PFUser, friendObject: PFObject, view: UIViewController){
        if var friends = friendObject["friends"] as? [PFUser] {
            for friend in friends {
                if friend.objectId == newFriend.objectId {
                    
                    AlertView.showAlertWithOK(view, title: "Invalide", message: "Bruker alerede venn")
                    print("Bruker alerede venn")
                    return
                    
                }
            }
            
            friends.append(newFriend)
            friendObject["friends"] = friends
            friendObject.saveInBackground()
            AlertView.showAlertWithOK(view, title: "Success", message: "Added friend: \(newFriend.username!)")
            print("Added friend: \(newFriend.username!))")
            
        } else {
            print("feiler her")
        }

    }
    
    
    
    
    
    
    func findIfUserIsDeleted(table: UITableView) {
        print("Finf if user is deleted")
        let query = PFQuery(className: "Friends")
        query.whereKey("UserID", equalTo: (PFUser.currentUser()?.objectId)!)
        query.getFirstObjectInBackgroundWithBlock({ (user: PFObject?, error: NSError?) -> Void in
            
            if let user = user {
                
                var index = 0
                
                for localFriend in self.myFriends {
                    
                    var contained = false
                    
                    for dbFriend in (user["friends"] as? [PFUser])! {
                        if localFriend.userID == dbFriend.objectId{
                            contained = true
                            break
                        }
                        
                    }
                    
                    if !contained {
                        self.deleteFriendFromArrayWithIndex(index, table: table)
                    }
                    index++
                
                }
                
            } else {
                
                if error != nil {
                    print(error)
                } else {
                    print("There is no users")
                }
                
                
            }
            
        })
        
        
    }
    
    
    
    func deleteFriendFromArrayWithUsername(username: String, table: UITableView) {
        
        var index = 0
        
        for user in self.myFriends {
            
            if username == user.username {
                
                deleteFriendFromArrayWithIndex(index, table: table)
                
            }
            index++
        }
        
    }
    
    
    
    
    func deleteFriendFromArrayWithIndex(index: Int, table: UITableView) {
        
        self.myFriends.removeAtIndex(index)
        table.reloadData()
        
        
        
    }
    
    
    
    
    
    
}