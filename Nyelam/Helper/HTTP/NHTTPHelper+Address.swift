//
//  NHTTPHelper+Address.swift
//  Nyelam
//
//  Created by Bobi on 11/8/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

extension NHTTPHelper {
    static func httpAddressListRequest(type: String, complete: @escaping (NHTTPResponse<[NAddress]>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_ADDRESS_LIST, parameters: ["type": type], headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var addresses: [NAddress]? = nil
                if let addressesArray = json["address"] as? Array<[String: Any]>, !addressesArray.isEmpty {
                    addresses = []
                    for addressJson in addressesArray {
                        var address: NAddress? = nil
                        if let id = addressJson["address_id"] as? String {
                            address = NAddress.getAddress(using: id)
                        }
                        if address == nil {
                            address = NAddress.init(entity: NSEntityDescription.entity(forEntityName: "NAddress", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                        }
                        address!.parse(json: addressJson)
                        addresses!.append(address!)
                    }
                } else if let addressesArrayString = json["address"] as? String {
                    do {
                        addresses = []
                        let data = addressesArrayString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let addressesArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        for addressJson in addressesArray {
                            var address: NAddress? = nil
                            if let id = addressJson["address_id"] as? String {
                                address = NAddress.getAddress(using: id)
                            }
                            if address == nil {
                                address = NAddress.init(entity: NSEntityDescription.entity(forEntityName: "NAddress", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                            }
                            address!.parse(json: addressJson)
                            addresses!.append(address!)
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: addresses, error: nil))
            }

        })
    }
    
    static func httpEditAddressRequest(addressId: String,
                                       emailAddress: String,
                                       fullname: String,
                                       address: String,
                                       phoneNumber: String,
                                       provinceId: String,
                                       provinceName: String,
                                       cityId: String,
                                       cityName: String,
                                       districtId: String,
                                       districtName: String,
                                       defaultBill: Int,
                                       defaultShip: Int,
                                       zipCode: String?,
                                       label: String?,
                                       complete: @escaping (NHTTPResponse<[NAddress]>)->()) {
        var param: [String: Any] = ["address_id": addressId,
                                    "email": emailAddress,
                                    "fullname": fullname,
                                    "address": address,
                                    "phone_number":phoneNumber,
                                    "province_id": provinceId,
                                    "province_name": provinceName,
                                    "city_id": cityId,
                                    "city_name": cityName,
                                    "district_id": districtId,
                                    "district_name": districtName,
                                    "default_bill": String(defaultBill),
                                    "default_ship": String(defaultShip)]
        if let zipCode = zipCode, !zipCode.isEmpty {
            param["zip_code"] = zipCode
        }
        if let label = label, !label.isEmpty {
            param["label"] = label
        }
    }
    
    static func httpAddAddressRequest(emailAddress: String,
                                      fullname: String,
                                      address: String,
                                      phoneNumber: String,
                                      provinceId: String,
                                      provinceName: String,
                                      cityId: String,
                                      cityName: String,
                                      districtId: String,
                                      districtName: String,
                                      defaultBill: Int,
                                      defaultShip: Int,
                                      zipCode: String?,
                                      label: String?,
                                      complete: @escaping (NHTTPResponse<[NAddress]>)->()) {
        var param: [String: Any] = ["email": emailAddress,
                                    "fullname": fullname,
                                    "address": address,
                                    "phone_number":phoneNumber,
                                    "province_id": provinceId,
                                    "province_name": provinceName,
                                    "city_id": cityId,
                                    "city_name": cityName,
                                    "district_id": districtId,
                                    "district_name": districtName,
                                    "default_bill": String(defaultBill),
                                    "default_ship": String(defaultShip)]
        if let zipCode = zipCode, !zipCode.isEmpty {
            param["zip_code"] = zipCode
        }
        if let label = label, !label.isEmpty {
            param["label"] = label
        }
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_ADD_ADDRESS, parameters: param, headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var addresses: [NAddress]? = nil
                if let addressesArray = json["address"] as? Array<[String: Any]>, !addressesArray.isEmpty {
                    addresses = []
                    for addressJson in addressesArray {
                        var address: NAddress? = nil
                        if let id = addressJson["address_id"] as? String {
                            address = NAddress.getAddress(using: id)
                        }
                        if address == nil {
                            address = NAddress.init(entity: NSEntityDescription.entity(forEntityName: "NAddress", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                        }
                        address!.parse(json: addressJson)
                        addresses!.append(address!)
                    }
                } else if let addressesArrayString = json["address"] as? String {
                    do {
                        addresses = []
                        let data = addressesArrayString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let addressesArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        for addressJson in addressesArray {
                            var address: NAddress? = nil
                            if let id = addressJson["address_id"] as? String {
                                address = NAddress.getAddress(using: id)
                            }
                            if address == nil {
                                address = NAddress.init(entity: NSEntityDescription.entity(forEntityName: "NAddress", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                            }
                            address!.parse(json: addressJson)
                            addresses!.append(address!)
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: addresses, error: nil))
            }
        })
    }
                                      
}
