//
//  NHTTPHelper.swift
//  Nyelam
//
//  Created by Bobi on 4/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import CoreData

class NHTTPHelper {
    static let API_VER = 1
    static let STATUS_SUCCESS = 1
    static let STATUS_FAILED = 2
    static let STATUS_INVALID_TOKEN = 3
    
    static let KEY_STATUS = "status"
    static let KEY_DATA = "data"
    static let KEY_CODE = "code"
    static let KEY_ERROR = "error"
    static let KEY_MESSAGE = "message"
    
    static let POST_APP_VER = "app_ver"
    static let POST_OS_VER = "os_ver"
    static let POST_API_VER = "api_ver"
    static let POST_TIMESTAMP = "timestamp"
    static let POST_DEVICE = "device"
    static let POST_PLATFORM = "platform"
    static let API_RAJA_ONGKIR_KEY = "f6884fab1a6386a9438b9c541b1d3333"
    
    internal static func httpCancelRequest(apiUrl: String) {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach {
                if $0.originalRequest?.url?.absoluteString == HOST_URL + apiUrl {
                    $0.cancel()
                }
            }
        }
    }
    static var HOST_URL: String {
        switch NConstant.URL_TYPE {
        case .staging:
            return "https://nyelam.dantech.id/"
        case .development:
            return "https://nyelam-adam.dantech.id/"
        default:
            return "https://api.e-nyelam.com/"
        }
    }
    static var RAJA_ONGKIR_URL: String  {
        switch NConstant.URL_TYPE {
        case .staging:
            return "https://pro.rajaongkir.com/"
        case .development:
            return "https://pro.rajaongkir.com/"
        default:
            return "https://pro.rajaongkir.com/"
        }

    }
    static var API_PATH_LOGIN: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/login"
        default:
            return "api/user/login"
        }
    }
    
    static var API_PATH_UPDATE_VERSION: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "master/UpdateVersion"
        default:
            return "api/master/UpdateVersion"
        }
    }
    
    static var API_PATH_SOCMED_LOGIN: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/socmedlogin"
        default:
            return "api/user/socmedlogin"
        }
    }
    
    static var API_PATH_REGISTER: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/register"
        default:
            return "api/user/register"
        }
    }
    
    static var API_PATH_FORGOT_PASSWORD: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/forgotpass"
        default:
            return "api/user/forgotpass"
        }
    }
    
    static var API_PATH_MASTER_COUNTRY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "master/country"
        default:
            return "api/master/country"
        }
    }
    
    static var API_PATH_MASTER_NATIONALITY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "master/nationality"
        default:
            return "api/master/nationality"
        }
    }
    
    static var API_PATH_MASTER_LANGUAGE: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "master/language"
        default:
            return "api/master/language"
        }
    }
    
    static var API_PATH_MASTER_CATEGORY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "service/masterCategory"
        default:
            return "api/service/masterCategory"
        }
    }
    
    static var API_PATH_MASTER_DO_DIVE_SEARCH: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "master/dodive/search"
        default:
            return "api/master/dodive/search"
        }
    }
    
    static var API_PATH_SUGGESTION_SERVICE: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "dodive/sugestion"
        default:
            return "api/dodive/sugestion"
        }
    }
    
    static var API_PATH_SEARCH_SERVICE_LIST_BY_DIVE_CENTER: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "dodive/search/divecenter"
        default:
            return "api/dodive/search/divecenter"
        }
    }
    
    static var API_PATH_SEARCH_SERVICE_LIST_BY_DIVESPOT: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "dodive/search/divespot"
        default:
            return "api/dodive/search/divespot"
        }
    }
    
    static var API_PATH_SEARCH_SERVICE_LIST_BY_CATEGORY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "dodive/search/category"
        default:
            return "api/dodive/search/category"
        }
    }
    
    static var API_PATH_SEARCH_SERVICE_LIST_BY_PROVINCE: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "dodive/search/province"
        default:
            return "api/dodive/search/province"
        }
    }
    
    static var API_PATH_SEARCH_SERVICE_LIST_BY_CITY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "dodive/search/city"
        default:
            return "api/dodive/search/city"
        }
    }
    
    static var API_PATH_HOMEPAGE_MODULES: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "master/homepage"
        default:
            return "api/master/homepage"
        }
    }
    static var API_PATH_DETAIL_SERVICE: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "service/detailService"
        default:
            return "api/service/detailService"
        }
    }
    static var API_PATH_BOOK_SERVICE_CART: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "order/bookservicecart"
        default:
            return "api/order/bookservicecart"
        }
    }
    static var API_PATH_BOOK_GET_PARTICIPANTS: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "order/getSavedParticipants"
        default:
            return "api/order/getSavedParticipants"
        }
    }
    static var API_PATH_SUBMIT_ORDER: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "order/submit"
        default:
            return "api/order/submit"
        }
    }
    static var API_PATH_BOOKING_HISTORY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "order/orderList"
        default:
            return "api/order/orderList"
        }
    }
    static var API_PATH_BOOKING_DETAIL: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "order/detail"
        default:
            return "api/order/detail"
        }
    }
    static var API_PATH_DIVE_CENTER_DETAIL: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "divecenter/detail"
        default:
            return "api/divecenter/detail"
        }
    }
    static var API_PATH_DIVE_SPOT_DETAIL: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "divespot/detail"
        default:
            return "api/divespot/detail"
        }
    }
    
    static var API_PATH_UPLOAD_PAYMENT_PROOF: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "order/paymentProof"
        default:
            return "api/order/paymentProof"
        }
    }
    
    static var API_PATH_CHANGE_PASSWORD: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/changepass"
        default:
            return "api/user/changepass"
        }
    }
    
    static var API_PATH_UPDATE_PROFILE: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/profile/edit"
        default:
            return "api/user/profile/edit"
        }
    }
    static var API_PATH_UPDATE_PHOTO: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/photo"
        default:
            return "api/user/photo"
        }
    }
    static var API_PATH_UPLOAD_COVER: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/cover"
        default:
            return "api/user/cover"
        }
    }
    static var API_PATH_DO_TRIP_SUGGESTION: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "dotrip/suggestion"
        default:
            return "api/dotrip/suggestion"
        }
    }
    static var API_PATH_DO_TRIP_SEARCH_BY_DIVE_CENTER: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "dotrip/search/divecenter"
        default:
            return "api/dotrip/search/divecenter"
        }
    }
    static var API_PATH_DO_TRIP_SEARCH_BY_DIVE_SPOT: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "dotrip/search/divespot"
        default:
            return "api/dotrip/search/divespot"
        }
    }
    static var API_PATH_DO_TRIP_SEARCH_BY_CATEGORY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "dotrip/search/category"
        default:
            return "api/dotrip/search/category"
        }
    }
    static var API_PATH_DO_TRIP_SEARCH_BY_PROVINCE: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "dotrip/search/province"
        default:
            return "api/dotrip/search/province"
        }
    }
    static var API_PATH_DO_TRIP_SEARCH_BY_CITY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "dotrip/search/city"
        default:
            return "api/dotrip/search/city"
        }
    }
    static var API_PATH_MIN_MAX_PRICE: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "service/minMaxPriceList"
        default:
            return "api/service/minMaxPriceList"
        }
    }
    static var API_PATH_CHANGE_PAYMENT_METHOD: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "order/changePaymentMethod"
        default:
            return "api/order/changePaymentMethod"
        }

    }
    static var API_PATH_GET_ALL_DO_TRIP: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "dotrip/seeAll"
        default:
            return "api/dotrip/seeAll"
        }
    }
    
    static var API_PATH_DO_TRIP_DETAIL: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "dotrip/detail"
        default:
            return "api/dotrip/detail"
        }
    }
    
    
    
    static var API_VERITRANS_PAYPAL_NOTIFICATION: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "https://api.e-nyelam.com/notification/veritrans"
        case .development:
            return "https://nyelam-adam.dantech.id/api/notification/veritrans"
        default:
            return "https://nyelam.dantech.id/api/notification/veritrans"
        }
    }
    
    static var API_PATH_PAYPAL_NOTIFICATION: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "https://api.e-nyelam.com/notification/paypal"
        case .development:
            return "https://nyelam-adam.dantech.id/api/notification/paypal"
        default:
            return "https://nyelam.dantech.id/api/notification/paypal"
        }
    }
    
    static var API_PATH_RESUBMIT_ORDER: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "order/resubmitOrder"
        default:
            return "api/order/resubmitOrder"
        }
    }
    
    static var API_PATH_MASTER_ORGANIZATION: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "master/organization"
        default:
            return "api/master/organization"
        }
    }
    
    static var API_PATH_MASTER_LICENSE: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "master/lisence"
        default:
            return "api/master/lisence"
        }
    }
    
    static var API_PATH_DO_COURSE_SEARCH_BY_DIVECENTER: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "docourse/search/divecenter"
        default:
            return "api/docourse/search/divecenter"
        }
    }
    
    static var API_PATH_DO_COURSE_SEARCH_BY_PROVINCE: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "docourse/search/province"
        default:
            return "api/docourse/search/province"
        }
    }
    
    static var API_PATH_DO_COURSE_SEARCH_BY_CITY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "docourse/search/city"
        default:
            return "api/docourse/search/city"
        }
    }
    
    static var API_PATH_DO_COURSE_SUGGESTION: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "docourse/sugestion"
        default:
            return "api/docourse/sugestion"
        }
    }
    static var API_PATH_DO_COURSE_DETAIL: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "docourse/detail"
        default:
            return "api/docourse/detail"
        }
    }
    static var API_PATH_EQUIPMENT_LIST: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "service/EquipmentRentList"
        default:
            return "api/service/EquipmentRentList"
        }
    }
    static var API_PATH_ECO_TRIP_CALENDAR: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "service/ecotripCalender"
        default:
            return "api/service/ecotripCalender"
        }
    }
    
    static var API_PATH_BANNER: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "master/banner"
        default:
            return "api/master/banner"
        }
    }
    
    static var API_PATH_REVIEW_LIST: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "service/review"
        default:
            return "api/service/review"
        }
    }
    
    static var API_PATH_DIVE_GUIDE_LIST: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/diveguideList"
        default:
            return "api/user/diveguideList"
        }
    }
    
    static var API_PATH_DIVE_GUIDE_DETAIL: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/diveguide"
        default:
            return "api/user/diveguide"
        }
    }
    
    static var API_PATH_ADD_VOUCHER: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "order/voucher"
        default:
            return "api/order/voucher"
        }
    }
    
    static var API_PATH_GET_INBOX: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "inbox/all"
        default:
            return "api/inbox/all"
        }
    }
    static var API_PATH_INBOX_DETAIL: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "inbox/detail"
        default:
            return "api/inbox/detail"
        }
    }
    static var API_PATH_POST_INBOX: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "inbox/post"
        default:
            return "api/inbox/post"
        }
    }
    
    static var API_PATH_POST_INBOX_DETAIL: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "inbox/add"
        default:
            return "api/inbox/add"
        }
    }
    
    static var API_PATH_SUBMIT_REVIEW: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "service/review/submit"
        default:
            return "api/service/review/submit"
        }
    }
    
    static var API_PATH_RECOMMENDED_SHOP: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "doshop/"
        default:
            return "api/doshop/"
        }
    }
    
    static var API_PATH_DO_SHOP_CATEGORY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "doshop/category"
        default:
            return "api/doshop/category"
        }
    }
    
    static var API_PATH_DO_SHOP_PRODUCT_LIST: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "doshop/product_list"
        default:
            return "api/doshop/product_list"
        }
    }
    
    static var API_PATH_DO_SHOP_ADD_TO_CART: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "doshop/product_list"
        default:
            return "api/doshop/product_list"
        }
    }
    static var API_PATH_ADD_TO_CART: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "doshop/cart_add/"
        default:
            return "api/doshop/cart_add/"
        }
    }
    
    static var API_PATH_PRODUCT_DETAIL: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "doshop/product_detail"
        default:
            return "api/doshop/product_detail"
        }
    }
    
    static var API_PATH_CART_LIST: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "doshop/cart_list/"
        default:
            return "api/doshop/cart_list/"
        }
    }
    
    static var API_PATH_DOSHOP_ADD_VOUCHER: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "doshop/add_voucher"
        default:
            return "api/doshop/add_voucher"
        }
    }
    
    static var API_PATH_ADDRESS_LIST: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "doshop/get_address"
        default:
            return "api/doshop/get_address"
        }
    }
    
    static var API_PATH_REMOVE_PRODUCT_CART: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "doshop/cart_remove/"
        default:
            return "api/doshop/cart_remove/"
        }
    }
    
    static var API_PATH_GET_LOCATION: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "doshop/get_location"
        default:
            return "api/doshop/get_location"
        }
    }
    
    static var API_PATH_DO_SHOP_SUBMIT_ORDER: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "doshop/submit_order"
        default:
            return "api/doshop/submit_order"
        }
    }
    
    static var API_PATH_GET_RAJA_ONGKIR_SUB_DISTRICT: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "api/subdistrict"
        default:
            return "api/subdistrict"
        }
    }
    
    static var API_PATH_ADD_ADDRESS: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "doshop/add_address"
        default:
            return "api/doshop/add_address"
        }
    }
    
    static var API_PATH_RAJA_ONGKIR_DELIVERY_COST: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "api/cost"
        default:
            return "api/cost"
        }
    }
    
    internal static func basicRajaOngkirRequest(URLString: URLConvertible,
                                                method: HTTPMethod = HTTPMethod.get,
                                                parameters: [String: Any]? = nil,
                                                headers: [String: String]? = nil,
                                                encoding: URLEncoding = URLEncoding.default,
                                                complete: @escaping (Bool, Any?, BaseError?)->()) {
        print("http post result ----")
        print("--- url = \(URLString)")
        print("--- params = \(parameters)")
        var headerParam: [String: String] = ["key": API_RAJA_ONGKIR_KEY]
        if let headers = headers {
            for (key, value) in headers {
                headerParam[key] = value
            }
        }
        print("--- need session = \(headerParam)")

        Alamofire.request(URLString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headerParam).responseJSON(completionHandler: {response in
            if let error = response.error as? URLError {
                if error.code == URLError.Code.notConnectedToInternet {
                    complete(false, nil, NotConnectedInternetError(statusCode: error.code.rawValue, title: "Connection Error", message: ""))
                }
                return
            }
            if let value = response.value, let jsonResult = value as? [String: Any], let rajaOngkirJson = jsonResult["rajaongkir"] as? [String: Any] {
                var code = -1
                var title = ""
                if let statusJson = rajaOngkirJson["status"] as? [String: Any] {
                    if let c = statusJson["code"] as? Int {
                        code = c
                    } else if let c = statusJson["code"] as? String {
                        if c.isNumber {
                            code = Int(c)!
                        }
                    }
                    if let desc = statusJson["description"] as? String {
                        title = desc
                    }
                }
                if code < 0 || code >= 400 {
                    complete(false, nil, UnknownError(statusCode: code, title: title, message: ""))
                } else {
                    complete(true, rajaOngkirJson, nil)
                }
            }
        })
    }
    
    internal static func basicAuthStringRequest(URLString: URLConvertible,
                                                parameters: [String: Any]? = nil,
                                                headers: [String: String]? = nil,
                                                complete: @escaping (Bool, Any?, BaseError?)->()) {
        let authReturn = NAuthReturn.authUser()
        if let authReturn = NAuthReturn.authUser(), let token = authReturn.token, let user = authReturn.user, let userId = user.id {
            var param: [String: Any] = [:]
            param["user_id"] = userId
            param["nyelam_token"] = token
            if let parameters = parameters {
                for (key, value) in parameters {
                    param[key] = value
                }
            }
            self.basicPostStringRequest(URLString: URLString, parameters: param, headers: nil, complete: complete)
        } else {
            complete(false, nil, UserNotFoundError(statusCode: -1, title: "User is either not login or token is expired", message: nil))
        }
    }
    
    internal static func basicAuthRequest(URLString: URLConvertible,
                                          parameters: [String: Any]? = nil,
                                          headers: [String: String]? = nil,
                                          complete: @escaping (Bool, Any?, BaseError?)->()) {
        if let authReturn = NAuthReturn.authUser(), let token = authReturn.token, let user = authReturn.user, let userId = user.id {
            var param: [String: Any] = [:]
            param["user_id"] = userId
            param["nyelam_token"] = token
            if let parameters = parameters {
                for (key, value) in parameters {
                    param[key] = value
                }
            }
            self.basicPostRequest(URLString: URLString, parameters: param, headers: nil, complete: complete)
        } else {
            complete(false, nil, UserNotFoundError(statusCode: -1, title: "User is either not login or token is expired", message: nil))
        }
    }
    internal static func basicUploadRequest(URLString: URLConvertible,
                                            multiparts: [String: Data]? = nil,
                                            parameters: [String: Any]? = nil,
                                            headers: [String: String]? = nil,
                                            complete: @escaping (Bool, Any?, BaseError?)->()) {
        print("http post result ----")
        print("--- url = \(URLString)")
        print("--- multiparts = \(multiparts)")
        print("--- headers = \(headers)")
        print("--- need session = \(headers)")
        if let authReturn = NAuthReturn.authUser(), let token = authReturn.token, let user = authReturn.user, let userId = user.id {
            var param: [String: Any] = [:]
            param["user_id"] = userId
            param["nyelam_token"] = token
            param[POST_API_VER] = String(API_VER)
            param[POST_APP_VER] = NConstant.appVersion
            param[POST_OS_VER] = NConstant.osVersion
            param[POST_DEVICE] = NConstant.deviceModel
            param[POST_TIMESTAMP] = String(NConstant.currentTimeStamp)
            param[POST_PLATFORM] = NConstant.platform
            
            if let parameters = parameters {
                for (key, value) in parameters {
                    param[key] = value
                }
            }
            
            print("--- parameters = \(param)")

            let headers: HTTPHeaders = [
                "Content-type": "multipart/form-data"
            ]
        
            Alamofire.upload(multipartFormData: {(multipartFormData) in
                if let multiparts = multiparts {
                    for (key, value) in multiparts {
                        multipartFormData.append(value, withName: key, fileName: "picture.jpg", mimeType: "image/jpeg")
                    }
                }
                for (key, value) in param {
                    if let value = value as? AnyObject {
                        multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }
            }, usingThreshold: UInt64.init(), to: URLString, method: .post, headers: headers, encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _) :
                    upload.responseString(completionHandler: { response in
                        if let error = response.error as? URLError {
                            if error.code == URLError.Code.notConnectedToInternet {
                                complete(false, nil, NotConnectedInternetError(statusCode: error.code.rawValue, title: "Connection Error", message: ""))
                            }
                            return
                        }
                        if let value = response.value {
                            let data = value.data(using: String.Encoding.utf8, allowLossyConversion: true)
                            do {
                                let jsonResult: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                                if let jsonResult = jsonResult as? [String: Any] {
                                    var status = -1
                                    if let s = jsonResult[KEY_STATUS] as? Int {
                                        status = s
                                    } else if let s = jsonResult[KEY_STATUS] as? String {
                                        if s.isNumber {
                                            status = Int(s)!
                                        }
                                    }
                                    if status < 0 {
                                        complete(false, nil, InvalidReturnValueError(statusCode: 200, title: "no json with key \"status\"", message: nil))
                                    }
                                    if status == STATUS_SUCCESS {
                                        if let _ = jsonResult[KEY_DATA] {
                                            if let jsonData = jsonResult[KEY_DATA] as? [String: Any] {
                                                complete(true, jsonData, nil)
                                            } else if let jsonString = jsonResult[KEY_DATA] as? String {
                                                do {
                                                    let data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                                    let jsonData: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                                                    complete(true, jsonData, nil)
                                                    return
                                                } catch {
                                                    print(error)
                                                }
                                            }
                                            complete(false, nil, UnknownError(statusCode: -1, title: "Unknown Error", message: ""))
                                        } else {
                                            complete(false, nil, InvalidReturnValueError(statusCode: 200, title: "no json with key \"data\"", message: nil))
                                        }
                                    } else if status == STATUS_INVALID_TOKEN {
                                        complete(false, nil, InvalidTokenError(statusCode: 200, title: "request status invalid token", message: nil))
                                    }
                                } else {
                                    complete(false, nil, UnknownError(statusCode: -1, title: "Unknown Error", message: ""))
                                }
                            } catch {
                                print(error)
                            }
                        }
                    })
                case .failure(let error):
                    if let error = error as? URLError {
                        if error.code == URLError.Code.notConnectedToInternet {
                            complete(false, nil, NotConnectedInternetError(statusCode: error.code.rawValue, title: "Connection Error", message: ""))
                        }
                    } else {
                        complete(false, nil, UnknownError(statusCode: -1, title: "Unknown Error", message: ""))
                    }
                }
            })
        } else {
            complete(false, nil, UserNotFoundError(statusCode: -1, title: "User is either not login or token is expired", message: nil))
        }
    }
    
    internal static func basicPostStringRequest(URLString: URLConvertible,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        complete: @escaping (Bool, Any?, BaseError?)->()) {
        print("http post result ----")
        print("--- url = \(URLString)")
        print("--- parameters = \(parameters)")
        print("--- headers = \(headers)")
        
        var param: [String: Any] = [:]
        param[POST_API_VER] = API_VER
        param[POST_APP_VER] = NConstant.appVersion
        param[POST_OS_VER] = NConstant.osVersion
        param[POST_DEVICE] = NConstant.deviceModel
        param[POST_TIMESTAMP] = String(NConstant.currentTimeStamp)
        param[POST_PLATFORM] = NConstant.platform
        
        if let parameters = parameters {
            for (key, value) in parameters {
                param[key] = value
            }
        }
        Alamofire.request(URLString, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: headers).responseString(completionHandler: {response in
            
            if let error = response.error as? URLError {
                if error.code == URLError.Code.notConnectedToInternet {
                    complete(false, nil, NotConnectedInternetError(statusCode: error.code.rawValue, title: "Connection Error", message: ""))
                }
                return
            }
            if let value = response.value {
                let data = value.data(using: String.Encoding.utf8, allowLossyConversion: true)
                do {
                    let jsonResult: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    if let jsonResult = jsonResult as? [String: Any] {
                        var status = -1
                        if let s = jsonResult[KEY_STATUS] as? Int {
                            status = s
                        } else if let s = jsonResult[KEY_STATUS] as? String {
                            if s.isNumber {
                                status = Int(s)!
                            }
                        }
                        if status < 0 {
                            complete(false, nil, InvalidReturnValueError(statusCode: 200, title: "no json with key \"status\"", message: nil))
                        }
                        if status == STATUS_SUCCESS {
                            if let _ = jsonResult[KEY_DATA] {
                                if let jsonData = jsonResult[KEY_DATA] as? [String: Any] {
                                    complete(true, jsonData, nil)
                                } else if let jsonString = jsonResult[KEY_DATA] as? String {
                                    do {
                                        let data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                        let jsonData: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                                        complete(true, jsonData, nil)
                                        return
                                    } catch {
                                        print(error)
                                    }
                                }
                                complete(false, nil, UnknownError(statusCode: -1, title: "Unknown Error", message: ""))
                            } else {
                                complete(false, nil, InvalidReturnValueError(statusCode: 200, title: "no json with key \"data\"", message: nil))
                            }
                        } else if status == STATUS_INVALID_TOKEN {
                            complete(false, nil, InvalidTokenError(statusCode: 200, title: "request status invalid token", message: nil))
                        }
                    } else {
                        complete(false, nil, UnknownError(statusCode: -1, title: "Unknown Error", message: ""))
                    }
                } catch {
                    print(error)
                    complete(false, nil, UnknownError(statusCode: -1, title: error.localizedDescription, message: ""))
                }
            }
        })
    }
    internal static func basicPostRequest(URLString: URLConvertible,
                                          parameters: [String: Any]? = nil,
                                          headers: [String: String]? = nil,
                                          complete: @escaping (Bool, Any?, BaseError?)->()) {
        print("http post result ----")
        print("--- url = \(URLString)")
        print("--- parameters = \(parameters)")
        print("--- headers = \(headers)")
        
        var param: [String: Any] = [:]
        param[POST_API_VER] = API_VER
        param[POST_APP_VER] = NConstant.appVersion
        param[POST_OS_VER] = NConstant.osVersion
        param[POST_DEVICE] = NConstant.deviceModel
        param[POST_TIMESTAMP] = String(NConstant.currentTimeStamp)
        param[POST_PLATFORM] = NConstant.platform

        if let parameters = parameters {
            for (key, value) in parameters {
                param[key] = value
            }
        }
        Alamofire.request(URLString, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: headers).responseJSON(completionHandler: {response in
            if let error = response.error as? URLError {
                if error.code == URLError.Code.notConnectedToInternet {
                    complete(false, nil, NotConnectedInternetError(statusCode: error.code.rawValue, title: "Connection Error", message: ""))
                }
                return
            }
            
            if let value = response.value, let jsonResult = value as? [String: Any] {
                var status = -1
                if let s = jsonResult[KEY_STATUS] as? Int {
                    status = s
                } else if let s = jsonResult[KEY_STATUS] as? String {
                    if s.isNumber {
                        status = Int(s)!
                    }
                }
                if status < 0 {
                    complete(false, nil, InvalidReturnValueError(statusCode: 200, title: "no json with key \"status\"", message: nil))
                }
                if status == STATUS_SUCCESS {
                    if let _ = jsonResult[KEY_DATA] {
                        if let jsonData = jsonResult[KEY_DATA] as? [String: Any] {
                            complete(true, jsonData, nil)
                            return
                        } else if let jsonString = jsonResult[KEY_DATA] as? String {
                            do {
                                let data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                let jsonData: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                                complete(true, jsonData, nil)
                                return
                            } catch {
                                print(error)
                            }
                        }
                        complete(false, nil, UnknownError(statusCode: -1, title: "Unknown Error", message: ""))
                    } else {
                        complete(false, nil, InvalidReturnValueError(statusCode: 200, title: "no json with key \"data\"", message: nil))
                    }
                } else if status == STATUS_INVALID_TOKEN {
                    complete(false, nil, InvalidTokenError(statusCode: 200, title: "request status invalid token", message: nil))
                } else if status == STATUS_FAILED {
                    var title = jsonResult[KEY_MESSAGE] as? String
                    var code = -1
                    if let codeNumber = jsonResult[KEY_CODE] as? Int {
                        code = codeNumber
                    } else if let codeNumber = jsonResult[KEY_CODE] as? String {
                        if codeNumber.isNumber {
                            code = Int(codeNumber)!
                        }
                    }
                    complete(false, nil, StatusFailedError(statusCode: code, title: title != nil ? title : "Unknown Error", message: nil))
                }
            } else {
                complete(false, nil, UnknownError(statusCode: -1, title: "Unknown Error", message: ""))
            }
        })
    }
}

enum NURLType {
    case production
    case staging
    case development
}

public class BaseError: NSObject {
    var statusCode: Int
    var title: String?
    var message: String?
    
    init(statusCode: Int, title: String?, message: String?) {
        self.statusCode = statusCode
        self.title = title
        self.message = message
    }
}
class UnknownError: BaseError {
    override init(statusCode: Int, title: String?, message: String?) {
        super.init(statusCode: statusCode, title: title, message: message)
    }
}
class CartExpiredError: BaseError {
    override init(statusCode: Int, title: String?, message: String?) {
        super.init(statusCode: statusCode, title: title, message: message)
    }
}

class InvalidReturnValueError: BaseError {
    override init(statusCode: Int, title: String?, message: String?) {
        super.init(statusCode: statusCode, title: title, message: message)
    }
}

class StatusFailedError: BaseError {
    override init(statusCode: Int, title: String?, message: String?) {
        super.init(statusCode: statusCode, title: title, message: message)
    }
}

class InvalidTokenError: BaseError {
    override init(statusCode: Int, title: String?, message: String?) {
        super.init(statusCode: statusCode, title: title, message: message)
    }
}

class NotConnectedInternetError: BaseError {
    override init(statusCode: Int, title: String?, message: String?) {
        super.init(statusCode: statusCode, title: title, message: message)
    }
}

class UserNotFoundError: BaseError {
    override init(statusCode: Int, title: String?, message: String?) {
        super.init(statusCode: statusCode, title: title, message: message)
    }
}

