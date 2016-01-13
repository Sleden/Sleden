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
        
        // Henter først ut informasjon om brukeren vi ser på fra Parse
        let thisUserQuery = PFUser.query()
        thisUserQuery?.whereKey("objectId", equalTo: self.user!.userID!)
        thisUserQuery?.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
            
            // "Åpner" objectet ved å sjekke at det kan omformes til et PFUser object
            if let pfuser = object as? PFUser{
            
            // Henter så de 2 radene i "Friends" tabellen i Parse som inneholder alle vennene til både denne venne som "user" og brukeren som er lagret som PFUser.currentUser()
            let friendQuery = PFQuery(className: "Friends")
            friendQuery.whereKey("UserID", containedIn: [pfuser.objectId!,(PFUser.currentUser()?.objectId)!])
            friendQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            
                // Pakke ut objectet
                if let objects = objects {
                    
                    // Sjekker hvor mange objecter som har blitt hentet ned fra Parse
                    // Det skal være 2, men kan hende noe galt har skjedd, dermed sjekker vi også for 1 rad.
                    if objects.count == 2 {
                        
                        // Pakker ut objectene helt ned til userID
                        if let userID1 = objects[0]["UserID"] as? String, userID2 = objects[1]["UserID"] as? String {
                            
                            // Sletter så vennen både oss den tildligere vennen og oss brukeren.
                            self.deleteFriendFromDB(objects[0], userIDFriend: userID2)
                            self.deleteFriendFromDB(objects[1], userIDFriend: userID1)
                            
                        } else {
                            print("Feil ved unvrapping av optionals for userID fra de to radene vi henter fra Freinds databasen når vi skal slette brukere")
                        }
                        
                        
                    // Sjekker om det bare er en rad som kommer tilbake fra Parse, sletter så vennen i denne raden og regner med at 
                    //den andre ikke kom tilbake ettersom den ikke fantes (allerede slettet)
                    } else if objects.count == 1 {
                        print("en av brukerene er slettet fra venner databasen")
                        // Åpner userIDen og gjør det samme som for 2 rader
                        if let userID = objects[0]["UserID"] {
                            
                            // Sjekker hvilken av de to brukerne som "eier" denne raden
                            if userID as? String == PFUser.currentUser()?.objectId! {
                                self.deleteFriendFromDB(objects[0], userIDFriend: (userID as? String)!)
                            } else {
                                self.deleteFriendFromDB(objects[0], userIDFriend: (PFUser.currentUser()?.objectId)!)
                            }
                        }
                    
                    // Sjekker om fleren enn 2 rader kom tilbake, her må det dermed gis en feilmelding ettersom det ikke er mulig å vite om alle radene skal slettes eller ikke.
                    } else if objects.count > 2 {
                        print("For mange rader som representerer brukeren i venne tabellen.")
                    } else {
                        print("Vennene er allerede slettet fra bruker radene")
                    }
                } else {
                    
                    print("Error sletting av venner, kunne ikke unvrappe object optionalen (Listen av de to objektene for venner)")
                }
                
            })
            }
        })
        
        
    }
    
    
    /*
    Sletter vennen med userUDFriend fra vennelisten til userIDRow.
    */
    private func deleteFriendFromDB(userIDRow: PFObject, userIDFriend: String) {
        
        // Sjekker ar listen av venner kan kastes til en liste av PFUsers
        if var friends = userIDRow["friends"] as? [PFUser] {
        
            // Teller hvilken index en vennen befinner seg.
            var index = 0
            for friend in friends {
                if friend.objectId! == userIDFriend {
                        break
                }
                index++
            }
            
            friends.removeAtIndex(index)   // Fjerner vennen fra listen av venner
            
            // Legger til listen av venner til objektet igjen og lagrer objektet i Parse
            userIDRow["friends"] = friends
            userIDRow.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                
                // Sjekker om lagringen jukk bra og skriver ut success alerts!
                if success {
                    
                    // Ettersom denne funksjonen kjører 2 ganger sjekker skriver vi bare ut success alert for den ene gangen(blir feil hvis ikke)
                    if userIDFriend == (PFUser.currentUser()?.objectId)! {
                        
                        // alert actionen gjør slik at brukeren går automatisk tilbake til tabellen med venner.
                        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        })
                    
                        AlertView.showAlertWithOKAction(self, title: "Success", message: "\((self.user?.username)!) was deleted from friends", action: alertAction)
                        print("\((self.user?.username)!) was deleted from friends")
                    }
                
                // Printer ut error fra pars hvis den finnes og det er en feil
                } else {
                    if error != nil {
                        print("Error: \(error)")
                        AlertView.showAlertWithOK(self, title: "Error", message: "\(error)")
                    } else {
                        AlertView.showAlertWithOK(self, title: "Error", message: "Somthing went wrong when connecting to database")
                        print("Somthing went wrong when connecting to database")
                    }
                
                }

            })
        }
    }
    
    
  
    
    
    
    
    
    
    
    
    
}
