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
    static func httpDoShopProductFilter(keyword: String?, categoryId: String?,
                                 brandId: String?, complete: @escaping (NHTTPResponse<DoShopProductFilter>) -> ()) {
        var param: [String: Any] = [:]
        if let keyword = keyword {
            param["keyword"] = keyword
        }
        if let categoryId = categoryId {
            param["category_id"] = categoryId
        }
        if let brandId = brandId {
            param["brand_id"] = brandId
        }
        
        self.basicPostRequest(
            URLString: HOST_URL+API_PATH_DO_SHOP_PRODUCT_FILTER,
            parameters:param,
            headers:nil,
            complete:
            {status, data, error in
                if let error = error {
                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                    return
                }
                var filter: DoShopProductFilter? = nil
                if let data = data, let json = data as? [String: Any] {
                    print("DATA \(data)")
                    filter = DoShopProductFilter(json: json)
                }
                complete(NHTTPResponse(resultStatus: true, data: filter, error: nil))
        })
    }

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
                                   priceMin: CGFloat?,
                                   priceMax: CGFloat?,
                                   sortBy: Int?,
                                   merchantId: String?,
                                   brands: [String]?,
                                   recommended: Int? = nil,
                                   complete: @escaping (NHTTPResponse<ProductReturn>)->()) {
        var params: [String: Any] = ["page": String(page)]
        if let recommended = recommended {
            params["recommended"] = recommended
        }
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
        if let brands = brands, !brands.isEmpty {
            params["brand_id"] = brands
        }
        self.basicPostRequest(URLString: HOST_URL + API_PATH_DO_SHOP_PRODUCT_LIST, parameters: params, headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                let productReturn: ProductReturn = ProductReturn(json: json)
                complete(NHTTPResponse(resultStatus: true, data: productReturn, error: nil))
            }
        })
    }
}

class ProductReturn: Parseable {
    var next: Int = -1
    var products: [NProduct]?
    
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
        if let productArray = json["products"] as? Array<[String: Any]>, !productArray.isEmpty {
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
                    self.products!.append(product!)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        json["next"] = next
        if let products = self.products, !products.isEmpty {
            var array: Array<[String: Any]> = []
            for product in products {
                array.append(product.serialized())
            }
            json["products"] = array
        }
        return json
    }
}
