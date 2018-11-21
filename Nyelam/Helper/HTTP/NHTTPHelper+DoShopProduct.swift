//
//  NHTTPHelper+DoShopProduct.swift
//  Nyelam
//
//  Created by Bobi on 11/8/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import CoreData

extension NHTTPHelper {
    static func httpProductDetail(productId: String,
                                  complete: @escaping (NHTTPResponse<NProduct>)->()) {
        self.basicPostRequest(URLString: HOST_URL + API_PATH_PRODUCT_DETAIL, parameters: ["product_id": productId], headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var product: NProduct? = nil
                if let productJson = json["product"] as? [String: Any] {
                    if let id = productJson["id"] as? String {
                        product = NProduct.getProduct(using: id)
                    }
                    if product == nil {
                        product = NSEntityDescription.insertNewObject(forEntityName: "NProduct", into: AppDelegate.sharedManagedContext) as! NProduct
                    }
                    product!.parse(json: productJson)
                } else if let productJsonString = json["product"] as? String {
                    do {
                        let data = productJsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let productJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        if let id = productJson["id"] as? String {
                            product = NProduct.getProduct(using: id)
                        }
                        if product == nil {
                            product = NSEntityDescription.insertNewObject(forEntityName: "NProduct", into: AppDelegate.sharedManagedContext) as! NProduct
                        }
                        product!.parse(json: productJson)
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: product, error: nil))

            }
        })
    }
    static func httpGetProductList(page: Int,
                                   keyword: String?,
                                   categoryId: String?,
                                   priceMin: Double?,
                                   priceMax: Double?,
                                   sortBy: Int?,
                                   merchantId: String?,
                                   complete: @escaping (NHTTPResponse<[NProduct]>)->()) {
        var params: [String: Any] = ["page": String(page)]
        if let keyword = keyword {
            params["keyword"] = keyword
        }
        if let categoryId = categoryId {
            params["category_id"] =  categoryId
        }
        if let priceMin = priceMin {
            params["price_min"] = String(Int64(priceMin))
        }
        if let priceMax = priceMax {
            params["price_max"] = String(Int64(priceMax))
        }
        if let sortBy = sortBy {
            params["sort_by"] = String(sortBy)
        }
        if let merchantId = merchantId {
            params["merchant_id"] = merchantId
        }
        self.basicPostRequest(URLString: HOST_URL + API_PATH_DO_SHOP_PRODUCT_LIST, parameters: params, headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var products: [NProduct]? = nil
                if let productArray = json["products"] as? Array<[String: Any]>, !productArray.isEmpty {
                    products = []
                    for productJson in productArray {
                        var product: NProduct? = nil
                        if let id = productJson["id"] as? String {
                            product = NProduct.getProduct(using: id)
                        }
                        if product == nil {
                            product = NSEntityDescription.insertNewObject(forEntityName: "NProduct", into: AppDelegate.sharedManagedContext) as! NProduct
                        }
                        product!.parse(json: productJson)
                    }
                } else if let productArrayString = json["products"] as? String {
                    do {
                        var product: NProduct? = nil
                        let data = productArrayString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let productArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        for productJson in productArray {
                            var product: NProduct? = nil
                            if let id = productJson["id"] as? String {
                                product = NProduct.getProduct(using: id)
                            }
                            if product == nil {
                                product = NSEntityDescription.insertNewObject(forEntityName: "NProduct", into: AppDelegate.sharedManagedContext) as! NProduct
                            }
                            product!.parse(json: productJson)
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: products, error: nil))
            }
        })
    }
}
