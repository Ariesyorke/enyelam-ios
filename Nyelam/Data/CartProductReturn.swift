//
//  CartProductReturn.swift
//  Nyelam
//
//  Created by Bobi on 8/24/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class CartProductReturn: Parseable {
    private let KEY_PRODUCTS = "products"
    private let KEY_SUB_TOTAL = "sub_total"
    private let KEY_ADDITIONALS = "additionals"
    private let KEY_VOUCHER = "voucher"
    private let KEY_TOTAL = "total"
    
    var products: [CartProduct]?
    var additionals: [Additional]?
    var voucher: Voucher?
    var subtotal: Double = 0
    var total: Double = 0
    
    func parse(json: [String : Any]) {
        
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        
        return json
    }
}
