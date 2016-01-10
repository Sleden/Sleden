//
//  AlerView.swift
//  Sleden
//
//  Created by Daniel Alvestad on 09/01/16.
//  Copyright © 2016 Daniel Alvestad. All rights reserved.
//

import UIKit


struct AlertView {
    
    
    static func showAlertWithOKAction(view: UIViewController, title: String, message: String, action: UIAlertAction) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(action)
        view.presentViewController(alert, animated: true){}
        
        
    }
    
    static func showAlertWithOK(view: UIViewController, title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        view.presentViewController(alert, animated: true){}
        
        
    }
    
}
