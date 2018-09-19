//
//  IncomingTextMessageCell.swift
//  Nyelam
//
//  Created by Bobi on 9/18/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class IncomingTextMessageCell: NTableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
