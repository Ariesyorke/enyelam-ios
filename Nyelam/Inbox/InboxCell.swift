//
//  InboxCell.swift
//  Nyelam
//
//  Created by Bobi on 9/17/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class InboxCell: NTableViewCell {
    @IBOutlet weak var ticketIdLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var picLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var container: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initData(inbox: Inbox) {
        self.ticketIdLabel.text = "#\(inbox.ticketId!)"
        self.subjectLabel.text = inbox.subject
        if let status = inbox.status {
            self.statusLabel.text = status
            if status.lowercased() == "open" {
                self.statusLabel.textColor = UIColor.green
            } else {
                self.statusLabel.textColor = UIColor.red
            }
        }
        
        self.picLabel.text = inbox.name
        if let date = inbox.date  {
            self.dateLabel.text = date.formatDate(dateFormat: "dd/MM/yyyy")
        }
        
    }
}
