//
//  Merchant.swift
//  Nyelam
//
//  Created by Bobi on 11/13/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

public class Merchant: NSObject, NSCoding, Parseable {
    private let KEY_ID = "id"
    private let KEY_NAME = "name"
    private let KEY_MERCHANT_NAME = "merchant_name"
    private let KEY_MERCHANT_LOGO = "merchant_logo"
    private let KEY_PROVINCE_ID = "province_id"
    private let KEY_CITY_ID = "city_id"
    private let KEY_DISTRICT_ID = "district_id"
    private let KEY_POSTAL_CODE = "postal_code"
    private let KEY_ADDRESS = "address"
    private let KEY_TOTAL_WEIGHT = "total_weight"
    private let KEY_PRODUCTS = "products"
    private let KEY_DELIVERY_SERVICE = "delivery_service"
    
    var id: String?
    var merchantName: String?
    var merchantLogo: String?
    var provinceId: String?
    var cityId: String?
    var districtId: String?
    var postaLCode: String?
    var address: String?
    var totalWeight: Double = 0.0
    var products: [CartProduct]?
    var deliveryService: DeliveryService?
    
    public convenience required init?(coder aDecoder: NSCoder) {
        guard let json = aDecoder.decodeObject(forKey: "json") as? [String: Any] else {
            return nil
        }
        self.init(json: json)
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.serialized(), forKey: "json")
    }

    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }

    func parse(json: [String : Any]) {
        self.id = json[KEY_ID] as? String
        if let name = json[KEY_MERCHANT_NAME] as? String {
            self.merchantName = name
        } else if let name = json[KEY_NAME] as? String {
            self.merchantName = name
        }
        self.merchantLogo = json[KEY_MERCHANT_LOGO] as? String
        self.provinceId = json[KEY_PROVINCE_ID] as? String
        self.cityId = json[KEY_CITY_ID] as? String
        self.districtId = json[KEY_DISTRICT_ID] as? String
        self.postaLCode = json[KEY_POSTAL_CODE] as? String
        self.address = json[KEY_ADDRESS] as? String
        if let totalWeight = json[KEY_TOTAL_WEIGHT] as? Double {
            self.totalWeight = totalWeight
        } else if let totalWeight = json[KEY_TOTAL_WEIGHT] as? String {
            if totalWeight.isNumber {
                self.totalWeight = Double(totalWeight)!
            }
        }
        if let productsArray = json[KEY_PRODUCTS] as? Array<[String: Any]>, !productsArray.isEmpty {
            self.products = []
            for productJson in productsArray {
                let product = CartProduct(json: productJson)
                self.products!.append(product)
            }
        } else if let productArrayString = json[KEY_PRODUCTS] as? String {
            do {
                let data = productArrayString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let productArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                self.products = []
                for productJson in productArray {
                    let product = CartProduct(json: productJson)
                    self.products!.append(product)
                }
            } catch {
                print(error)
            }
        }
        if let deliveryServiceJson = json[KEY_DELIVERY_SERVICE] as? [String: Any] {
            self.deliveryService = DeliveryService(json: deliveryServiceJson)
        } else if let deliveryServiceString = json[KEY_DELIVERY_SERVICE] as? String {
            do {
                let data = deliveryServiceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let deliveryServiceJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.deliveryService = DeliveryService(json: deliveryServiceJson)
            } catch {
                print(error)
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let id = self.id {
            json[KEY_ID] = id
        }
        if let merchantName = self.merchantName {
            json[KEY_MERCHANT_NAME] = merchantName
        }
        if let merchantLogo = self.merchantLogo {
            json[KEY_MERCHANT_LOGO] = merchantLogo
        }
        if let provinceId = self.provinceId {
            json[KEY_PROVINCE_ID] = provinceId
        }
        if let cityId = self.cityId {
            json[KEY_CITY_ID] = cityId
        }
        if let districtId = self.districtId {
            json[KEY_DISTRICT_ID] = districtId
        }
        if let postalCode = self.postaLCode {
            json[KEY_POSTAL_CODE] = postalCode
        }
        if let address = self.address {
            json[KEY_ADDRESS] = address
        }
        json[KEY_TOTAL_WEIGHT] = self.totalWeight
        if let products = self.products, !products.isEmpty {
            var array: Array<[String: Any]> = []
            for product in products {
                array.append(product.serialized())
            }
            json[KEY_PRODUCTS] = array
        }
        if let deliverySerivce = self.deliveryService {
            json[KEY_DELIVERY_SERVICE] = deliveryService?.serialized()
        }
        return json
    }
}
