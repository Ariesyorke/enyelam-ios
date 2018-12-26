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
    @IBOutlet weak var editButton: UIButton!
    
    var address: NAddress?
    var onAddressClicked: (NAddress) -> () = {address in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initData(address: NAddress) {
        self.address = address
        self.fullnameLabel.text = address.fullname
        self.addressLabel.text = NHelper.formatAddress(address: address)
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        self.onAddressClicked(self.address!)
    }
    
    
}
