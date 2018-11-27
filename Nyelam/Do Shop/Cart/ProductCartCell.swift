//
//  ProductCartCell.swift
//  Nyelam
//
//  Created by Bobi on 11/22/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class ProductCartCell: NTableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var quantityButton: UIButton!
    @IBOutlet weak var specialPriceLabel: UILabel!
    
    var onChangeQuantity: (Int) -> () = {qty in }
    var onDeleteButton: (String) -> () = {cartId in }
    fileprivate var quantity: Int = 1
    fileprivate var productCartId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.quantityButton.layer.borderColor = UIColor.lightGray.cgColor
        self.quantityButton.layer.borderWidth = 1
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func quantityButtonAction(_ sender: Any) {
        self.onChangeQuantity(self.quantity)
    }
    
    @IBAction func trashButtonAction(_ sender: Any) {
        self.onDeleteButton(self.productCartId!)
    }
    
    func initData(product: CartProduct) {
        self.productCartId = product.productCartId!
        self.quantity = product.qty
        if let featuredImage = product.featuredImage, let url = URL(string: featuredImage) {
            self.productImageView.af_setImage(withURL: url)
            self.productImageView.contentMode = .scaleAspectFit
        } else {
            self.productImageView.image = UIImage(named: "image_default")
            self.productImageView.contentMode = .scaleAspectFill
        }
        self.productNameLabel.text = product.productName
        self.quantityButton.setTitle(String(product.qty), for: .normal)
        self.specialPriceLabel.text = product.specialPrice.toCurrencyFormatString(currency: "Rp")
    }
}
