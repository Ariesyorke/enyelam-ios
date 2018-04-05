//
//  NOrder+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NOrder)
public class NOrder: NSManagedObject {
    private let KEY_ORDER_ID = "order_id"
    private let KEY_STATUS = "status"
    private let KEY_SCHEDULE = "schedule"
    private let KEY_CART = "cart"
    
    func parse(json: [String : Any]) {
        self.orderId = json[KEY_ORDER_ID] as? String
        self.status = json[KEY_STATUS] as? String
        if let schedule = json[KEY_SCHEDULE] as? Double {
            self.schedule = schedule
        } else if let schedule = json[KEY_SCHEDULE] as? String {
            if schedule.isNumber {
                self.schedule = Double(schedule)!
            }
        }
        if let cartJson = json[KEY_CART] as? [String: Any] {
            self.cart = Cart(json: json)
        } else if let cartString = json[KEY_CART] as? String {
            do {
                let data = cartString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let cartJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.cart = Cart(json: json)
            } catch {
                print(error)
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let orderId = self.orderId {
            json[KEY_ORDER_ID] = self.orderId
        }
        if let status = self.status {
            json[KEY_STATUS] = status
        }
        json[KEY_SCHEDULE] = self.schedule
        if let cart = self.cart {
            json[KEY_CART] = cart.serialized()
        }
        return json
    }
    
    static func getDiveService(using id: String) -> NDiveService? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NDiveService")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let diveServices = try managedContext.fetch(fetchRequest) as? [NDiveService]
            if let diveServices = diveServices, !diveServices.isEmpty {
                return diveServices.first
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getOrder(using orderId: String) -> NOrder? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NOrder")
        fetchRequest.predicate = NSPredicate(format: "orderId == %@", orderId)
        do {
            let orders = try managedContext.fetch(fetchRequest) as? [NOrder]
            if let orders = orders, !orders.isEmpty {
                return orders.first
            }
        } catch {
            print(error)
        }
        return nil
    }
}
