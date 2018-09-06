//
//  VoucherCell.swift
//  Nyelam
//
//  Created by Bobi on 9/4/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class VoucherCell: NTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var voucherTextField: UITextField!
    var onVoucherApplied: (String?)->() = {code in }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.voucherTextField.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func applyButtonAction(_ sender: Any) {
        print("VOUCHER APPLIED")
        self.onVoucherApplied(voucherTextField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
