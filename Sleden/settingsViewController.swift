//
//  settingsViewController.swift
//  Sleden
//
//  Created by Daniel Alvestad on 06/01/16.
//  Copyright © 2016 Daniel Alvestad. All rights reserved.
//

import UIKit
import Parse

class settingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func logOutButton(sender: AnyObject) {
        
        
        PFUser.logOut()
        
        
        
        self.tabBarController?.selectedIndex = 0
        self.tabBarController?.reloadInputViews()
        
    }
    
    
    

}
