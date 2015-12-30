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
        
        
        if (PFUser.currentUser()?.username == nil) {
            performSegueWithIdentifier("loginView", sender: nil)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet weak var logOut: UIButton!
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
