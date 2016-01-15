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
    
    
    override func viewDidLoad() {
        //self.viewDidLoad()
        
        
        TextViewDesigne.addDesigne(usernameTextField)
        
        view.backgroundColor = UIColor.clearColor()
        view.opaque = false
        
        // Designe for å legge til den gjennomsiktige bakgrunden.
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            self.view.insertSubview(blurEffectView, atIndex: 0) //if you have more UIViews, use an insertSubview API to place it where needed
        }
        else {
            //self.view.backgroundColor = UIColor.blackColor()
        }

    

        
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    @IBAction func addFriendButton(sender: AnyObject) {
        
        var username: String
        
        if let usernameTemp = usernameTextField.text {
            
            username = usernameTemp
            
        } else {
            AlertView.showAlertWithOK(self, title: "Invalide", message: "Brukernavn tekstfeltet er tomt")
            print("Brukernavn tekstfeltet er tomt")
            return
            
        }
        
        
        if (username.utf16.count < 4) {
            
            AlertView.showAlertWithOK(self, title: "Invalide", message: "Ikke langt nok brukernavn")
            print("Ikke langt nok brukernavn")
            return
            
        }
        
        if username == PFUser.currentUser()?.username {
            
            AlertView.showAlertWithOK(self, title: "Invalide", message: "Can not be friend with yourself")
            print("Can not be friend with yourself")
            
            return
            
        }
        
        
        let newFriendQuery = PFUser.query()
        newFriendQuery?.whereKey("username", equalTo: username)
        
        let isAlreadyFriendQuery1 = PFQuery(className: "Friends2")
        isAlreadyFriendQuery1.whereKey("User1", matchesQuery: newFriendQuery!).whereKey("User2", equalTo: PFUser.currentUser()!)
        
        let isAlreadyFriendQuery2 = PFQuery(className: "Friends2")
        isAlreadyFriendQuery2.whereKey("User2", matchesQuery: newFriendQuery!).whereKey("User1", equalTo: PFUser.currentUser()!)
        
        let query = PFQuery.orQueryWithSubqueries([isAlreadyFriendQuery1, isAlreadyFriendQuery2])
        
        query.getFirstObjectInBackgroundWithBlock { (row: PFObject?, error: NSError?) -> Void in
            
            if row != nil {
                
                AlertView.showAlertWithOK(self, title: "Error", message: "Du er allerede venn med \(username)")
                if error != nil {
                    print("Error: \(error)")
                }
                
            } else {
                
                let newFriendRow = PFObject(className: "Friends2")
                
                newFriendQuery?.getFirstObjectInBackgroundWithBlock({ (returnRow: PFObject?, error: NSError?) -> Void in
                    
                    if let userUnwrapped = returnRow,
                        user = userUnwrapped as? PFUser {
                        
                        newFriendRow["User1"] = PFUser.currentUser()!
                        newFriendRow["User2"] = user
                            
                        newFriendRow["FriendRequestPending"] = true
                        newFriendRow["FriendRequestFrom"] = PFUser.currentUser()!

                        newFriendRow.saveInBackground()
                        
                    }
                })
            }
        }
        
        
        
        
        
        /*
        let query = PFUser.query()
        query?.whereKey("username", equalTo: username)
        query?.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                if let users = objects{
                    if users.count != 0 {
                        let user = users[0] as? PFUser
                        GetFriends.addFriend(self, user: user!)
                    } else {
                        AlertView.showAlertWithOK(self, title: "Invalide", message: "Fant ikke bruker")
                        print("fant ikke bruker")
                    }
                } else{
                    
                    AlertView.showAlertWithOK(self, title: "Invalide", message: "Fant ikke bruker")
                    print("fant ikke bruker")
                    
                }
                
                
            } else {
                AlertView.showAlertWithOK(self, title: "Error", message: "Noe gikk galt ved henting av data fra databasen")
                if error != nil {
                    print(error)
                } else {
                    print("Noe gikk galt, error = nil")
                }
            }
            
            
            
        })
        */
        
        
        
    }

    
    
   
    
    
    
    
}
