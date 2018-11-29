//
//  NCourierItemView.swift
//  Nyelam
//
//  Created by Bobi on 11/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

class NCourierItemView: UIView {
    var contentView: UIView?

    @IBOutlet weak var courierNameLabel: UILabel!
    @IBOutlet weak var courierTypeLabel: UILabel!
    @IBOutlet weak var courierPriceLabel: UILabel!
    
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
        let nib = UINib(nibName: "NCourierItemView", bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    func initData(courier: Courier, courierType: CourierType) {
        self.courierNameLabel.text = courier.name
        self.courierTypeLabel.text = courierType.service
        if let costs = courierType.costs, !costs.isEmpty {
            self.courierPriceLabel.text = Double(costs[0].value).toCurrencyFormatString(currency: "Rp")
        }
    }
}
