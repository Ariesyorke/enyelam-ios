//
//  ProductInfoCell.swift
//  Nyelam
//
//  Created by Bobi on 11/19/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class ProductInfoCell: NTableViewCell, UITextFieldDelegate, UIScrollViewDelegate {
    @IBOutlet weak var featuredImageScroller: UIScrollView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var merchantImageView: UIImageView!
    @IBOutlet weak var normalPriceContainer: UIView!
    @IBOutlet weak var normalPriceLabel: UILabel!
    @IBOutlet weak var specialPriceLabel: UILabel!
    @IBOutlet weak var variationContainer: UIView!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var featuredImageView: UIImageView!
    
    var onAddToCart: () -> () = {}
    var onVariationTriggered: (Variation, NVariationView) -> () = {variation, view in }
    var onUpdateQuantity: (Int) -> () = {qty in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.quantityTextField.delegate = self
        self.quantityTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addToCartButtonAction(_ sender: Any) {
        self.onAddToCart()
    }
    
    func initData(product: NProduct, qty: Int) {
        if let featuredImage = product.featuredImage, let url = URL(string: featuredImage) {
            self.featuredImageView.af_setImage(withURL: url)
            self.featuredImageView.contentMode = .scaleAspectFit
        } else {
            self.featuredImageView.image = UIImage(named: "image_default")
            self.featuredImageView.contentMode = .scaleAspectFill
        }
        self.productNameLabel.text = product.productName
        if let merchant = product.merchant {
            self.merchantNameLabel.text = merchant.merchantName
            if let merchantUrl = merchant.merchantLogo, let url = URL(string: merchantUrl) {
                self.merchantImageView.af_setImage(withURL: url, placeholderImage: UIImage(named: "image_default"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: true, completion: nil)
            }
        }
        if product.normalPrice == product.specialPrice {
            self.normalPriceContainer.isHidden = true
        } else {
            self.normalPriceContainer.isHidden = false
            self.normalPriceLabel.text = product.normalPrice.toCurrencyFormatString(currency: "Rp")
        }
        self.specialPriceLabel.text = product.specialPrice.toCurrencyFormatString(currency: "Rp")
        self.quantityTextField.text = String(qty)
        for subview in self.variationContainer.subviews {
            subview.removeFromSuperview()
        }
        if let descript = product.productDescription, !descript.isEmpty {
            self.descriptionLabel.attributedText = NSAttributedString.htmlAttriButedText(str: descript, fontName: "FiraSans-Regular", size: 14, color: UIColor.darkGray
            )
        } else {
            self.descriptionLabel.text = "-"
        }
        if let variations = product.variations, !variations.isEmpty {
            var i = 0
            var leftView: UIView? = nil
            for variation in variations {
                let view = self.createView(for: variation)
                self.variationContainer.addSubview(view)
                self.variationContainer.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.variationContainer, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.variationContainer, attribute: .trailing, multiplier: 1, constant: 0)])
                if leftView == nil {
                    self.variationContainer.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.variationContainer, attribute: .top, multiplier: 1, constant: 8))
                } else {
                    self.variationContainer.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: leftView, attribute: .bottom, multiplier: 1, constant: 8))
                }
                if i >= variations.count - 1 {
                    self.variationContainer.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self.variationContainer, attribute: .bottom, multiplier: 1, constant: -16))
                }
                view.tag = i
                view.variationTitleLabel.text = variation.key
                view.onVariationClicked = {variationView, varian in
                    self.onVariationTriggered(varian, variationView)
                }
                leftView = view
                i+=1
            }
        }
    }
    
    func createView(for variation: Variation) -> NVariationView {
        let view = NVariationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.initData(variation: variation)
        return view
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.isEmpty {
            textField.text = "1"
        }
        if textField.text!.isNumber {
            self.onUpdateQuantity(Int(textField.text!)!)
        }
    }
    
    
    
}
