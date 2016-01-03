//
//  RegistrerViewController.swift
//  Sleden
//
//  Created by Daniel Alvestad on 30/12/15.
//  Copyright © 2015 Daniel Alvestad. All rights reserved.
//

import UIKit
import Parse

class RegistrerViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    // Initialiserer det spinnende hjulet, brukes når data lastes ned fra nettet
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Legger til design fra TextViewDesign klassen.
        TextViewDesigne.addDesigne(usernameField)
        TextViewDesigne.addDesigne(passwordField)
        TextViewDesigne.addDesigne(emailField)
        
        // Setter opp det spinnende hjulet (BØR VÆRE EN EGEN KLASSE ETTERHVER?)
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        
        // Sier hvordan tekst fielden skal deligere (litt usikker på hvordan denne funker)
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.emailField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func registrerButoon(sender: AnyObject) {
        
        // Fjerner tastaturet når knappen er trykket
        self.view.endEditing(true)
        
        let username = usernameField.text
        let password = passwordField.text
        let email = emailField.text
        
        // sjekker at ingen av feltene er tomme
        if (username == nil || password == nil || email == nil){
            
            // gir ut alert hvis en av dem er det!
            let alert = UIAlertController(title: "Invalid", message:"Username, password or email is empty", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            
            return
            
        }
        
        // TODO: Lage en egen klasse for alertene slik at det ikke blir så mye lik kode!
        
        // Gir ut alert hvis passordet, brukernavnet eller emailen er for korte
        if (username?.utf16.count < 4 || password?.utf16.count < 5){
            let alert = UIAlertController(title: "Invalid", message:"Username must be greater then 4 and Password must be greater then then 5.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        } else if(email?.utf16.count < 8){
            let alert = UIAlertController(title: "Invalid", message:"The email you typed was less then 8 caracters", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            
            // Hvis alle feltene er lange nok startes animasjonen av 
            // det spinnende hjulet og vi sender query til parse
        } else {
            
            // starter det spinnende hjulet
            self.actInd.startAnimating()
            
            // Lager en ny bruker
            let newUser = PFUser()
            
            newUser.email = email
            newUser.username = username
            newUser.password = password
            
            
            /*  Registrerer brukeren i bakgrunden (Appen forstetter slik at det ikke ser ut som den fryser)
                
                Det er en closure funksjon (funksjon inne i en funksjon)
                Funsjonen inni blir satt igang etter koden har fptt dataen fra parse
            
            */
            newUser.signUpInBackgroundWithBlock({(user,error) -> Void in
                
                // Stopper det spinnende hjluet
                self.actInd.stopAnimating()
                
                // Sjekker om det er kommet noe tilbake (hvis error, så er det ikke kommet noe tilbake)
                if ((error) != nil){
                    
                    // Viser en alert hvis en error er passert tilbake
                    let alert = UIAlertController(title: "Invalide", message:"\(error!.localizedDescription)", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                    self.presentViewController(alert, animated: true){}
                    
                } else {
                    
                    // Hvis alt er bra, vil en alert vise success og bruker vil bli tatt tilbake til log inn siden.
                    let alert = UIAlertController(title: "Success", message:"User \(username!) Created", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { alertAction in
                    
                    // tar brukeren tilbake til loginn skjermen (husk at det er en module suege, altså viewt er på toppen av de forfige viewt. Dermed er det likt som det var når vi trykket REGISTRER)
                    self.dismissViewControllerAnimated(true, completion: nil)
                        
                        
                })
                self.presentViewController(alert, animated: true){}
                    
                    
                }
                
                
            })
            
            
        }
        
        
    }

    // Går tilbake til Logg inn
    @IBAction func loggInnButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Funksjonen som gjør at bruker kan trykke enter for å få vekk tastaturet. 
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
