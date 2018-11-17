//
//  DoShopRecommended.swift
//  Nyelam
//
//  Created by Bobi on 11/7/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

class DoShopRecommended: Parseable {
    private let KEY_CATEGORIES = "categories"
    private let KEY_RECOMMENDED = "recommended"
    
    var categories: [NProductCategory]?
    var products: [NProduct]?
    
    init(json: [String: Any]) {
        self.parse(json: json)
    }
    
    func parse(json: [String : Any]) {
        if let categoriesArray = json[KEY_CATEGORIES] as? Array<[String: Any]>, !categoriesArray.isEmpty {
            self.categories = []
            for categoryJson in categoriesArray {
                var category: NProductCategory? = nil
                if let id = categoryJson["id"] as? String {
                    category = NProductCategory.getCategory(using: id)
                }
                if category == nil {
                    category = NSEntityDescription.insertNewObject(forEntityName: "NProductCategory", into: AppDelegate.sharedManagedContext) as! NProductCategory
                }
                category!.parse(json: categoryJson)
                self.categories!.append(category!)
            }
        } else if let categoriesArrayString = json[KEY_CATEGORIES] as? String {
            do {
                var category: NProductCategory? = nil
                let data = categoriesArrayString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let categoriesArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                for categoryJson in categoriesArray {
                    if let id = categoryJson["id"] as? String {
                        category = NProductCategory.getCategory(using: id)
                    }
                    if category == nil {
                        category = NSEntityDescription.insertNewObject(forEntityName: "NProductCategory", into: AppDelegate.sharedManagedContext) as! NProductCategory
                    }
                    category!.parse(json: categoryJson)
                    self.categories!.append(category!)
                }
            } catch {
                print(error)
            }
        }
        
        if let productArray = json[KEY_RECOMMENDED] as? Array<[String: Any]>, !productArray.isEmpty {
            self.products = []
            for productJson in productArray {
                var product: NProduct? = nil
                if let id = productJson["id"] as? String {
                    product = NProduct.getProduct(using: id)
                }
                if product == nil {
                    product = NSEntityDescription.insertNewObject(forEntityName: "NProduct", into: AppDelegate.sharedManagedContext) as! NProduct
                }
                product!.parse(json: productJson)
                self.products!.append(product!)
            }
        } else if let productArrayString = json[KEY_RECOMMENDED] as? String {
            do {
                var product: NProduct? = nil
                let data = productArrayString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let productArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                self.products = []
                for productJson in productArray {
                    var product: NProduct? = nil
                    if let id = productJson["id"] as? String {
                        product = NProduct.getProduct(using: id)
                    }
                    if product == nil {
                        product = NSEntityDescription.insertNewObject(forEntityName: "NProduct", into: AppDelegate.sharedManagedContext) as! NProduct
                    }
                    product!.parse(json: productJson)
                    self.products!.append(product!)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let categories = self.categories, !categories.isEmpty {
            var array: Array<[String: Any]> = []
            for category in categories {
                array.append(category.serialized())
            }
            json[KEY_CATEGORIES] = array
        }
        if let products = self.products, !products.isEmpty {
            var array: Array<[String: Any]> = []
            for product in products {
                array.append(product.serialized())
            }
            json[KEY_RECOMMENDED] = array
        }
        return json
    }
}
