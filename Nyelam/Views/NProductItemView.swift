//
//  NProductItemView.swift
//  Nyelam
//
//  Created by Bobi on 11/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

class NProductItemView: UIView {
    var contentView: UIView?
    @IBOutlet weak var productItemImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var quantityButton: UIButton!
    @IBOutlet weak var specialPriceLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        xibSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NProductItemView", bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    func initData(product: CartProduct) {
        if let featuredImage = product.featuredImage, let url = URL(string: featuredImage) {
            self.productItemImageView.af_setImage(withURL: url)
            self.productItemImageView.contentMode = .scaleAspectFit
        } else {
            self.productItemImageView.image = UIImage(named: "image_default")
            self.productItemImageView.contentMode = .scaleAspectFill
        }
        self.productNameLabel.text = product.productName
        self.quantityButton.setTitle(String(product.qty), for: .normal)
        self.specialPriceLabel.text = product.specialPrice.toCurrencyFormatString(currency: "Rp")
    }
}
