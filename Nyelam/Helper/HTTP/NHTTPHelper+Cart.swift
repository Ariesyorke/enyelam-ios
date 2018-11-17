//
//  NHTTPHelper+Cart.swift
//  Nyelam
//
//  Created by Bobi on 11/8/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
extension NHTTPHelper {
    static func addToCartRequest(productId: String,
                          variations: [String]?,
                          complete: @escaping (NHTTPResponse<CartReturn>)->()) {
        var parameters: [String: Any] = ["product_id": productId]
        if let variations = variations, !variations.isEmpty {
            parameters["variation"] = variations
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
