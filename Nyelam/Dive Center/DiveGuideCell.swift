//
//  DiveGuideCell.swift
//  Nyelam
//
//  Created by Bobi on 7/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class DiveGuideCell: NTableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var diveGuideNameLabel: UILabel!
    
    @IBOutlet weak var diveGuideLicenseLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
