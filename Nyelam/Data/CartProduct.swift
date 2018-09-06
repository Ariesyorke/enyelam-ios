//
//  CartProduct.swift
//  Nyelam
//
//  Created by Bobi on 8/24/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class CartProduct: Parseable {
    private let KEY_PRODUCT_CART_ID = "product_cart_id"
    private let KEY_PRODUCT_NAME = "product_name"
    private let KEY_FEATURED_IMAGE = "featured_image"
    private let KEY_QTY = "qty"
    private let KEY_SPECIAL_PRICE = "special_price"
    
    var productCartId: String?
    var productName: String?
    var featuredImage: String?
    var qty: Int = 0
    var specialPrice: Double = 0
    
    func parse(json: [String : Any]) {
        self.productCartId = json[KEY_PRODUCT_CART_ID] as? String
        self.productName = json[KEY_PRODUCT_NAME] as? String
        self.featuredImage = json[KEY_FEATURED_IMAGE] as? String
        if let qty = json[KEY_QTY] as? Int {
            self.qty = qty
        } else if let qty = json[KEY_QTY] as? String {
            if qty.isNumber {
                self.qty = Int(qty)!
            }
        }
        if let specialPrice = json[KEY_SPECIAL_PRICE] as? Double {
            self.specialPrice = specialPrice
        } else if let specialPrice = json[KEY_SPECIAL_PRICE] as? String {
            if specialPrice.isNumber {
                self.specialPrice = Double(specialPrice)!
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let productCartId = self.productCartId {
            json[KEY_PRODUCT_CART_ID] = productCartId
        }
        if let productName = self.productName {
            json[KEY_PRODUCT_NAME] = productName
        }
        if let featuredImage = self.featuredImage {
            json[KEY_FEATURED_IMAGE] = featuredImage
        }
        json[KEY_QTY] = self.qty
        json[KEY_SPECIAL_PRICE] = self.specialPrice
        return json
    }
}
