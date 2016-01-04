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
    
    
    
    let username: String?
    let userID: String?
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var antallSledenLabel: UILabel!
    @IBOutlet weak var antallVaagenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameLabel.text = username
        getSledenVaagen()
        
    }
    
    func getSledenVaagen(){
        
        if let userIDUnwraped = userID {
            let query = PFQuery(className: "Sleden")
            query.whereKey("userID", equalTo: userIDUnwraped)
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    if objects?.count == 1 {
                        
                        if let object = objects {
                        
                            self.antallSledenLabel.text = object[0]["sleden"] as? String
                            self.antallVaagenLabel.text = object[0]["vaagen"] as? String
                            
                        }
                        
                    }
                    
                    
                }
                
                
            })
        }
        
    }
    
    
    
    @IBAction func sendSledenButton(sender: AnyObject) {
        
        
        print("Sendt a sleden to \(username)")
        
    }

    @IBAction func sendVaagenButton(sender: AnyObject) {
        
        
        print("Sendt a vågen to \(username)")
        
    }
}
