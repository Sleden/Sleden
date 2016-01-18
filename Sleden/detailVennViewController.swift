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
    
    
    // Når denne variabelen er satt vil vi konfigurer viewet, men ikke før
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
    
    
    func getFriendInformation() {
        
        let friendQuery = PFQuery(className: "Friends2")
        
        if let currentUser = PFUser.currentUser(),
            let thisUser = user {
                
                let thisPFUser = PFObject(withoutDataWithClassName: "User", objectId: thisUser.userID!)
                
                friendQuery.whereKey("User1", containedIn: [currentUser, thisPFUser]).whereKey("User2", containedIn: [currentUser, thisPFUser])
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
        
        let pfUser = PFUser(withoutDataWithObjectId: self.user?.userID)
        
        let newSleden = PFObject(className: "Sleden")
        newSleden["sledenUser"] = pfUser
        newSleden["sendtUser"] = PFUser.currentUser()!
        newSleden["sledenType"] = "sleden"
        
        newSleden.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            if success {
                
                AlertView.showAlertWithOK(self, title: "Success", message: "Sendt a sleden to \(self.user?.username!)")
                
            } else {
                if error != nil {
                    AlertView.showAlertWithOK(self, title: "Error", message: "")
                }
            }
            
            
        }
        
    }

    @IBAction func sendVaagenButton(sender: AnyObject) {
        
        //SendSleden(fromUser: User(newUser: PFUser.currentUser()!), sledenUser: user!, sledenType: SledenType.Sleden)
        print("Sendt vaagen to \(user?.username)")
        
        
        
        
    }
    
    
    @IBAction func deleteFriendButton(sender: AnyObject) {
        
        
        let friendsQuery1 = PFQuery(className: "Friends2")
        let friendsQuery2 = PFQuery(className: "Friends2")
        
        if let currentUser = PFUser.currentUser() {
        
            friendsQuery1.whereKey("User1", equalTo: currentUser)
            friendsQuery2.whereKey("User2", equalTo: currentUser)
            
        }
        
        let deleteFriendQuery = PFQuery.orQueryWithSubqueries([friendsQuery1, friendsQuery2])
        
        deleteFriendQuery.findObjectsInBackgroundWithBlock( { (objects: [PFObject]?, error: NSError?) -> Void in
            if let friendObjects = objects {
                
                for friendObject in friendObjects {
                    
                    if friendObject["User1"].objectId == self.user?.userID || friendObject["User2"].objectId == self.user?.userID {
                        friendObject.deleteInBackground()
                        // alert actionen gjør slik at brukeren går automatisk tilbake til tabellen med venner.
                        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        })
                        
                        AlertView.showAlertWithOKAction(self, title: "Success", message: "\((self.user?.username)!) was deleted from friends", action: alertAction)
                        print("\((self.user?.username)!) was deleted from friends")

                    }
                    
                }
                
                
                
                
            }
        })
    }
}
