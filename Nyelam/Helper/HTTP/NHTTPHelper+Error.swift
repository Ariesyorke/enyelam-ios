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
    
    internal static var HOST_URL: String {
        switch NConstant.URL_TYPE {
        case .staging:
            return "http://nyelam.dantech.id/"
        case .development:
            return "http://nyelam-adam.dantech.id/"
        default:
            return "https://api.e-nyelam.com/"
        }
    }
    
    internal static var API_PATH_LOGIN: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/login"
        default:
            return "api/user/login"
        }
    }
    
    internal static var API_PATH_UPDATE_VERSION: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "master/UpdateVersion"
        default:
            return "api/master/UpdateVersion"
        }
    }
    
    internal static var API_PATH_SOCMED_LOGIN: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/socmedlogin"
        default:
            return "api/user/socmedlogin"
        }
    }
    
    internal static var API_PATH_REGISTER: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/register"
        default:
            return "api/user/register"
        }
    }
    
    internal static var API_PATH_FORGOT_PASSWORD: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/forgotpass"
        default:
            return "api/user/forgotpass"
        }
    }
    
    internal static var API_PATH_MASTER_COUNTRY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "master/country"
        default:
            return "api/master/country"
        }
    }
    
    internal static var API_PATH_MASTER_NATIONALITY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "master/nationality"
        default:
            return "api/master/nationality"
        }
    }
    
    internal static var API_PATH_MASTER_LANGUAGE: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "master/language"
        default:
            return "api/master/language"
        }
    }
    
    internal static var API_PATH_MASTER_CATEGORY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "service/masterCategory"
        default:
            return "api/service/masterCategory"
        }
    }
    
    internal static var API_PATH_MASTER_DO_DIVE_SEARCH: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "master/dodive/search"
        default:
            return "api/master/dodive/search"
        }
    }
    
    internal static var API_PATH_SUGGESTION_SERVICE: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "dodive/sugestion"
        default:
            return "api/dodive/sugestion"
        }
    }
    
    internal static var API_PATH_SEARCH_SERVICE_LIST_BY_DIVE_CENTER: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "service/serviceList"
        default:
            return "api/service/serviceList"
        }
    }
    
    internal static var API_PATH_SEARCH_SERVICE_LIST_BY_DIVESPOT: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "service/serviceDivespotList"
        default:
            return "api/service/serviceDivespotList"
        }
    }
    
    internal static var API_PATH_SEARCH_SERVICE_LIST_BY_CATEGORY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "service/serviceCategoryList"
        default:
            return "api/service/serviceCategoryList"
        }
    }
    
    internal static var API_PATH_SEARCH_SERVICE_LIST_BY_PROVINCE: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "service/serviceProvinceList"
        default:
            return "api/service/serviceProvinceList"
        }
    }
    
    internal static var API_PATH_SEARCH_SERVICE_LIST_BY_CITY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "service/serviceCityList"
        default:
            return "api/service/serviceCityList"
        }
    }
    
    internal static var API_PATH_HOMEPAGE_MODULES: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "master/homepage"
        default:
            return "api/master/homepage"
        }
    }
    internal static var API_PATH_DETAIL_SERVICE: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "service/detailService"
        default:
            return "api/service/detailService"
        }
    }
    internal static var API_PATH_BOOK_SERVICE_CART: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "order/bookservicecart"
        default:
            return "api/order/bookservicecart"
        }
    }
    internal static var API_PATH_BOOK_GET_PARTICIPANTS: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "order/getSavedParticipants"
        default:
            return "api/order/getSavedParticipants"
        }
    }
    internal static var API_PATH_SUBMIT_ORDER: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "order/submit"
        default:
            return "api/order/submit"
        }
    }
    internal static var API_PATH_BOOKING_HISTORY: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "order/orderList"
        default:
            return "api/order/orderList"
        }
    }
    internal static var API_PATH_BOOKING_DETAIL: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "order/detail"
        default:
            return "api/order/detail"
        }
    }
    internal static var API_PATH_DIVE_CENTER_DETAIL: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "divecenter/detail"
        default:
            return "api/divecenter/detail"
        }
    }
    internal static var API_PATH_DIVE_SPOT_DETAIL: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "divespot/detail"
        default:
            return "api/divespot/detail"
        }
    }
    
    internal static var API_PATH_UPLOAD_PAYMENT_PROOF: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "order/paymentProof"
        default:
            return "api/order/paymentProof"
        }
    }
    
    internal static var API_PATH_CHANGE_PASSWORD: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/changepass"
        default:
            return "api/user/changepass"
        }
    }
    
    internal static var API_PATH_UPDATE_PROFILE: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/profile/edit"
        default:
            return "api/user/profile/edit"
        }
    }
    internal static var API_PATH_UPDATE_PHOTO: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/photo"
        default:
            return "api/user/photo"
        }
    }
    internal static var API_PATH_UPLOAD_COVER: String {
        switch NConstant.URL_TYPE {
        case .production:
            return "user/cover"
        default:
            return "api/user/cover"
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
            self.basicAuthRequest(URLString: URLString, parameters: parameters, headers: nil, complete: complete)
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
        print("--- parameters = \(parameters)")
        print("--- multiparts = \(multiparts)")
        print("--- headers = \(headers)")
        print("--- need session = \(headers)")
        if let authReturn = NAuthReturn.authUser(), let token = authReturn.token, let user = authReturn.user, let userId = user.id {
            var param: [String: Any] = [:]
            param["user_id"] = userId
            param["nyelam_token"] = token
            param[POST_API_VER] = API_VER
            param[POST_APP_VER] = NConstant.appVersion
            param[POST_OS_VER] = NConstant.osVersion
            param[POST_DEVICE] = NConstant.deviceModel
            param[POST_TIMESTAMP] = String(NConstant.currentTimeStamp)
            if let parameters = parameters {
                for (key, value) in parameters {
                    param[key] = value
                }
            }
            let headers: HTTPHeaders = [
                "Content-type": "multipart/form-data"
            ]
            
            Alamofire.upload(multipartFormData: {(multipartFormData) in
                if let multiparts = multiparts {
                    for (_, value) in multiparts {
                        multipartFormData.append(value, withName: "picture", fileName: "picture" + value.extensionTypeForImageData, mimeType: value.contentTypeForImageData)
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
                    upload.responseJSON(completionHandler: {response in
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
                }
            } else {
                print("Panggil 18")
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
