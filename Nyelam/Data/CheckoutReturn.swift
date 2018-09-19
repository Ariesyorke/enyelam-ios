//
//  CheckoutReturn.swift
//  Nyelam
//
//  Created by Bobi on 8/24/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

class CheckoutReturn: Parseable {
    
    var checkoutToken: String?
    var shippingAddress: NShippingAddress?
    var cartProductReturn: CartProductReturn?
    
    func parse(json: [String : Any]) {
        
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        return json
    }
    
}
