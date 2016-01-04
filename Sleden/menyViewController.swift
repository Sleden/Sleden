//
//  menyViewController.swift
//  Sleden
//
//  Created by Daniel Alvestad on 30/12/15.
//  Copyright © 2015 Daniel Alvestad. All rights reserved.
//

import UIKit
import Parse

class menyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    
        
        
    }

    
    override func viewDidAppear(animated: Bool) {
        
        // Sjekker om det er en bruker som er logget inn, hvis ikke må brukeren logge inn før appen kan tas i bruk.
        if (PFUser.currentUser()?.username == nil) {
            
            // Sender brukeren til LOGG INN viewet
            performSegueWithIdentifier("loginView", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet weak var logOut: UIButton!
    
    // Log ut knapp som logger ut brukeren og sender brukeren til LOGG INN skjermen. 
    @IBAction func logOutButton(sender: AnyObject) {
        PFUser.logOut()
        performSegueWithIdentifier("loginView", sender: nil)
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
