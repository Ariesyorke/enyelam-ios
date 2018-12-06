//
//  CheckoutSummaryCell.swift
//  Nyelam
//
//  Created by Bobi on 11/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class CheckoutSummaryCell: NTableViewCell {
    @IBOutlet weak var detailContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initData(merchants: [Merchant], voucher: Voucher?, couriers: [Courier]?, courierTypes: [CourierType]?, additionals: [Additional]?) {
        for subview in self.detailContainerView.subviews {
            subview.removeFromSuperview()
        }
        
        var topView: UIView?
        for merchant in merchants {
            if let products = merchant.products, !products.isEmpty {
                for product in products {
                    let view = NAdditionalView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    self.detailContainerView.addSubview(view)
                    view.initData(title: "\(product.productName!) \(String(product.qty))x", price: product.specialPrice)
                    self.detailContainerView.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.detailContainerView, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.detailContainerView, attribute: .trailing, multiplier: 1, constant: 0)])
                    if topView == nil {
                        self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.detailContainerView, attribute: .top, multiplier: 1, constant: 0))
                    } else {
                        self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 4))
                    }
                    topView = view
                }
            }
        }
        if let couriers = couriers, let courierTypes = courierTypes {
            var i = 0
            for courier in couriers {
                if let code = courier.code, !code.isEmpty {
                    let view = NAdditionalView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    self.detailContainerView.addSubview(view)
                    var detailName = courier.code!.uppercased()
                    var price: Double = 0.0
                    let courierType = courierTypes[i]
                    detailName = "\(detailName) - \(courierType.service!)"
                    if let costs = courierType.costs, !costs.isEmpty {
                        price = Double(costs[0].value)
                    }
                    view.initData(title: detailName, price: price)
                    self.detailContainerView.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.detailContainerView, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.detailContainerView, attribute: .trailing, multiplier: 1, constant: 0)])
                    if topView == nil {
                        self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.detailContainerView, attribute: .top, multiplier: 1, constant: 0))
                    } else {
                        self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 4))
                    }
                    topView = view
                }
                i += 1
            }
        }
        
        if let additionals = additionals, !additionals.isEmpty {
            for additional in additionals {
                let view = NAdditionalView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.initData(title: additional.title!, price: additional.value)
                self.detailContainerView.addSubview(view)
                self.detailContainerView.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.detailContainerView, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.detailContainerView, attribute: .trailing, multiplier: 1, constant: 0)])
                if topView == nil {
                    self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.detailContainerView, attribute: .top, multiplier: 1, constant: 0))
                } else {
                    self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 4))
                }
                topView = view
            }
        }
        if let voucher = voucher {
            let view = NAdditionalView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.initData(title: voucher.code!, price: voucher.value, additional: "-")
            self.detailContainerView.addSubview(view)
            self.detailContainerView.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.detailContainerView, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.detailContainerView, attribute: .trailing, multiplier: 1, constant: 0)])
            if topView == nil {
                self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.detailContainerView, attribute: .top, multiplier: 1, constant: 0))
            } else {
                self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 4))
            }
            topView = view
        }
        if let topView = topView {
            self.detailContainerView.addConstraint(NSLayoutConstraint(item: topView, attribute: .bottom, relatedBy: .equal, toItem: self.detailContainerView, attribute: .bottom, multiplier: 1, constant: 0))
        }
    }
}
