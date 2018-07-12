//
//  ReviewCell.swift
//  Nyelam
//
//  Created by Bobi on 6/25/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import Cosmos

class ReviewCell: NTableViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userCommentLabel: UILabel!
    @IBOutlet weak var dottedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dottedImageView.backgroundColor = UIColor(patternImage: UIImage(named: "ic_dotted_bar")!)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
