//
//  NUITableViewCell.swift
//  Nyelam
//
//  Created by Bobi on 4/16/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

class NTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
