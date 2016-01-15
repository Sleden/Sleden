//
//  TableViewCellRequest.swift
//  Sleden
//
//  Created by Daniel Alvestad on 15/01/16.
//  Copyright © 2016 Daniel Alvestad. All rights reserved.
//

import UIKit

class TableViewCellRequest: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeOfRequestLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
