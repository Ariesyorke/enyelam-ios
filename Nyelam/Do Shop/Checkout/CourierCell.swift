//
//  CourierCell.swift
//  Nyelam
//
//  Created by Bobi on 11/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class CourierCell: NTableViewCell {
    @IBOutlet weak var merchantTitleLabel: UILabel!
    @IBOutlet weak var productItemContainer: UIView!
    @IBOutlet weak var courierContainer: UIView!
    
    var row: Int = 0
    var onChangeCourier: (Int) -> () = {row in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func courierButtonAction(_ sender: Any) {
        self.onChangeCourier(row)
    }
    func initData(merchant: Merchant, courier: Courier?, courierType: CourierType?) {
        self.merchantTitleLabel.text = merchant.merchantName
        for subview in self.productItemContainer.subviews {
            subview.removeFromSuperview()
        }
        for subview in self.courierContainer.subviews {
            subview.removeFromSuperview()
        }
        if let products = merchant.products, !products.isEmpty {
            var topView: UIView? = nil
            var i = 0
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
                    self.productItemContainer.addConstraint(NSLayoutConstraint(item: topView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 8))
                }
                topView = view
                if i >= products.count - 1 {
                    self.productItemContainer.addConstraint(NSLayoutConstraint(item: self.productItemContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
                }
                i += 1
            }
        }
        if let courier = courier, let courierType = courierType {
            let view = self.createView(for: courier, courierType: courierType)
            self.courierContainer.addConstraints([
                NSLayoutConstraint(item: self.productItemContainer, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.productItemContainer, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.productItemContainer, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.productItemContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        }
    }
    
    fileprivate func createView(for product: CartProduct) -> NProductItemView {
        let view = NProductItemView()
        view.initData(product: product)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    fileprivate func createView(for courier: Courier, courierType: CourierType) -> NCourierItemView {
        let view = NCourierItemView()
        view.initData(courier: courier, courierType: courierType)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
