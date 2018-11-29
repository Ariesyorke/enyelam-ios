//
//  CheckoutProgressCell.swift
//  Nyelam
//
//  Created by Bobi on 11/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class CheckoutProgressCell: NTableViewCell {
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.leftView.circledView()
        self.middleView.circledView()
        self.rightView.circledView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
