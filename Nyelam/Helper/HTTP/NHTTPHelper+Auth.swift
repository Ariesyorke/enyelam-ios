//
//  NHTTPHelper+Auth.swift
//  Nyelam
//
//  Created by Bobi on 4/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire
import AlamofireImage

extension NHTTPHelper {
    //LOGIN REQUEST
    static func httpLogin(email: String, password: String, complete: @escaping (NHTTPResponse<NAuthReturn>)->()) {
        self.basicPostRequest(URLString: HOST_URL + API_PATH_LOGIN,
                              parameters: ["email": email, "password": password.md5],
                              headers: nil,
                              complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                NAuthReturn.deleteAllAuth()
                let authReturn = NAuthReturn()
                authReturn.parse(json: json)
                complete(NHTTPResponse(resultStatus: true, data: authReturn, error: nil))
            }
        })
    }
    
    static func httpLoginSocmed(email: String?, type: String, id: String, accessToken: String, complete: @escaping (NHTTPResponse<NAuthReturn>)->()) {
        var param: [String: Any] = [:]
        if let email = email {
            param["email_address"] = email
        }
        param["type"] = type
        param["id"] = id
        param["access_token"] = accessToken
        self.basicPostRequest(URLString: HOST_URL + API_PATH_SOCMED_LOGIN,
                              parameters: param,
                              headers: nil,
                              complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    _ = NAuthReturn.deleteAllAuth()
                                    let authReturn = NAuthReturn()
                                    authReturn.parse(json: json)
                                    complete(NHTTPResponse(resultStatus: true, data: authReturn, error: nil))
                                }
        })
    }
    
    static func httpRegister(fullname: String, email: String, password: String, confirmPassword: String,
                         phoneNumber: String?, countryCodeId: String?, gender: String?,
                         socmedType: String?, socmedId: String?, socmedAccessToken: String?, picture: String?,  complete: @escaping (NHTTPResponse<NAuthReturn>)->()) {
        var param: [String: Any] = [:]
        param["fullname"] = fullname
        param["email"] = email
        param["password"] = password.md5
        param["confirm_password"] = confirmPassword.md5
        if let phoneNumber = phoneNumber {
            param["phone"] = phoneNumber
        }
        if let countryCodeId = countryCodeId {
            param["country_id"] = countryCodeId
        }
        if let gender = gender {
            param["gender"] = gender
        }
        if let socmedType = socmedType {
            param["socmed_type"] = socmedType
        }
        if let socmedId = socmedId {
            param["id"] = socmedId
        }
        if let socmedAccessToken = socmedAccessToken {
            param["access_token"] = socmedAccessToken
        }
        if let picture = picture {
            param["picture"] = picture
        }
        self.basicPostRequest(URLString: HOST_URL + API_PATH_REGISTER,
                              parameters: param, headers: nil, complete: {
            status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    _ = NAuthReturn.deleteAllAuth()
                                    let authReturn = NAuthReturn()
                                    authReturn.parse(json: json)
                                    complete(NHTTPResponse(resultStatus: true, data: authReturn, error: nil))
                                }
        })
    }
    
    static func httpForgotPassword(email: String, complete: @escaping (NHTTPResponse<Bool>)->()) {
        self.basicPostRequest(URLString: HOST_URL + API_PATH_FORGOT_PASSWORD, parameters: ["email": email], headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                if let success = json["exist"] as? Bool {
                    complete(NHTTPResponse(resultStatus: true, data: success, error: nil))
                } else if let success = json["exist"] as? String {
                    complete(NHTTPResponse(resultStatus: true, data: success.toBool, error: nil))
                }
            }
        })
    }
    
}
