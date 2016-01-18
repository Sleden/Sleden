//
//  ViewController.swift
//  Sleden
//
//  Created by Daniel Alvestad on 29/12/15.
//  Copyright © 2015 Daniel Alvestad. All rights reserved.
//

import UIKit
import Parse

class LoggInnViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passordLabel: UITextField!
    
    // Oppretter et "Spinnende hjul"
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Legger til design spesifisert i TextViewDesigne klassen.
        TextViewDesigne.addDesigne(usernameLabel)
        TextViewDesigne.addDesigne(passordLabel)
        
        // Setter opp det spinnende hjulet
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        
        // Sier hvordan tekst fielden skal deligere (litt usikker på hvordan denne funker)
        self.usernameLabel.delegate = self
        self.passordLabel.delegate = self
        
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Gjør slik at keyboardet forsvinner når man trykker enter. 
    // Må også ha med UITextFieldDelegate som superclass og self.textfield.delegate = self for at det skal fungere.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func loggInnButton() {
        
        // Når log inn knappen er trykket forsvinner tastaturet!
        self.view.endEditing(true)
        
        // Henter brukernavn og passord fra tekstfeltet
        let username = self.usernameLabel.text
        let password = self.passordLabel.text
        
        // Sjekker om brukernavnet og passordet er langt nok
        if (username?.utf16.count < 4 || password?.utf16.count < 5){
            
            // Gir feilmeding hvis brukernavnet eller passordet er for kort
            AlertView.showAlertWithOK(self, title: "Invalide", message: "Username must be greater then 4 and Password must be greater then then 5.")
            
        } else {
            
            // Starter spinnende hjulet
            self.actInd.startAnimating()
            
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: {(user,error) -> Void in
                
                // Stopper Spinnende hjulet
                self.actInd.stopAnimating()
                
                // Sjekker om brukeren finnes, og at passordet er rett
                if ((user) != nil){
                    
                    let alertAction = UIAlertAction(title: "OK", style: .Default) { alertAction in
                        
                        // Hvis passord og brukernavn stemmer lukkes innloggingsvinduet
                        print("Did log in user")
                        //self.performSegueWithIdentifier("startAppLog", sender: user)
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    }
                    
                    AlertView.showAlertWithOKAction(self, title: "Success", message: "Logged Inn", action: alertAction)
                    
                    self.updateInstallation()
                    
                } else {
                    
                    // Gir feilmelding hvis brukernavnet eller passordet er feil.
                    AlertView.showAlertWithOK(self, title: "Invalide", message: "\(error!.localizedDescription)")
                }
            })
        }
    }
    
    
    func updateInstallation() {
        let installation = PFInstallation.currentInstallation()
        
        installation["User"] = PFUser.currentUser()
        
        installation.saveInBackground()

    }

    
    
    
    // Denne har for øyeblikket ingen funksjon, trigger overgangen i Storyboardet!
    @IBAction func registrerButton() {
        
        //self.performSegueWithIdentifier("SignInViewController", sender: self)
        
        
    }
    
    

}

