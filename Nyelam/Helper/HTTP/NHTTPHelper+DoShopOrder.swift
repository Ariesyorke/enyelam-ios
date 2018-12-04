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
                                     complete: @escaping (NHTTPResponse<DoShopOrderReturn>) -> ()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_DO_SHOP_ORDER_LIST, parameters: ["page": page, "type": paymentType], headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var orderReturn = DoShopOrderReturn(json: json)
                complete(NHTTPResponse(resultStatus: true, data: orderReturn, error: nil))
            }

        })
    }
}

class DoShopOrderReturn: Parseable {
    var next: Int = -1
    var orders: [NOrder]?
    
    init(json: [String: Any]) {
        self.parse(json: json)
    }
    
    func parse(json: [String : Any]) {
        if let next = json["next"] as? Int {
            self.next = next
        } else if let next = json["next"] as? String {
            if next.isNumber {
                self.next = Int(next)!
            }
        }
        if let ordersArray = json["orders"] as? Array<[String: Any]>, !ordersArray.isEmpty {
            self.orders = []
            for orderJson in ordersArray {
                var order: NOrder? = nil
                if let id = orderJson["order_id"] as? String {
                    order = NOrder.getOrder(using: id)
                }
                if order == nil {
                    order = NOrder.init(entity: NSEntityDescription.entity(forEntityName: "NOrder", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                }
                order!.parse(json: orderJson)
                self.orders!.append(order!)
            }
        } else if let ordersArrayString = json["orders"] as? String {
            do {
                self.orders = []
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
                    self.orders!.append(order!)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        json["next"] = next
        if let orders = self.orders, !orders.isEmpty {
            var array: Array<[String: Any]> = []
            for order in orders {
                array.append(order.serialized())
            }
            json["orders"] = array
        }
        return json
    }
}
