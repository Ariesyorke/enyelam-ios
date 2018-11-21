//
//  ProductGridView.swift
//  Nyelam
//
//  Created by Bobi on 11/7/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

class ProductGridView: UIControl {
    var contentView: UIView?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var normalPriceContainer: UIView!
    @IBOutlet weak var normalPriceLabel: UILabel!
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
        let nib = UINib(nibName: "ProductGridView", bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }

    func initData(product: NProduct) {
        self.productNameLabel.text = product.productName
        if product.normalPrice == product.specialPrice {
            self.normalPriceContainer.isHidden = true
        } else {
            self.normalPriceContainer.isHidden = false
        }
        self.normalPriceLabel.text = product.normalPrice.toCurrencyFormatString(currency: "Rp")
        self.specialPriceLabel.text = product.specialPrice.toCurrencyFormatString(currency: "Rp")
        if let imageUrl = product.featuredImage, let url = URL(string: imageUrl) {
            self.imageView.af_setImage(withURL: url, placeholderImage: UIImage(named: "image_default"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: true, completion: nil)
        }
    }
}
