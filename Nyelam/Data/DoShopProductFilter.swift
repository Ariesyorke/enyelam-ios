//
//  DoShopProductFilter.swift
//  Nyelam
//
//  Created by Bobi on 07/02/19.
//  Copyright © 2019 e-Nyelam. All rights reserved.
//

import Foundation

class DoShopProductFilter: Parseable {
    private let KEY_BRANDS = "brands"
    private let KEY_PRICE = "price"
    var brands: [Brand]?
    var price: Price?

    init(json: [String: Any]) {
        self.parse(json: json)
    }
    
    func parse(json: [String : Any]) {
        if let priceJson = json[KEY_PRICE] as? [String: Any] {
            self.price = Price(json: priceJson)
        } else if let priceString = json[KEY_PRICE] as? String {
            do {
                let data = priceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let priceJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.price = Price(json: priceJson)
            } catch {
                print(error)
            }
        }
        if let brandArray = json[KEY_BRANDS] as? Array<[String: Any]>, !brandArray.isEmpty {
            self.brands = []
            for brandJson in brandArray {
                let brand = Brand(json: brandJson)
                self.brands?.append(brand)
            }
        } else if let brandString = json[KEY_BRANDS] as? String {
            do {
                let data = brandString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let brandArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                self.brands = []
                for brandJson in brandArray {
                    let brand = Brand(json: brandJson)
                    self.brands?.append(brand)
                }
            } catch {
                print(error)
            }
        }
    }

    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let price = self.price {
            json[KEY_PRICE] = price.serialized()
        }
        if let brands = self.brands, !brands.isEmpty {
            var array: Array<[String: Any]> = []
            for brand in brands {
                array.append(brand.serialized())
            }
            json[KEY_BRANDS] = array
        }
        return json
    }

}
