//
//  BackgroundView.swift
//  Sleden
//
//  Created by Daniel Alvestad on 03/01/16.
//  Copyright © 2016 Daniel Alvestad. All rights reserved.
//

import UIKit

class BackgroundView: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        // Background View
        
        //// Color Declarations
        let blue: UIColor = UIColor(red: 91/255, green: 202/255, blue: 255/255, alpha: 1.000)
        let green: UIColor = UIColor(red: 85/255, green: 239/255, blue: 203/255, alpha: 1.000)
        
        let context = UIGraphicsGetCurrentContext()
        
        //// Gradient Declarations
        let purpleGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [green.CGColor, blue.CGColor], [0, 1])
        
        //// Background Drawing
        let backgroundPath = UIBezierPath(rect: CGRectMake(0, 0, self.frame.width, self.frame.height))
        CGContextSaveGState(context)
        backgroundPath.addClip()
        CGContextDrawLinearGradient(context, purpleGradient,
            CGPointMake(160, 0),
            CGPointMake(160, 568),
            [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
        CGContextRestoreGState(context)
    }


}
