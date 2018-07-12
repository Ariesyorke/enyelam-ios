//
//  NHTTPHelper+DoDive.swift
//  Nyelam
//
//  Created by Bobi on 4/6/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

extension NHTTPHelper {
    static func httpDoDiveSearchBy(keyword: String, ecoTrip: Int?, type: Int, complete: @escaping (NHTTPResponse<[SearchResult]>)->()) {
        var param: [String: Any] = [:]
        param["keyword"] = keyword
        param["type"] = type
        if let ecoTrip = ecoTrip {
            param["eco_trip"] = ecoTrip
        }
        self.basicPostRequest(URLString: HOST_URL+API_PATH_MASTER_DO_DIVE_SEARCH,
                              parameters: param,
                              headers: nil,
                              complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var searchResults: [SearchResult]? = nil
                if let searchResultArray = json["search_results"] as? Array<[String: Any]>, !searchResultArray.isEmpty {
                    searchResults = []
                    for searchResultJson in searchResultArray {
                        var searchResult: SearchResult? = nil
                        if let type = searchResultJson["type"] as? Int {
                            searchResult = SearchResult.generateSearchResultType(type: type, json: searchResultJson)
                        } else if let type = searchResultJson["type"] as? String {
                            if type.isNumber {
                                searchResult = SearchResult.generateSearchResultType(type: Int(type)!, json: searchResultJson)
                            }
                        } else {
                            searchResult = SearchResult(json: searchResultJson)
                        }
                        searchResults!.append(searchResult!)
                    }
                } else if let searchResultString = json["search_results"] as? String {
                    do {
                        let data = searchResultString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let searchResultArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        searchResults = []
                        for searchResultJson in searchResultArray {
                            var searchResult: SearchResult? = nil
                            if let type = searchResultJson["type"] as? Int {
                                searchResult = SearchResult.generateSearchResultType(type: type, json: searchResultJson)
                            } else if let type = searchResultJson["type"] as? String {
                                if type.isNumber {
                                    searchResult = SearchResult.generateSearchResultType(type: Int(type)!, json: searchResultJson)
                                }
                            } else {
                                searchResult = SearchResult(json: searchResultJson)
                            }
                            searchResults!.append(searchResult!)
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: searchResults, error: nil))
            }
        })
    }
    
    static func httpDoDiveSearchBy(categories: [String], page: String, diver: Int, certificate: Int, date: TimeInterval, sortBy: Int, ecoTrip: Int?, totalDives: [String]?, facilities: [String]?, priceMin: Int?, priceMax: Int?, complete: @escaping (NHTTPResponse<[NDiveService]>)->()) {
        var param: [String: Any] = [:]
        param["page"] = page
        param["dive_category_id"] = categories
        param["diver"] = String(diver)
        param["certificate"] = String(certificate)
        param["date"] = String(date)
        param["sort_by"] = String(sortBy)
        if let totalDives = totalDives, !totalDives.isEmpty {
            param["total_dives"] = totalDives
        }
        if let facilities = facilities, !facilities.isEmpty {
            param["facilities"] = facilities
        }
        if let ecoTrip = ecoTrip {
            param["eco_trip"] = String(ecoTrip)
        }
        if let priceMin = priceMin {
            param["price_min"] = String(priceMin)
        }
        if let priceMax = priceMax {
            param["price_max"] = String(priceMax)
        }
        self.basicPostRequest(URLString: HOST_URL+API_PATH_SEARCH_SERVICE_LIST_BY_CATEGORY,
                              parameters: param, headers: nil, complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    var diveservices: [NDiveService]? = nil
                                    if let diveServiceArray = json["dive_services"] as? Array<[String: Any]>, !diveServiceArray.isEmpty {
                                        diveservices = []
                                        for diveServiceJson in diveServiceArray {
                                            var diveService: NDiveService? = nil
                                            if let id = diveServiceJson["id"] as? String {
                                                diveService = NDiveService.getDiveService(using: id)
                                            }
                                            if diveService == nil {
                                                diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                            }
                                            diveService!.parse(json: diveServiceJson)
                                            diveservices!.append(diveService!)
                                        }
                                    } else if let diveServiceString = json["dive_services"] as? String {
                                        do {
                                            let data = diveServiceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                            let diveServiceArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                                            diveservices = []
                                            for diveServiceJson in diveServiceArray {
                                                var diveService: NDiveService? = nil
                                                if let id = diveServiceJson["id"] as? String {
                                                    diveService = NDiveService.getDiveService(using: id)
                                                }
                                                if diveService == nil {
                                                    diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                }
                                                diveService!.parse(json: diveServiceJson)
                                                diveservices!.append(diveService!)
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    complete(NHTTPResponse(resultStatus: true, data: diveservices, error: nil))
                                }

        })
    }
    
    static func httpDoDiveSearchBy(diveSpotId: String, page: String, diver: Int, certificate: Int, date: TimeInterval, sortBy: Int, ecoTrip: Int?, totalDives: [String]?, categories: [String]?, facilities: [String]?, priceMin: Int?, priceMax: Int?, complete: @escaping (NHTTPResponse<[NDiveService]>)->()) {
        var param: [String: Any] = [:]
        param["page"] = page
        param["diver"] = String(diver)
        param["certificate"] = String(certificate)
        param["date"] = String(date)
        param["sort_by"] = String(sortBy)
        param["dive_spot_id"] = diveSpotId
        if let categories = categories, !categories.isEmpty {
            param["dive_category_id"] = categories
        }
        if let totalDives = totalDives, !totalDives.isEmpty {
            param["total_dives"] = totalDives
        }
        if let facilities = facilities, !facilities.isEmpty {
            param["facilities"] = facilities
        }
        if let ecoTrip = ecoTrip {
            param["eco_trip"] = String(ecoTrip)
        }
        if let priceMin = priceMin {
            param["price_min"] = String(priceMin)
        }
        if let priceMax = priceMax {
            param["price_max"] = String(priceMax)
        }
        self.basicPostRequest(URLString: HOST_URL+API_PATH_SEARCH_SERVICE_LIST_BY_DIVESPOT,
                              parameters: param, headers: nil, complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    var diveservices: [NDiveService]? = nil
                                    if let diveServiceArray = json["dive_services"] as? Array<[String: Any]>, !diveServiceArray.isEmpty {
                                        diveservices = []
                                        for diveServiceJson in diveServiceArray {
                                            var diveService: NDiveService? = nil
                                            if let id = diveServiceJson["id"] as? String {
                                                diveService = NDiveService.getDiveService(using: id)
                                            }
                                            if diveService == nil {
                                                diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                            }
                                            diveService!.parse(json: diveServiceJson)
                                            diveservices!.append(diveService!)
                                        }
                                    } else if let diveServiceString = json["dive_services"] as? String {
                                        do {
                                            let data = diveServiceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                            let diveServiceArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                                            diveservices = []
                                            for diveServiceJson in diveServiceArray {
                                                var diveService: NDiveService? = nil
                                                if let id = diveServiceJson["id"] as? String {
                                                    diveService = NDiveService.getDiveService(using: id)
                                                }
                                                if diveService == nil {
                                                    diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                }
                                                diveService!.parse(json: diveServiceJson)
                                                diveservices!.append(diveService!)
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    complete(NHTTPResponse(resultStatus: true, data: diveservices, error: nil))
                                }
                                
        })
    }
    
    static func httpDoDiveSearchBy(provinceId: String, page: String, diver: Int, certificate: Int, date: TimeInterval, sortBy: Int, ecoTrip: Int?, totalDives: [String]?, categories: [String]?, facilities: [String]?, priceMin: Int?, priceMax: Int?, complete: @escaping (NHTTPResponse<[NDiveService]>)->()) {
        var param: [String: Any] = [:]
        param["page"] = page
        param["diver"] = String(diver)
        param["certificate"] = String(certificate)
        param["date"] = String(date)
        param["sort_by"] = String(sortBy)
        param["province_id"] = provinceId
        if let categories = categories, !categories.isEmpty {
            param["dive_category_id"] = categories
        }
        if let totalDives = totalDives, !totalDives.isEmpty {
            param["total_dives"] = totalDives
        }
        if let facilities = facilities, !facilities.isEmpty {
            param["facilities"] = facilities
        }
        if let ecoTrip = ecoTrip {
            param["eco_trip"] = String(ecoTrip)
        }
        if let priceMin = priceMin {
            param["price_min"] = String(priceMin)
        }
        if let priceMax = priceMax {
            param["price_max"] = String(priceMax)
        }
        self.basicPostRequest(URLString: HOST_URL+API_PATH_SEARCH_SERVICE_LIST_BY_PROVINCE,
                              parameters: param, headers: nil, complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    var diveservices: [NDiveService]? = nil
                                    if let diveServiceArray = json["dive_services"] as? Array<[String: Any]>, !diveServiceArray.isEmpty {
                                        diveservices = []
                                        for diveServiceJson in diveServiceArray {
                                            var diveService: NDiveService? = nil
                                            if let id = diveServiceJson["id"] as? String {
                                                diveService = NDiveService.getDiveService(using: id)
                                            }
                                            if diveService == nil {
                                                diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)

                                            }
                                            diveService!.parse(json: diveServiceJson)
                                            diveservices!.append(diveService!)
                                        }
                                    } else if let diveServiceString = json["dive_services"] as? String {
                                        do {
                                            let data = diveServiceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                            let diveServiceArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                                            diveservices = []
                                            for diveServiceJson in diveServiceArray {
                                                var diveService: NDiveService? = nil
                                                if let id = diveServiceJson["id"] as? String {
                                                    diveService = NDiveService.getDiveService(using: id)
                                                }
                                                if diveService == nil {
                                                    diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                }
                                                diveService!.parse(json: diveServiceJson)
                                                diveservices!.append(diveService!)
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    complete(NHTTPResponse(resultStatus: true, data: diveservices, error: nil))
                                }
                                
        })
    }
    
    static func httpDoDiveSearchBy(cityId: String, page: String, diver: Int, certificate: Int, date: TimeInterval, sortBy: Int, ecoTrip: Int?, totalDives: [String]?, categories: [String]?, facilities: [String]?, priceMin: Int?, priceMax: Int?, complete: @escaping (NHTTPResponse<[NDiveService]>)->()) {
        var param: [String: Any] = [:]
        param["page"] = page
        param["diver"] = String(diver)
        param["certificate"] = String(certificate)
        param["date"] = String(date)
        param["sort_by"] = String(sortBy)
        param["city_id"] = cityId
        if let categories = categories, !categories.isEmpty {
            param["dive_category_id"] = categories
        }
        if let totalDives = totalDives, !totalDives.isEmpty {
            param["total_dives"] = totalDives
        }
        if let facilities = facilities, !facilities.isEmpty {
            param["facilities"] = facilities
        }
        if let ecoTrip = ecoTrip {
            param["eco_trip"] = String(ecoTrip)
        }
        if let priceMin = priceMin {
            param["price_min"] = String(priceMin)
        }
        if let priceMax = priceMax {
            param["price_max"] = String(priceMax)
        }
        self.basicPostRequest(URLString: HOST_URL+API_PATH_SEARCH_SERVICE_LIST_BY_CITY,
                              parameters: param, headers: nil, complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    var diveservices: [NDiveService]? = nil
                                    if let diveServiceArray = json["dive_services"] as? Array<[String: Any]>, !diveServiceArray.isEmpty {
                                        diveservices = []
                                        for diveServiceJson in diveServiceArray {
                                            var diveService: NDiveService? = nil
                                            if let id = diveServiceJson["id"] as? String {
                                                diveService = NDiveService.getDiveService(using: id)
                                            }
                                            if diveService == nil {
                                                diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)

                                            }
                                            diveService!.parse(json: diveServiceJson)
                                            diveservices!.append(diveService!)
                                        }
                                    } else if let diveServiceString = json["dive_services"] as? String {
                                        do {
                                            let data = diveServiceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                            let diveServiceArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                                            diveservices = []
                                            for diveServiceJson in diveServiceArray {
                                                var diveService: NDiveService? = nil
                                                if let id = diveServiceJson["id"] as? String {
                                                    diveService = NDiveService.getDiveService(using: id)
                                                }
                                                if diveService == nil {
                                                    diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)

                                                }
                                                diveService!.parse(json: diveServiceJson)
                                                diveservices!.append(diveService!)
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    complete(NHTTPResponse(resultStatus: true, data: diveservices, error: nil))
                                }
                                
        })
    }
    
    
    static func httpDoDiveSearchBy(diveCenterId: String, page: String, diver: Int, certificate: Int, date: TimeInterval, sortBy: Int, ecoTrip: Int?, totalDives: [String]?, categories: [String]?, facilities: [String]?, priceMin: Int?, priceMax: Int?, complete: @escaping (NHTTPResponse<[NDiveService]>)->()) {
        var param: [String: Any] = [:]
        param["page"] = page
        param["diver"] = String(diver)
        param["certificate"] = String(certificate)
        param["date"] = String(date)
        param["sort_by"] = String(sortBy)
        param["dive_center_id"] = diveCenterId
        if let categories = categories, !categories.isEmpty {
            param["dive_category_id"] = categories
        }
        if let totalDives = totalDives, !totalDives.isEmpty {
            param["total_dives"] = totalDives
        }
        if let facilities = facilities, !facilities.isEmpty {
            param["facilities"] = facilities
        }
        if let ecoTrip = ecoTrip {
            param["eco_trip"] = String(ecoTrip)
        }
        if let priceMin = priceMin {
            param["price_min"] = String(priceMin)
        }
        if let priceMax = priceMax {
            param["price_max"] = String(priceMax)
        }
        self.basicPostRequest(URLString: HOST_URL+API_PATH_SEARCH_SERVICE_LIST_BY_DIVE_CENTER,
                              parameters: param, headers: nil, complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    var diveservices: [NDiveService]? = nil
                                    if let diveServiceArray = json["dive_services"] as? Array<[String: Any]>, !diveServiceArray.isEmpty {
                                        diveservices = []
                                        for diveServiceJson in diveServiceArray {
                                            var diveService: NDiveService? = nil
                                            if let id = diveServiceJson["id"] as? String {
                                                diveService = NDiveService.getDiveService(using: id)
                                            }
                                            if diveService == nil {
                                                diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                            }
                                            diveService!.shouldParseDivespot = false
                                            diveService!.parse(json: diveServiceJson)
                                            diveservices!.append(diveService!)
                                        }
                                    } else if let diveServiceString = json["dive_services"] as? String {
                                        do {
                                            let data = diveServiceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                            let diveServiceArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                                            diveservices = []
                                            for diveServiceJson in diveServiceArray {
                                                var diveService: NDiveService? = nil
                                                if let id = diveServiceJson["id"] as? String {
                                                    diveService = NDiveService.getDiveService(using: id)
                                                }
                                                if diveService == nil {
                                                    diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                }
                                                diveService!.shouldParseDivespot = false
                                                diveService!.parse(json: diveServiceJson)
                                                diveservices!.append(diveService!)
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    complete(NHTTPResponse(resultStatus: true, data: diveservices, error: nil))
                                }
                                
        })
    }
    
    static func httpDoDiveSuggestion(complete: @escaping (NHTTPResponse<[NDiveService]>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_SUGGESTION_SERVICE,
                              complete: {status, data, error in
                            if let error = error {
                                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                return
                            }
                            if let data = data, let json = data as? [String: Any] {
                                var diveservices: [NDiveService]? = nil
                                if let diveServiceArray = json["dive_services"] as? Array<[String: Any]>, !diveServiceArray.isEmpty {
                                    diveservices = []
                                    for diveServiceJson in diveServiceArray {
                                        var diveService: NDiveService? = nil
                                        if let id = diveServiceJson["id"] as? String {
                                            diveService = NDiveService.getDiveService(using: id)
                                        }
                                        if diveService == nil {
                                            diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)

                                        }
                                        diveService!.parse(json: diveServiceJson)
                                        diveservices!.append(diveService!)
                                    }
                                } else if let diveServiceString = json["dive_services"] as? String {
                                    do {
                                        let data = diveServiceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                        let diveServiceArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                                        diveservices = []
                                        for diveServiceJson in diveServiceArray {
                                            var diveService: NDiveService? = nil
                                            if let id = diveServiceJson["id"] as? String {
                                                diveService = NDiveService.getDiveService(using: id)
                                            }
                                            if diveService == nil {
                                                diveService = NSEntityDescription.insertNewObject(forEntityName: "NDiveService", into: AppDelegate.sharedManagedContext) as! NDiveService
                                            }
                                            diveService!.parse(json: diveServiceJson)
                                            diveservices!.append(diveService!)
                                        }
                                    } catch {
                                        print(error)
                                    }
                                }
                                complete(NHTTPResponse(resultStatus: true, data: diveservices, error: nil))
                            }
        })
    }
    
}

