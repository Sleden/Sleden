//
//  ViewController.swift
//  Sleden
//
//  Created by Daniel Alvestad on 29/12/15.
//  Copyright © 2015 Daniel Alvestad. All rights reserved.
//

import UIKit
import Parse

class LoggInnViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passordLabel: UITextField!
    
    // Oppretter et "Spinnende hjul"
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    
    
    let cornerRadius = CGFloat(Float(17.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameLabel.layer.cornerRadius = cornerRadius
        self.passordLabel.layer.cornerRadius = cornerRadius
        
        // Går rett til menyen hvis brukeren allerede er logget inn.
        if (PFUser.currentUser() != nil){
            print("Did log in user")
            //self.performSegueWithIdentifier("startAppLog", sender: PFUser.currentUser())
        }
        
        // Setter opp det spinnende hjulet
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func loggInnButton() {
        
        let username = self.usernameLabel.text
        let password = self.passordLabel.text
        
        
        if (username?.utf16.count < 4 || password?.utf16.count < 5){
            
            // Gir feilmeding hvis brukernavnet eller passordet er for kort
            let alert = UIAlertController(title: "Invalid", message:"Username must be greater then 4 and Password must be greater then then 5.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            
        } else {
            
            // Starter spinnende hjulet
            self.actInd.startAnimating()
            
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: {(user,error) -> Void in
                
                // Stopper Spinnende hjulet
                self.actInd.stopAnimating()
                
                // Sjekker om brukeren finnes, og at passordet er rett
                if ((user) != nil){
                    let alert = UIAlertController(title: "Success", message:"Logged In", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { alertAction in
                        
                        // Hvis passord og brukernavn stemmer lukkes innloggingsvinduet
                        print("Did log in user")
                        //self.performSegueWithIdentifier("startAppLog", sender: user)
                        
                        
                        })
                    
                    // Setter success meldingen for fulført innlogging
                    self.presentViewController(alert, animated: true){}
                    
                } else {
                    
                    // Gir feilmelding hvis brukernavnet eller passordet er feil.
                    let alert = UIAlertController(title: "Invalide", message:"\(error!)", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                    self.presentViewController(alert, animated: true){}
                }
            })
            
        }

        
        
        
    }

    @IBAction func registrerButton() {
        
        //self.performSegueWithIdentifier("SignInViewController", sender: self)
        
        
    }

}

