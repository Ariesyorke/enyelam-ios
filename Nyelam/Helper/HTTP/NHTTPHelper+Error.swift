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
    
    internal let HOST_URL = { () -> String in
        switch NConstant.URL_TYPE {
        case .staging:
            return "http://nyelam.dantech.id/"
        case .development:
            return "http://nyelam-adam.dantech.id/"
        default:
            return "https://api.e-nyelam.com/"
        }
    }
    
    internal let API_PATH_LOGIN = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "user/login"
        default:
            return "api/user/login"
        }
    }
    
    internal let API_PATH_UPDATE_VERSION = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "master/UpdateVersion"
        default:
            return "api/master/UpdateVersion"
        }
    }
    
    internal let API_PATH_SOCMED_LOGIN = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "user/socmedlogin"
        default:
            return "api/user/socmedlogin"
        }
    }
    
    internal let API_PATH_REGISTER = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "user/register"
        default:
            return "api/user/register"
        }
    }
    
    internal let API_PATH_FORGOT_PASSWORD = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "user/forgotpass"
        default:
            return "api/user/forgotpass"
        }
    }
    
    internal let API_PATH_MASTER_COUNTRY = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "master/country"
        default:
            return "api/master/country"
        }
    }
    
    internal let API_PATH_MASTER_NATIONALITY = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "master/nationality"
        default:
            return "api/master/nationality"
        }
    }
    
    internal let API_PATH_MASTER_LANGUAGE = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "master/language"
        default:
            return "api/master/language"
        }
    }
    
    internal let API_PATH_MASTER_CATEGORY = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "service/masterCategory"
        default:
            return "api/service/masterCategory"
        }
    }
    
    internal let API_PATH_MASTER_DO_DIVE_SEARCH = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "master/dodive/search"
        default:
            return "api/master/dodive/search"
        }
    }
    
    internal let API_PATH_SUGGESTION_SERVICE = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "dodive/sugestion"
        default:
            return "api/dodive/sugestion"
        }
    }
    
    internal let API_PATH_SEARCH_SERVICE_LIST = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "service/serviceList"
        default:
            return "api/service/serviceList"
        }
    }
    
    internal let API_PATH_SEARCH_SERVICE_LIST_BY_DIVESPOT = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "service/serviceDivespotList"
        default:
            return "api/service/serviceDivespotList"
        }
    }
    
    internal let API_PATH_SEARCH_SERVICE_LIST_BY_CATEGORY = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "service/serviceCategoryList"
        default:
            return "api/service/serviceCategoryList"
        }
    }
    
    internal let API_PATH_SEARCH_SERVICE_LIST_BY_PROVINCE = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "service/serviceProvinceList"
        default:
            return "api/service/serviceProvinceList"
        }
    }
    
    internal let API_PATH_SEARCH_SERVICE_LIST_BY_CITY = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "service/serviceCityList"
        default:
            return "api/service/serviceCityList"
        }
    }
    
    internal let API_PATH_HOMEPAGE_MODULES = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "master/homepage"
        default:
            return "api/master/homepage"
        }
    }
    internal let API_PATH_DO_DIVE_DETAIL_SERVICE = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "service/detailService"
        default:
            return "api/service/detailService"
        }
    }
    internal let API_PATH_BOOK_SERVICE_CART = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "order/bookservicecart"
        default:
            return "api/order/bookservicecart"
        }
    }
    internal let API_PATH_BOOK_GET_PARTICIPANTS = { () -> String in        switch NConstant.URL_TYPE {
        case .production:
            return "order/getSavedParticipants"
        default:
            return "api/order/getSavedParticipants"
        }
    }
    internal let API_PATH_SUBMIT_ORDER = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "order/submit"
        default:
            return "api/order/submit"
        }
    }
    internal let API_PATH_BOOKING_HISTORY = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "order/orderList"
        default:
            return "api/order/orderList"
        }
    }
    internal let API_PATH_BOOKING_DETAIL = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "order/detail"
        default:
            return "api/order/detail"
        }
    }
    internal let API_PATH_DIVE_CENTER_DETAIL = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "divecenter/detail"
        default:
            return "api/divecenter/detail"
        }
    }
    internal let API_PATH_DIVE_SPOT_DETAIL = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "divespot/detail"
        default:
            return "api/divespot/detail"
        }
    }
    
    internal let API_PATH_UPLOAD_PAYMENT_PROOF = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "order/paymentProof"
        default:
            return "api/order/paymentProof"
        }
    }
    
    internal let API_PATH_CHANGE_PASSWORD = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "user/changepass"
        default:
            return "api/user/changepass"
        }
    }
    
    internal let API_PATH_UPDATE_PROFILE = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "user/profile/edit"
        default:
            return "api/user/profile/edit"
        }
    }
    internal let API_PATH_UPDATE_PHOTO = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "user/photo"
        default:
            return "api/user/photo"
        }
    }
    internal let API_PATH_UPLOAD_COVER = { () -> String in
        switch NConstant.URL_TYPE {
        case .production:
            return "user/cover"
        default:
            return "api/user/cover"
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
