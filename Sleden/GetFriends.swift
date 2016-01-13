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
            
            defer {
                actInt.stopAnimating()
            }
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
                    
                    do {
                        if objects[0]["UserID"] as! String == currentUser.objectId! {
                        
                            try addFriendToDatabase(currentUser, newFriend: newFriend, friendObject: objects[0])
                            try addFriendToDatabase(newFriend, newFriend: currentUser, friendObject: objects[1])
                            AlertView.showAlertWithOK(view, title: "Success", message: "Added \(newFriend.username) to your friendlist")
                        
                        } else {
                            
                            try addFriendToDatabase(currentUser, newFriend: newFriend, friendObject: objects[1])
                            try addFriendToDatabase(newFriend, newFriend: currentUser, friendObject: objects[0])
                            AlertView.showAlertWithOK(view, title: "Success", message: "Added \(newFriend.username) to your friendlist")
                            
                        }
                    } catch AddFriendError.UserAlreadyFriend {
                        AlertView.showAlertWithOK(view, title: "Invalide", message: "You are already friend with this user")
                    } catch {
                        AlertView.showAlertWithOK(view, title: "Error", message: "There was somthing wrong with the connection to database")
                    }
                
                
                } else if objects.count == 1 {
                    do {
                        if objects[0]["UserID"]! as! String == currentUser.objectId! {
                            try addFriendToDatabase(currentUser, newFriend: newFriend, friendObject: objects[0])
                            createAndAddFriendToDatabase(newFriend, newFriend: currentUser)
                            AlertView.showAlertWithOK(view, title: "Success", message: "Added \(newFriend.username) to your friendlist")
                        } else {
                            try addFriendToDatabase(newFriend, newFriend: currentUser, friendObject: objects[0])
                            createAndAddFriendToDatabase(currentUser, newFriend: newFriend)
                            AlertView.showAlertWithOK(view, title: "Success", message: "Added \(newFriend.username) to your friendlist")
                        }
                    } catch AddFriendError.UserAlreadyFriend {
                        AlertView.showAlertWithOK(view, title: "Invalide", message: "You are already friend with this user")
                    } catch {
                        AlertView.showAlertWithOK(view, title: "Error", message: "There was somthing wrong with the connection to database")
                    }
                
                } else if objects.count == 0 {
                        createAndAddFriendToDatabase(currentUser, newFriend: newFriend)
                        createAndAddFriendToDatabase(newFriend, newFriend: currentUser)
                        AlertView.showAlertWithOK(view, title: "Success", message: "Added \(newFriend.username) to your friendlist")
                }
                
                
            } else {
                
                if error != nil {
                    print("Error: \(error)")
                } else {
                    print("Noe gikk galt med henting av brukere i Friends tabellen")
                }
                
            }
            
        })

        
        
    }
    

    static func createAndAddFriendToDatabase(user: PFUser, newFriend: PFUser){
        
        let newObject = PFObject(className: "Friends")
        let friends: [PFUser] = [newFriend]
        let friendRequests: [AnyObject] = []
        
        newObject["friends"] = friends
        newObject["UserID"] = user.objectId
        newObject["friendRequests"] = friendRequests
        
        newObject.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            
            if (success) {
                //AlertView.showAlertWithOK(UIViewController., title: "Success", message: "Added friend: \(newFriend.username!)")
                print("La til venn, og nytt felt for \(user.username)")
            }
            
            if error != nil {
                print("funket ikke!!")
                print(error)
                
            }
        })

        
    }
    
    
    static func addFriendToDatabase(user: PFUser, newFriend: PFUser, friendObject: PFObject) throws{
        if var friends = friendObject["friends"] as? [PFUser] {
            for friend in friends {
                if friend.objectId == newFriend.objectId {
                    print("Bruker alerede venn")
                    throw AddFriendError.UserAlreadyFriend
                }
            }
            
            friends.append(newFriend)
            friendObject["friends"] = friends
            friendObject.saveInBackground()
            //AlertView.showAlertWithOK(view, title: "Success", message: "Added friend: \(newFriend.username!)")
            print("Added friend: \(newFriend.username!), til \(user.username) sin venneliste)")
            
            
        } else {
            print("feiler her")
            throw AddFriendError.EmptyObject
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


enum AddFriendError: ErrorType {
    
    case UserAlreadyFriend
    case EmptyObject
    
}


