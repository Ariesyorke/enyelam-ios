//
//  NHTTPHelper+Account.swift
//  Nyelam
//
//  Created by Bobi on 4/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

extension NHTTPHelper {
    static func httpChangePassword(currentPassword: String, newPasword: String, confirmNewPassword: String, complete: @escaping (NHTTPResponse<Bool>)->()) {
        self.basicAuthRequest(URLString: HOST_URL+API_PATH_CHANGE_PASSWORD,
                              parameters: ["current_password": currentPassword.md5,
                                           "new_password": newPasword.md5,
                                           "confirm_password": confirmNewPassword.md5],
                              headers: nil,
                              complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    var success: Bool = false
                                    if let changed = json["changed"] as? Bool {
                                        success = changed
                                    } else if let changed = json["changed"] as? String {
                                        success = changed.toBool
                                    }
                                    complete(NHTTPResponse(resultStatus: true, data: success, error: nil))
                                }
        })
    }
    static func httpUploadCover(data: Data, complete: @escaping (NHTTPResponse<NAuthReturn>)->()) {
        self.basicUploadRequest(URLString: HOST_URL+API_PATH_UPLOAD_COVER, multiparts: ["file": data], parameters: nil, headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                NAuthReturn.deleteAllAuth()
                let authReturn = NAuthReturn.init(entity: NSEntityDescription.entity(forEntityName: "NAuthReturn", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                authReturn.parse(json: json)
                complete(NHTTPResponse(resultStatus: true, data: authReturn, error: nil))
            }
        })
    }
    
    static func httpUploadPhotoProfile(data: Data, complete: @escaping (NHTTPResponse<NAuthReturn>)->()) {
        self.basicUploadRequest(URLString: HOST_URL+API_PATH_UPDATE_PHOTO, multiparts: ["file": data], parameters: nil, headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                NAuthReturn.deleteAllAuth()
                let authReturn = NAuthReturn.init(entity: NSEntityDescription.entity(forEntityName: "NAuthReturn", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                authReturn.parse(json: json)
                complete(NHTTPResponse(resultStatus: true, data: authReturn, error: nil))
            }
        })
    }
    
    static func httpUpdateProfile(fullname: String, username: String?, gender: String?, birthDate: Date?,
                                  countryCodeId: String?, phoneNumber: String?,
                                  certificateDate: Date?, certificateNumber: String?, birthPlace: String?,
                                  countryId: String?, nationalityId: String?, languageId: String?, complete: @escaping (NHTTPResponse<NAuthReturn>)->()) {
        var param: [String: Any] = [:]
        param["fullname"] = fullname
        if let username = username {
            param["username"] = username
        }
        if let gender = gender {
            param["gender"] = gender
        }
        if let birthDate = birthDate {
            param["birth_date"] = String(birthDate.timeIntervalSince1970)
        }
        if let countryCodeId = countryCodeId {
            param["country_code"] = countryCodeId
        }
        if let phoneNumber = phoneNumber {
            param["phone_number"] = phoneNumber
        }
        if let certificateDate = certificateDate {
            param["certificate_date"] = String(certificateDate.timeIntervalSince1970)
        }
        if let certificateNumber = certificateNumber {
            param["certificate_number"] = certificateNumber
        }
        if let birthPlace = birthPlace {
            param["birth_place"] = birthPlace
        }
        if let countryId = countryId {
            param["country_id"] = countryId
        }
        if let nationalityId = nationalityId {
            param["nationality_id"] = nationalityId
        }
        if let languageId = languageId {
            param["language_id"] = languageId
        }
        self.basicAuthRequest(URLString: HOST_URL+API_PATH_UPDATE_PROFILE,
                              parameters: param,
                              headers: nil,
                              complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    NAuthReturn.deleteAllAuth()
                                    let authReturn = NAuthReturn.init(entity: NSEntityDescription.entity(forEntityName: "NAuthReturn", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                    authReturn.parse(json: json)
                                    complete(NHTTPResponse(resultStatus: true, data: authReturn, error: nil))
                                }

        })
    }
    
}
