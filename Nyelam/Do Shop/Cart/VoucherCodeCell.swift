//
//  VoucherCodeCell.swift
//  Nyelam
//
//  Created by Bobi on 11/22/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class VoucherCodeCell: NTableViewCell {
    @IBOutlet weak var voucherCodeTextField: UITextField!
    var onApplyVoucherCode: (String) -> () = {voucherCode in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initData(voucher: Voucher) {
        self.voucherCodeTextField.text = voucher.code
    }
    
    @IBAction func applyButtonAction(_ sender: Any) {
        self.onApplyVoucherCode(voucherCodeTextField.text!)
    }
    
}
