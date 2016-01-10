//
//  TextViewDesigne.swift
//  Sleden
//
//  Created by Daniel Alvestad on 31/12/15.
//  Copyright © 2015 Daniel Alvestad. All rights reserved.
//

import Foundation
import UIKit


struct TextViewDesigne {
    
    
    
    
    static func addDesigne(textField: UITextField) {
        
        textField.layer.cornerRadius = CGFloat(Float(21.0))
        textField.font = UIFont(name: "Helvetica", size: 22.0)
        //textField.placeholder
        /*
        textField.borderStyle = UITextBorderStyle.None
        
        
        textField.layer.shadowColor = UIColor.blackColor().CGColor
        textField.layer.shadowOffset = CGSizeMake(10, 10)
        textField.layer.shadowOpacity = 1.0
        textField.layer.shadowRadius = 1.0
        
        */
        textField.layer.opacity = 0.9
        textField.textRectForBounds(CGRect(x: 5, y: 5, width: 5, height: 5))
        textField.backgroundColor = UIColor.clearColor()


    }
    
    
    
}

