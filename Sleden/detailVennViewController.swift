//
//  detailVennViewController.swift
//  Sleden
//
//  Created by Daniel Alvestad on 04/01/16.
//  Copyright © 2016 Daniel Alvestad. All rights reserved.
//

import UIKit
import Parse

class detailVennViewController: UIViewController {
    
    
    
    var user: User? {
        
        didSet {
            
            configureView()
            
        }
        
    }
    
    
    @IBOutlet weak var antallSledenLabel: UILabel?
    @IBOutlet weak var antallVaagenLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        //self.usernameLabel.text = username
        //getSledenVaagen()
        
    }
    
    
    private func configureView() {
        
        // Setter antall sleden og vaagen
        getSledenVaagen()
        
        
        if let username = self.user?.username {
            self.title = username
        }
        
        // Configure navbar back button
        if let buttonfont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) {
            
            let barButtonAttributesDictionary: [String: AnyObject]? = [
                
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: buttonfont
                
            ]
            
            UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributesDictionary, forState: .Normal)
        }
        
        
        
        
    }
    
    
    func getSledenVaagen(){
        
        self.antallSledenLabel?.text = "Sleden: 3"
        self.antallVaagenLabel?.text = "Vaagen: 2"
        
        
        
        /*
        if let user = self.user {
            
            let thisPFUser = PFObject(className: "User")
            
            thisPFUser["objectId"] = user.userID
            thisPFUser["username"] = user.username
            
            let query = PFQuery(className: "Sleden")
            query.whereKey("sledenUser", equalTo: thisPFUser)
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                
                
                
                if let usersSleden = objects {
                    
                    var numberOfSleden = 0
                    var numberOfVaagen = 0
                    
                    for sleden in usersSleden {
                        if (sleden["sledenType"] as? String == SledenType.Sleden.rawValue) {
                            numberOfSleden++
                        } else {
                            numberOfVaagen++
                        }
                        
                    }
                    
                    self.antallSledenLabel?.text = String(numberOfSleden)
                    self.antallVaagenLabel?.text = String(numberOfVaagen)
                    
                    
                } else {
                    
                    self.antallSledenLabel?.text = "Sleden: "
                    self.antallVaagenLabel?.text = "Vaagen: "
                    
                    print(error)
                    
                }
                
                
                
                
                
                
            })
        }
        */
        
    }
    
    
    
    @IBAction func sendSledenButton(sender: AnyObject) {
        
        //SendSleden(fromUser: User(newUser: PFUser.currentUser()!), sledenUser: user!, sledenType: SledenType.Sleden)
        print("Sendt sleden to \(user?.username)")
        
    }

    @IBAction func sendVaagenButton(sender: AnyObject) {
        
        //SendSleden(fromUser: User(newUser: PFUser.currentUser()!), sledenUser: user!, sledenType: SledenType.Sleden)
        print("Sendt vaagen to \(user?.username)")
    }
    
    
    @IBAction func deleteFriendButton(sender: AnyObject) {
        
        let thisUserQuery = PFUser.query()
        thisUserQuery?.whereKey("objectId", equalTo: self.user!.userID!)
        thisUserQuery?.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
            
            if let pfuser = object as? PFUser{
                
            
        
        
            let friendQuery = PFQuery(className: "Friends")
            friendQuery.whereKey("friends", equalTo: pfuser)
            friendQuery.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            
                if let user = object {
                
                    var friends = user["friends"] as! [PFUser]
                
                    var index = 0
                    for friend in friends {
                        
                        if friend.objectId! == (self.user?.userID)! {
                            print(friend)
                            break
                        }
                        index++
                    
                    }
                
                    friends.removeAtIndex(index)
                    user["friends"] = friends
                    user.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    
                        if success {
                        
                            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                                self.navigationController?.popToRootViewControllerAnimated(true)
                            })
                            
                            AlertView.showAlertWithOKAction(self, title: "Success", message: "\(self.user?.username!) was deleted from friends", action: alertAction)
                            
                            
                        
                        } else {
                        
                            if error != nil {
                            
                                print("Error: \(error)")
                                AlertView.showAlertWithOK(self, title: "Error", message: "Somthing went wrong when trying to delete friend")
                            
                            } else {
                            
                                AlertView.showAlertWithOK(self, title: "Error", message: "Somthing went wrong when connecting to database")
                                print("Somthing went wrong when connecting to database")
                            
                            
                            }
                        
                        }
                    
                    
                    })
                
                    
                
                
                
                
                
                
                }
            
            
            }
            }
        })
        
    }
    
    
  
    
    
    
    
    
    
    
    
    
}
