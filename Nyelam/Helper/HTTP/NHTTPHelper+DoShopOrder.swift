//
//  NHTTPHelper+DoShopOrder.swift
//  Nyelam
//
//  Created by Bobi on 12/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

extension NHTTPHelper {
    static func httpDoShopOrderDetailRequest(orderId: String,
                                       complete: @escaping (NHTTPResponse<NOrder>) -> ()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_DO_SHOP_ORDER_DETAIL, parameters: ["order_id": orderId], headers: nil, complete: {status, data, error in
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
    static func httpOrderListRequest(paymentType: String,
                                     page: String,
                                     complete: @escaping (NHTTPResponse<[NOrder]>) -> ()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_DO_SHOP_ORDER_LIST, parameters: ["page": page, "payment_type": paymentType], headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var orders: [NOrder]? = nil
                if let ordersArray = json["address"] as? Array<[String: Any]>, !ordersArray.isEmpty {
                    orders = []
                    for orderJson in ordersArray {
                        var order: NOrder? = nil
                        if let id = orderJson["order_id"] as? String {
                            order = NOrder.getOrder(using: id)
                        }
                        if order == nil {
                            order = NOrder.init(entity: NSEntityDescription.entity(forEntityName: "NOrder", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                        }
                        order!.parse(json: orderJson)
                        orders!.append(order!)
                    }
                } else if let ordersArrayString = json["address"] as? String {
                    do {
                        orders = []
                        let data = ordersArrayString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let ordersArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        for orderJson in ordersArray {
                            var order: NOrder? = nil
                            if let id = orderJson["order_id"] as? String {
                                order = NOrder.getOrder(using: id)
                            }
                            if order == nil {
                                order = NOrder.init(entity: NSEntityDescription.entity(forEntityName: "NOrder", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                            }
                            order!.parse(json: orderJson)
                            orders!.append(order!)
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: orders, error: nil))
            }

        })
    }
}
