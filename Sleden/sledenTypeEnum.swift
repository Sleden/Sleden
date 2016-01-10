//
//  sledenTypeEnum.swift
//  Sleden
//
//  Created by Daniel Alvestad on 08/01/16.
//  Copyright © 2016 Daniel Alvestad. All rights reserved.
//

import Foundation


enum SledenType: String {
    
    case Sleden = "sleden"
    case Vaagen = "vaagen"
    
    func printStorBokstav() -> String {
        if self == .Sleden {
            return "Sleden"
        } else {
            return "Vågen"
        }
    }
    
}