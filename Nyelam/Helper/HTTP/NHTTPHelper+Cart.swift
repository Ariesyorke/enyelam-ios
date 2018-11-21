//
//  NHTTPHelper+Cart.swift
//  Nyelam
//
//  Created by Bobi on 11/8/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
extension NHTTPHelper {
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
            if let data = data, let json = data as? [String: Any] {
                let cartProducts = CartReturn(json: json)
                complete(NHTTPResponse(resultStatus: true, data: cartProducts, error: nil))
            }
        })
    }
    
    static func cartListRequest(complete: @escaping(NHTTPResponse<CartReturn>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_CART_LIST, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                let cartProducts = CartReturn(json: json)
                complete(NHTTPResponse(resultStatus: true, data: cartProducts, error: nil))
            }
        })
    }
}
