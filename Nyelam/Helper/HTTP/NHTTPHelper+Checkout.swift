//
//  NHTTPHelper+Checkout.swift
//  Nyelam
//
//  Created by Bobi on 11/8/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

extension NHTTPHelper {
    static func httpDoShopAddVoucherRequest(cartToken: String,
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
    static func httpDoShopDeliveryCostRequest(originType: String = "subdistrict",
                                              destinationType: String = "subdistrict",
                                              courier: String = "jne:tiki",
                                              weight: Int,
                                              originId: String,
                                              destinationId: String,
                                              complete: @escaping(NHTTPResponse<[Courier]>)->()) {
        self.basicRajaOngkirRequest(URLString: RAJA_ONGKIR_URL + API_PATH_RAJA_ONGKIR_DELIVERY_COST,
                                    method: .post,
                                    parameters: ["originType": originType,
                                                 "origin": originId,
                                                 "destinationType": destinationType,
                                                 "destination": destinationId,
                                                 "weight": String(weight),
                                                 "courier": courier], headers: nil, encoding: .httpBody, complete: {status, data, error in
                                                    if let error = error {
                                                        complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                                        return
                                                    }
                                                    if let data = data, let json = data as? [String: Any] {
                                                        var couriers: [Courier]? = nil
                                                        if let courierArray = json["results"] as? Array<[String: Any]>, !courierArray.isEmpty {
                                                            couriers = []
                                                            for courierJson in courierArray {
                                                                couriers!.append(Courier(json: courierJson))
                                                            }
                                                        }
                                                        complete(NHTTPResponse(resultStatus: true, data: couriers, error: nil))
                                                    }
                                                    
        })
        
    }
}
