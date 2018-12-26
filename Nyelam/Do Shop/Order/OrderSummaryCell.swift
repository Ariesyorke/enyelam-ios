//
//  OrderSummaryCell.swift
//  Nyelam
//
//  Created by Bobi on 12/2/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class OrderSummaryCell: NTableViewCell {
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initData(cart: Cart, merchants: [Merchant], voucher: Voucher?, additionals: [Additional]?, date: Date?) {
        for subview in self.containerView.subviews {
            subview.removeFromSuperview()
        }
        
        var topView: UIView?
        var totalProductPrice: Double = 0.0
        var totalShippingPrice: Double = 0.0
        
        for merchant in merchants {
            if let products = merchant.products, !products.isEmpty {
                for product in products {
                    totalProductPrice += product.specialPrice
                }
            }
            if let courier = merchant.deliveryService {
                totalShippingPrice += courier.price
            }
        }
        if totalProductPrice > 0.0 {
            let view = NAdditionalView()
            view.translatesAutoresizingMaskIntoConstraints = false
            self.containerView.addSubview(view)
            view.initData(title: "Total", price: totalProductPrice)
            self.containerView.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.containerView, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.containerView, attribute: .trailing, multiplier: 1, constant: 0)])
            if topView == nil {
                self.containerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1, constant: 0))
            } else {
                self.containerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 4))
            }
            topView = view
        }
        if totalShippingPrice > 0.0 {
            let view = NAdditionalView()
            view.translatesAutoresizingMaskIntoConstraints = false
            self.containerView.addSubview(view)
            view.initData(title: "Shipping Fee", price: totalShippingPrice)
            self.containerView.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.containerView, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.containerView, attribute: .trailing, multiplier: 1, constant: 0)])
            if topView == nil {
                self.containerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1, constant: 0))
            } else {
                self.containerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 4))
            }
            topView = view
        }
        if let additionals = additionals, !additionals.isEmpty {
            for additional in additionals {
                let view = NAdditionalView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.initData(title: additional.title!, price: additional.value)
                self.containerView.addSubview(view)
                self.containerView.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.containerView, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.containerView, attribute: .trailing, multiplier: 1, constant: 0)])
                if topView == nil {
                    self.containerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1, constant: 0))
                } else {
                    self.containerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 4))
                }
                topView = view
            }
        }
        if let voucher = voucher {
            let view = NAdditionalView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.initData(title: voucher.code!, price: voucher.value, additional: "-")
            self.containerView.addSubview(view)
            self.containerView.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.containerView, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.containerView, attribute: .trailing, multiplier: 1, constant: 0)])
            if topView == nil {
                self.containerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1, constant: 0))
            } else {
                self.containerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 4))
            }
            topView = view
        }
        
        let view = NAdditionalView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.initData(title: "Total", price: cart.total)
        self.containerView.addSubview(view)
        self.containerView.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.containerView, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.containerView, attribute: .trailing, multiplier: 1, constant: 0)])
        if topView == nil {
            self.containerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1, constant: 0))
        } else {
            self.containerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 4))
        }
        topView = view

        if let topView = topView {
            self.containerView.addConstraint(NSLayoutConstraint(item: topView, attribute: .bottom, relatedBy: .equal, toItem: self.containerView, attribute: .bottom, multiplier: 1, constant: 0))
        }
//        
//        if let date = date {
//            self.orderDateLabel.text = date.formatDate(dateFormat: "dd MMM yyy")
//        }
    }
    
    fileprivate func createView(for product: CartProduct) -> NProductItemView {
        let view = NProductItemView()
        view.initData(product: product)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
}
