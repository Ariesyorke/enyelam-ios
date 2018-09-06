//
//  NAdditionalView.swift
//  Nyelam
//
//  Created by Bobi on 5/3/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class NAdditionalView: UIView {
    var contentView: UIView?
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
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
        let nib = UINib(nibName: "NAdditionalView", bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }

    func initData(title: String, price: Double) {
        self.titleLabel.text = title
        self.priceLabel.text = "\(price.toCurrencyFormatString(currency: "Rp")),-"
    }
    
    func initData(title: String, price: Double, additional: String) {
        self.titleLabel.text = title
        self.priceLabel.text = "\(additional) \(price.toCurrencyFormatString(currency: "Rp")),-"
    }
}
