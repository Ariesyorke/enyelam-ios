//
//  OrderInfoCell.swift
//  Nyelam
//
//  Created by Bobi on 12/2/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class OrderInfoCell: NTableViewCell {
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var productItemContainer: UIView!
    @IBOutlet weak var courierContainer: UIView!
    @IBOutlet weak var trackingNameLabel: UILabel!
    
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
        for subview in self.productItemContainer.subviews {
            subview.removeFromSuperview()
        }
        for subview in self.courierContainer.subviews {
            subview.removeFromSuperview()
        }
        if let products = merchant.products, !products.isEmpty {
            var i = 0
            var topView: UIView? = nil
            for product in products {
                let view = self.createView(for: product)
                self.productItemContainer.addSubview(view)
                self.productItemContainer.addConstraints([
                    NSLayoutConstraint(item: self.productItemContainer, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: self.productItemContainer, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
                    ])
                if topView == nil {
                    self.productItemContainer.addConstraint(NSLayoutConstraint(item: self.productItemContainer, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
                } else {
                    self.productItemContainer.addConstraint(NSLayoutConstraint(item: topView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: -8))
                }
                topView = view
                if i >= products.count - 1 {
                    self.productItemContainer.addConstraint(NSLayoutConstraint(item: self.productItemContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
                }
                i += 1
            }
        }
        if let deliveryService = merchant.deliveryService {
            let courierNameLabel = UILabel()
            courierNameLabel.font = UIFont(name: "FiraSans-Regular", size: 15)
            courierNameLabel.text = deliveryService.name
            courierNameLabel.translatesAutoresizingMaskIntoConstraints = false
            self.courierContainer.addSubview(courierNameLabel)
            self.courierContainer.addConstraints([
                NSLayoutConstraint(item: self.courierContainer, attribute: .leading, relatedBy: .equal, toItem: courierNameLabel, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.courierContainer, attribute: .trailing, relatedBy: .equal, toItem: courierNameLabel, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.courierContainer, attribute: .top, relatedBy: .equal, toItem: courierNameLabel, attribute: .top, multiplier: 1, constant: 0)])
            let courierPriceLabel = UILabel()
            courierPriceLabel.font = UIFont(name: "FiraSans-SemiBold", size: 15)
            courierPriceLabel.text = deliveryService.price.toCurrencyFormatString(currency: "Rp")
            courierPriceLabel.translatesAutoresizingMaskIntoConstraints = false
            self.courierContainer.addSubview(courierPriceLabel)
            self.courierContainer.addConstraints([
                NSLayoutConstraint(item: self.courierContainer, attribute: .leading, relatedBy: .equal, toItem: courierPriceLabel, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.courierContainer, attribute: .trailing, relatedBy: .equal, toItem: courierPriceLabel, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: courierPriceLabel, attribute: .top, relatedBy: .equal, toItem: courierNameLabel, attribute: .bottom, multiplier: 1, constant: 8),
                NSLayoutConstraint(item: self.courierContainer, attribute: .bottom, relatedBy: .equal, toItem: courierPriceLabel, attribute: .bottom, multiplier: 1, constant: 0)])
            if let trackingId = deliveryService.trackingId {
                self.trackingNameLabel.text = trackingId
            }
            return
        }
        self.trackingNameLabel.text = "-"
    }
    
    fileprivate func createView(for product: CartProduct) -> NProductItemView {
        let view = NProductItemView()
        view.initData(product: product)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    
}
