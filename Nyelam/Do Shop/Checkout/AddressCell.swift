//
//  AddressCell.swift
//  Nyelam
//
//  Created by Bobi on 11/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class AddressCell: NTableViewCell {
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initData(address: NAddress) {
        self.fullnameLabel.text = address.fullname
        self.addressLabel.text = NHelper.formatAddress(address: address)
    }
    
}
