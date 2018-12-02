//
//  NHTTPHelper+Checkout.swift
//  Nyelam
//
//  Created by Bobi on 11/8/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

extension NHTTPHelper {
    static func httpChangePaymentMethodFee(paymentMethodId: String,
                                           orderId: String,
                                           voucherCode: String?,
                                           complete: @escaping(NHTTPResponse<CartReturn>) -> ()) {
        var param: [String: Any] = ["payment_method_id": paymentMethodId, "cart_token": orderId]
        if let voucherCode = voucherCode {
            param["voucher_code"] = voucherCode
        }
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_DO_SHOP_PAYMENT_METHOD_FEE, parameters: param, headers: nil, complete: {status, data, error in
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
    
    static func httpDoShopResubmitOrder(paymentMethodId: String,
                                  orderId: String,
                                  complete: @escaping (NHTTPResponse<NOrder>) -> ()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_DO_SHOP_RESUBMIT_ORDER, parameters: ["order_id": orderId, "payment_method_id": paymentMethodId], headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var order: NOrder? = nil
                if let orderJson = json["order"] as? [String: Any] {
                    if let orderId = orderJson["order_id"] as? String {
                        order = NOrder.getOrder(using: orderId)
                    }
                    if order == nil {
                        order = NSEntityDescription.insertNewObject(forEntityName: "NOrder", into: AppDelegate.sharedManagedContext) as! NOrder
                    }
                    order!.parse(json: orderJson)
                } else if let orderString = json["order"] as? String {
                    do {
                        let data = orderString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let orderJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        if let orderId = orderJson["order_id"] as? String {
                            order = NOrder.getOrder(using: orderId)
                        }
                        if order == nil {
                            order = NSEntityDescription.insertNewObject(forEntityName: "NOrder", into: AppDelegate.sharedManagedContext) as! NOrder
                        }
                        order!.parse(json: orderJson)
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: order, error: nil))
            }
        })
    }
    static func httpDoShopSubmitOrderRequest(paymentMethodId: String,
                                       cartToken: String,
                                       billingAddressId: String,
                                       shippingAddressId: String,
                                       deliveryServiceMapping: [String: String],
                                       voucherCode: String?,
                                       complete: @escaping (NHTTPResponse<NOrder>) -> ()) {
        var param: [String: Any] = ["payment_method_id": paymentMethodId,
                                    "cart_token": cartToken,
                                    "billing_address_id": billingAddressId,
                                    "shipping_address_id": shippingAddressId]
        for (key, value) in deliveryServiceMapping {
            param[key] = value
        }
        if let voucherCode = voucherCode {
            param["voucher_code"] = voucherCode
        }
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_DO_SHOP_SUBMIT_ORDER, parameters: param, headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var order: NOrder? = nil
                if let orderJson = json["order"] as? [String: Any] {
                    if let orderId = orderJson["order_id"] as? String {
                        order = NOrder.getOrder(using: orderId)
                    }
                    if order == nil {
                        order = NSEntityDescription.insertNewObject(forEntityName: "NOrder", into: AppDelegate.sharedManagedContext) as! NOrder
                    }
                    order!.parse(json: orderJson)
                } else if let orderString = json["order"] as? String {
                    do {
                        let data = orderString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let orderJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        if let orderId = orderJson["order_id"] as? String {
                            order = NOrder.getOrder(using: orderId)
                        }
                        if order == nil {
                            order = NSEntityDescription.insertNewObject(forEntityName: "NOrder", into: AppDelegate.sharedManagedContext) as! NOrder
                        }
                        order!.parse(json: orderJson)
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: order, error: nil))
            }
        })
    }
    
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
