//
//  DiveServiceCell.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class DiveServiceCell: UITableViewCell {
    @IBOutlet weak var serviceView: NServiceView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.backgroundView = nil
        
        DTMHelper.addShadow(self.serviceView)
    }
}
