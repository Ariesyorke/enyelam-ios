//
//  NHTTPHelper+Checkout.swift
//  Nyelam
//
//  Created by Bobi on 11/8/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

extension NHTTPHelper {
    static func addVoucherRequest(cartToken: String,
                                  voucherCode: String,
                                  complete: @escaping (NHTTPResponse<CartReturn>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_DOSHOP_ADD_VOUCHER, parameters: ["cart_token": cartToken, "voucher_code": voucherCode], headers: nil, complete: {status, data, error in
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
