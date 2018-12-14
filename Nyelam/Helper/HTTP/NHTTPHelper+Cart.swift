//
//  NHTTPHelper+Cart.swift
//  Nyelam
//
//  Created by Bobi on 11/8/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
extension NHTTPHelper {
    static func httpDeleteProductCart(productCartId: [String],
                                      complete: @escaping (NHTTPResponse<CartReturn>) -> ()) {
        let parameters: [String: Any] = ["product_cart_id": productCartId]
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_REMOVE_PRODUCT_CART , parameters: parameters, headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any], let _ = json["cart"] as? [String: Any] {
                let cartReturns = CartReturn(json: json)
                complete(NHTTPResponse(resultStatus: true, data: cartReturns, error: nil))
            } else {
                complete(NHTTPResponse(resultStatus: true, data: nil, error: nil))
            }
        })
    }
    static func httpChangeCartQuantityRequest(productCartId: String,
                                              qty: String,
                                              complete: @escaping (NHTTPResponse<CartReturn>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_DO_SHOP_CHANGE_QUANTITY, parameters: ["product_cart_id": productCartId, "qty": qty], headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any], let _ = json["cart"] {
                let cartReturns = CartReturn(json: json)
                complete(NHTTPResponse(resultStatus: true, data: cartReturns, error: nil))
            } else {
                complete(NHTTPResponse(resultStatus: true, data: nil, error: nil))
            }
        })
    }
    static func httpAddToCartRequest(productId: String,
                                     qty: Int,
                                    variations: [String]?,
                                    complete: @escaping (NHTTPResponse<CartReturn>)->()) {
        var parameters: [String: Any] = ["product_id": productId, "qty": String(qty)]
        if let variations = variations, !variations.isEmpty {
            parameters["variations"] = variations
        }
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_ADD_TO_CART, parameters: parameters, headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any], let _ = json["cart"] {
                let cartReturns = CartReturn(json: json)
                complete(NHTTPResponse(resultStatus: true, data: cartReturns, error: nil))
            } else {
                complete(NHTTPResponse(resultStatus: true, data: nil, error: nil))
            }
        })
    }
    
    static func httpCartListRequest(complete: @escaping(NHTTPResponse<CartReturn>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_CART_LIST, complete: {status, data, error in
            
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any], let _ = json["cart"] as? [String: Any] {
                let cartReturns = CartReturn(json: json)
                complete(NHTTPResponse(resultStatus: true, data: cartReturns, error: nil))
            } else {
                complete(NHTTPResponse(resultStatus: true, data: nil, error: nil))
            }
        })
    }
}
