//
//  CheckoutSummaryCell.swift
//  Nyelam
//
//  Created by Bobi on 11/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import DLRadioButton

class CheckoutSummaryCell: NTableViewCell {
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var checkButton: DLRadioButton!
    var checked: Bool = false
    var onCheckedClicked: (Bool) -> () = {checked in }
    var onPayButtonClicked: (UIView) -> () = {view in}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func checkButtonAction(_ sender: Any) {
        if !self.checked {
            self.checked = true
        } else {
            self.checked = false
        }
        self.checkButton.isSelected = self.checked
        self.onCheckedClicked(self.checked)
    }
    
    @IBAction func payButtonAction(_ sender: UIButton) {
        self.onPayButtonClicked(sender)
    }
    
    func initData(merchants: [Merchant], voucher: Voucher?, couriers: [Courier]?, courierTypes: [CourierType]?, additionals: [Additional]?) {
        for subview in self.detailContainerView.subviews {
            subview.removeFromSuperview()
        }
        var grandTotal: Double = 0.0
        var topView: UIView?
        for merchant in merchants {
            if let products = merchant.products, !products.isEmpty {
                for product in products {
                    grandTotal += product.specialPrice
                }
            }
        }
        
        if grandTotal > 0.0 {
            let view = NAdditionalView()
            view.translatesAutoresizingMaskIntoConstraints = false
            self.detailContainerView.addSubview(view)
            view.initData(title: "Total", price: grandTotal)
            self.detailContainerView.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.detailContainerView, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.detailContainerView, attribute: .trailing, multiplier: 1, constant: 0)])
            if topView == nil {
                self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.detailContainerView, attribute: .top, multiplier: 1, constant: 0))
            } else {
                self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 4))
            }
            topView = view
        }

        if let couriers = couriers, let courierTypes = courierTypes {
            var i = 0
            var totalPrice: Double = 0.0
            
            for courier in couriers {
                if let code = courier.code, !code.isEmpty {
                    var price: Double = 0.0
                    let courierType = courierTypes[i]
                    if let costs = courierType.costs, !costs.isEmpty {
                        price = Double(costs[0].value)
                    }
                    totalPrice += price
                }
                i += 1
            }
            if totalPrice > 0.0 {
                grandTotal += totalPrice
                let view = NAdditionalView()
                view.translatesAutoresizingMaskIntoConstraints = false
                self.detailContainerView.addSubview(view)
                view.initData(title: "Shipping Fee", price: totalPrice)
                self.detailContainerView.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.detailContainerView, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.detailContainerView, attribute: .trailing, multiplier: 1, constant: 0)])
                if topView == nil {
                    self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.detailContainerView, attribute: .top, multiplier: 1, constant: 0))
                } else {
                    self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 4))
                }
                topView = view
            }
        }
        
        if let additionals = additionals, !additionals.isEmpty {
            for additional in additionals {
                let view = NAdditionalView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.initData(title: additional.title!, price: additional.value)
                grandTotal += additional.value
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
            grandTotal -= voucher.value
            self.detailContainerView.addSubview(view)
            self.detailContainerView.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.detailContainerView, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.detailContainerView, attribute: .trailing, multiplier: 1, constant: 0)])
            if topView == nil {
                self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.detailContainerView, attribute: .top, multiplier: 1, constant: 0))
            } else {
                self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 4))
            }
            topView = view
        }
        let view = NAdditionalView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.detailContainerView.addSubview(view)
        view.initData(title: "Grand Total", price: grandTotal)
        self.detailContainerView.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.detailContainerView, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.detailContainerView, attribute: .trailing, multiplier: 1, constant: 0)])
        if topView == nil {
            self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.detailContainerView, attribute: .top, multiplier: 1, constant: 0))
        } else {
            self.detailContainerView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 4))
        }
        topView = view
        if let topView = topView {
            self.detailContainerView.addConstraint(NSLayoutConstraint(item: topView, attribute: .bottom, relatedBy: .equal, toItem: self.detailContainerView, attribute: .bottom, multiplier: 1, constant: 0))
        }
    }
}
