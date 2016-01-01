//
//  TableViewCell.swift
//  Sleden
//
//  Created by Daniel Alvestad on 01/01/16.
//  Copyright © 2016 Daniel Alvestad. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        //self.profileImageView.clipsToBounds = YES;
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
