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
    
    func initData(cart: Cart, merchants: [Merchant], voucher: Voucher?, additionals: [Additional]?) {
        for subview in self.containerView.subviews {
            subview.removeFromSuperview()
        }
        
        var topView: UIView?
        for merchant in merchants {
            if let products = merchant.products, !products.isEmpty {
                for product in products {
                    let view = NAdditionalView()
                    view.translatesAutoresizingMaskIntoConstraints = false
                    self.containerView.addSubview(view)
                    view.initData(title: "\(product.productName!) \(String(product.qty))x", price: product.specialPrice)
                    self.containerView.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.containerView, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.containerView, attribute: .trailing, multiplier: 1, constant: 0)])
                    if topView == nil {
                        self.containerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1, constant: 0))
                    } else {
                        self.containerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 4))
                    }
                    topView = view
                }
            }
            if let courier = merchant.deliveryService {
                let view = NAdditionalView()
                view.translatesAutoresizingMaskIntoConstraints = false
                self.containerView.addSubview(view)
                view.initData(title: "\(courier.name!)", price: courier.price)
                self.containerView.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.containerView, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.containerView, attribute: .trailing, multiplier: 1, constant: 0)])
                if topView == nil {
                    self.containerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1, constant: 0))
                } else {
                    self.containerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 4))
                }
                topView = view
            }
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
    }
    
    fileprivate func createView(for product: CartProduct) -> NProductItemView {
        let view = NProductItemView()
        view.initData(product: product)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
}
