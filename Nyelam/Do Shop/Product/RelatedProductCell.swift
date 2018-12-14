//
//  RelatedProductCell.swift
//  Nyelam
//
//  Created by Bobi on 11/19/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class RelatedProductCell: NTableViewCell {
    @IBOutlet weak var relatedProductContainer: UIView!
    var products: [NProduct] = []
    var onOpenProductDetail: (NProduct) -> () = {product in
        
    }
    var onSeeAllProduct: () -> () = {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func seeAllProductButtonAction(_ sender: Any) {
        self.onSeeAllProduct()
    }
    
    func initData(products: [NProduct]) {
        self.products = products
        for subview in self.relatedProductContainer.subviews {
            subview.removeFromSuperview()
        }
        self.relatedProductContainer.translatesAutoresizingMaskIntoConstraints = false
        var i = 0
        var leftView: UIView? = nil
        
        for product in products {
            let view = self.createView(for: product)
            view.control.tag = i
            view.control.addTarget(self, action: #selector(productButtonAction(_:)), for: .touchUpInside)
            self.relatedProductContainer.addSubview(view)
            self.relatedProductContainer.addConstraints([
                NSLayoutConstraint(item: self.relatedProductContainer, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.relatedProductContainer, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0),
                ])
            if leftView == nil {
                self.relatedProductContainer.addConstraint(NSLayoutConstraint(item: self.relatedProductContainer, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
            } else {
                self.relatedProductContainer.addConstraint(NSLayoutConstraint(item: leftView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 8))
            }
            leftView = view
            if i >= products.count - 1 && products.count > 1 {
                self.relatedProductContainer.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.relatedProductContainer, attribute: .trailing, multiplier: 1, constant: 0))
            }
            i+=1
        }
    }
    
    fileprivate func createView(for product: NProduct) -> ProductGridView {
        let categoryLabelH = CGFloat(14)
        let nameLabelH = CGFloat(16)
        let codeLabelH = CGFloat(21)
        let priceLabelH = CGFloat(16)
        let contentH = categoryLabelH + nameLabelH + codeLabelH + priceLabelH
        let screenWidth: CGFloat = CGFloat(Float(UIScreen.main.bounds.size.width))
        let columnCount = 2
        let columnWidth: CGFloat = (screenWidth  - 40) / CGFloat(columnCount)
        let imageH: CGFloat = columnWidth - 32

        let view = ProductGridView()
        view.initData(product: product)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.addConstraints([NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: columnWidth), NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageH + contentH + (40))])
        
        return view
    }
    
    @objc func productButtonAction(_ sender: UIControl) {
        self.onOpenProductDetail(self.products[sender.tag])
    }
}
