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
        
        // Setter labelene sleden og vågen
        self.antallSledenLabel?.text = "Sleden: \(3)"
        self.antallVaagenLabel?.text = "Vågen: \(1)"
        
    }
    
    
    func getSledenVaagen(){
        
        if let userIDUnwraped = self.user!.userID {
            let query = PFQuery(className: "Sleden")
            query.whereKey("userID", equalTo: userIDUnwraped)
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    if objects?.count == 1 {
                        
                        if let object = objects {
                        
                            //self.antallSledenLabel!.text = object[0]["sleden"] as? String
                            //self.antallVaagenLabel!.text = object[0]["vaagen"] as? String
                            
                        }
                        
                    }
                    
                    
                }
                
                
            })
        }
        
    }
    
    
    
    @IBAction func sendSledenButton(sender: AnyObject) {
        
        if let username = self.user?.username {
            print("Sendt a sleden to \(username)")
        }
        
    }

    @IBAction func sendVaagenButton(sender: AnyObject) {
        
        if let username = self.user?.userID {
            print("Sendt a vågen to \(username)")
        }
    }
}
