//
//  OrderCell.swift
//  Nyelam
//
//  Created by Bobi on 12/2/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initData(merchant: Merchant) {
        self.merchantNameLabel.text = merchant.merchantName
        if let products = merchant.products, !products.isEmpty {
            self.productNameLabel.text = products[0].productName
            if let featuredImage = products[0].featuredImage, let url = URL(string: featuredImage) {
                self.productImageView.af_setImage(withURL: url)
                self.productImageView.contentMode = .scaleAspectFit
            } else {
                self.productImageView.image = UIImage(named: "image_default")
                self.productImageView.contentMode = .scaleAspectFill
            }
        }
    }
}
