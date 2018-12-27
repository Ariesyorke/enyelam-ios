//
//  OutcomingTextMessageCell.swift
//  Nyelam
//
//  Created by Bobi on 9/18/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class OutcomingTextMessageCell: NTableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var container: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.container.layer.borderWidth = 1
        self.container.layer.borderColor = UIColor.lightGray.cgColor

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
