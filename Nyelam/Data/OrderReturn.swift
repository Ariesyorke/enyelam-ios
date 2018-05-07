//
//  OrderReturn.swift
//  Nyelam
//
//  Created by Bobi on 4/6/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

class OrderReturn: NSObject, NSCoding, Parseable {
    private let KEY_SUMMARY = "summary"
    private let KEY_VERITRANS_TOKEN = "veritrans_token"
    private let KEY_PAYPAL_CURRENCY = "paypal_currency"
    var summary: NSummary?
    var veritransToken: String?
    var paypalCurrency: PaypalCurrency?
    
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        guard let json = aDecoder.decodeObject(forKey: "json") as? [String: Any] else {
            return nil
        }
        self.init(json: json)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.serialized(), forKey: "json")
    }
    
    func parse(json: [String : Any]) {
        if let veritransJson = json[KEY_VERITRANS_TOKEN] as? [String: Any] {
            if let id = veritransJson["token_id"] as? String {
                self.veritransToken = id
            }
        } else if let veritransString = json[KEY_VERITRANS_TOKEN] as? String {
            do {
                let data = veritransString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let veritransJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = veritransJson["token_id"] as? String {
                    self.veritransToken = id
                }
            } catch {
                print(error)
            }
        }
        if let paypalCurrencyJson = json[KEY_PAYPAL_CURRENCY] as? [String: Any] {
            self.paypalCurrency = PaypalCurrency(json: paypalCurrencyJson)
        } else if let paypalCurrencyString = json[KEY_PAYPAL_CURRENCY] as? String {
            do {
                let data = paypalCurrencyString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let paypalCurrencyJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.paypalCurrency = PaypalCurrency(json: paypalCurrencyJson)
            } catch {
                print(error)
            }
        }
        if let summaryJson = json[KEY_SUMMARY] as? [String: Any] {
            if let orderJson = summaryJson["order"] as? [String: Any] {
                if let id = orderJson["order_id"] as? String {
                    self.summary = NSummary.getSummary(using: id)
                }
                if self.summary == nil {
                    self.summary = NSEntityDescription.insertNewObject(forEntityName: "NSummary", into: AppDelegate.sharedManagedContext) as! NSummary
                }
                self.summary!.parse(json: summaryJson)
            } else if let orderString = summaryJson["order"] as? String {
                do {
                    let data = orderString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                    let orderJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    if let id = orderJson["order_id"] as? String {
                        self.summary = NSummary.getSummary(using: id)
                    }
                    if self.summary == nil {
                        self.summary = NSEntityDescription.insertNewObject(forEntityName: "NSummary", into: AppDelegate.sharedManagedContext) as! NSummary
                    }
                    self.summary!.parse(json: summaryJson)
                } catch {
                    print(error)
                }
            }
        } else if let summaryString = json[KEY_SUMMARY] as? String {
            do {
                let data = summaryString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let summaryJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let orderJson = summaryJson["order"] as? [String: Any] {
                    if let id = orderJson["order_id"] as? String {
                        self.summary = NSummary.getSummary(using: id)
                    }
                    if self.summary == nil {
                        self.summary = NSEntityDescription.insertNewObject(forEntityName: "NSummary", into: AppDelegate.sharedManagedContext) as! NSummary
                    }
                    self.summary!.parse(json: summaryJson)
                } else if let orderString = summaryJson["order"] as? String {
                    do {
                        let data = orderString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let orderJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        if let id = orderJson["order_id"] as? String {
                            self.summary = NSummary.getSummary(using: id)
                        }
                        if self.summary == nil {
                            self.summary = NSEntityDescription.insertNewObject(forEntityName: "NSummary", into: AppDelegate.sharedManagedContext) as! NSummary
                        }
                        self.summary!.parse(json: summaryJson)
                    } catch {
                        print(error)
                    }
                }
            } catch {
                print(error)
            }
        }
        
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let token = veritransToken {
            json[KEY_VERITRANS_TOKEN] = token
        }
        if let summary = self.summary {
            json[KEY_SUMMARY] = summary.serialized()
        }
        if let paypalCurrency = self.paypalCurrency {
            json[KEY_PAYPAL_CURRENCY] = paypalCurrency
        }
        return json
    }
}
