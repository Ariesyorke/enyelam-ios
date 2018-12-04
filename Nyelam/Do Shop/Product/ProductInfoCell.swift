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
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var brandImageView: UIImageView!
    
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
    
    func initData(product: NProduct, qty: Int, controllerView: UIView) {
        var images: [String]? = nil
        for subview in self.featuredImageScroller.subviews {
            subview.removeFromSuperview()
        }
        if let imgs = product.images, !imgs.isEmpty {
            images = []
            images!.append(contentsOf: imgs)
        }
        
        var leftView: UIView? = nil
        if let images = images, !images.isEmpty {
            var i = 0
            for image in images {
                let view = self.createView(for: image, width: controllerView.frame.width, height: (controllerView.frame.width * 2 / 3),at: i)
                self.featuredImageScroller.addSubview(view)
                self.featuredImageScroller.addConstraints([NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.featuredImageScroller, attribute: .top, multiplier: 1, constant: 0),NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self.featuredImageScroller, attribute: .bottom, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self.featuredImageScroller, attribute: .centerY, multiplier: 1, constant: 0)])
                if leftView == nil {
                    self.featuredImageScroller.addConstraint(NSLayoutConstraint(item: self.featuredImageScroller, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
                } else {
                    self.featuredImageScroller.addConstraint(NSLayoutConstraint(item: leftView, attribute: .trailing, relatedBy: .equal, toItem: self.featuredImageScroller, attribute: .trailing, multiplier: 1, constant: 0))
                }
                if i >= images.count - 1 {
                    self.featuredImageScroller.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.featuredImageScroller, attribute: .trailing, multiplier: 1, constant: 0))
                }
                leftView = view
                i += 1
            }
        }
        
        self.productNameLabel.text = product.productName
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
    
    fileprivate func createView(for image: String, width: CGFloat, height: CGFloat, at index: Int) -> UIView {
        let control = UIControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addConstraints([NSLayoutConstraint(item: control, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width),
                                NSLayoutConstraint(item: control, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)])
        control.tag = index
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        control.addSubview(imageView)
        control.addConstraints([
                                NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: control, attribute: .leading, multiplier: 1, constant: 0),
                                NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: control, attribute: .trailing, multiplier: 1, constant: 0),
                                NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: control, attribute: .top, multiplier: 1, constant: 0),
                                NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: control, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        if let url = URL(string: image) {
            imageView.af_setImage(withURL: url)
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.image = UIImage(named: "image_default")
            imageView.contentMode = .scaleAspectFill
        }

        return control
    }
    
}
