//
//  CourierCell.swift
//  Nyelam
//
//  Created by Bobi on 11/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class CourierCell: NTableViewCell {
    @IBOutlet weak var merchantTitleLabel: UILabel!
    @IBOutlet weak var productItemContainer: UIView!
    @IBOutlet weak var courierContainer: UIView!
    
    var row: Int = 0
    var onChangeCourier: (Int) -> () = {row in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func courierButtonAction(_ sender: Any) {
        self.onChangeCourier(row)
    }
    func initData(merchant: Merchant, courier: Courier, courierType: CourierType) {
        
    }
}
