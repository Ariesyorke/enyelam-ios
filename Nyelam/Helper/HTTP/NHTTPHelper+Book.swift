//
//  NHTTPHelper+Book.swift
//  Nyelam
//
//  Created by Bobi on 4/6/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

extension NHTTPHelper {
    static func httpUploadPaymentProof(data: Data, bookingDetailId: String, complete: @escaping(NHTTPResponse<Bool>)->()) {
        self.basicUploadRequest(URLString: HOST_URL + API_PATH_UPLOAD_PAYMENT_PROOF,
                                multiparts: ["file":data],
                                parameters: ["order_id": bookingDetailId],
                                headers: nil,
                                complete: {status, data, error in
                                    if let error = error {
                                        complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                        return
                                    }
                                    if let data = data, let json = data as? [String: Any] {
                                        var success: Bool = false
                                        if let suc = json["success"] as? Bool {
                                            success = suc
                                        } else if let suc = json["success"] as? String {
                                            success = suc.toBool
                                        }
                                        complete(NHTTPResponse(resultStatus: true, data: success, error: nil))
                                    }
        })
    }
    static func httpBookService(diveCenterId: String, diveServiceId: String, diver: Int, schedule: Date, type: Int, complete: @escaping(NHTTPResponse<CartReturn>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_BOOK_SERVICE_CART,
                              parameters: ["dive_service_id": diveServiceId,
                                           "dive_center_id": diveCenterId,
                                           "diver": String(diver),
                                           "type": String(type),
                                           "schedule": String(schedule.timeIntervalSince1970)],
                              headers: nil,
                              complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    let cartReturn = CartReturn(json: json)
                                    complete(NHTTPResponse(resultStatus: true, data: cartReturn, error: nil))
                                }


        })
    }
    
    static func changePaymentMethod(cartToken: String, paymentType: Int, complete: @escaping(NHTTPResponse<CartReturn>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_CHANGE_PAYMENT_METHOD,
                              parameters: ["cart_token": cartToken,
                                           "type":String(paymentType)],
                              headers: nil,
                              complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                let cartReturn = CartReturn(json: json)
                complete(NHTTPResponse(resultStatus: true, data: cartReturn, error: nil))
            }
        })
    }
    
    static func httpGetSavedParticipant(complete: @escaping (NHTTPResponse<[Participant]>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_BOOK_GET_PARTICIPANTS, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var participants: [Participant]? = nil
                if let participantArray = json["participants"] as? Array<[String: Any]>, !participantArray.isEmpty {
                    participants = []
                    for participantJson in participantArray {
                        let participant = Participant(json: participantJson)
                        participants!.append(participant)
                    }
                } else if let participantString = json["participants"] as? String {
                    do {
                        let data = participantString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let participantArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        participants = []
                        for participantJson in participantArray {
                            let participant = Participant(json: participantJson)
                            participants!.append(participant)
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: participants, error: nil))
            }
        })
    }
    
    static func httpOrderSubmit(cartToken: String, contactJson: String, diverJson: String, paymentMethodType: String, note: String?, complete: @escaping (NHTTPResponse<OrderReturn>)->()) {
        var param: [String: Any] = [:]
        param["cart_token"] = cartToken
        param["contact"] = contactJson
        param["diver"] = diverJson
        param["type"] = paymentMethodType
        if let note = note {
            param["note"] = note
        }
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_SUBMIT_ORDER, parameters: param, headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                let order = OrderReturn(json: json)
                complete(NHTTPResponse(resultStatus: true, data: order, error: nil))
            }
        })
    }
    
    static func httpResubmitOrder(orderId: String, paymentType: Int, complete: @escaping (NHTTPResponse<OrderReturn>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_SUBMIT_ORDER,
                              parameters: [
                                "order_id": orderId,
                                "payment_type": String(paymentType)
                                ],
                              headers: nil,
                              complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                let order = OrderReturn(json: json)
                complete(NHTTPResponse(resultStatus: true, data: order, error: nil))
            }
        })

    }
    static func httpBookingHistory(page: String, type: String, complete: @escaping(NHTTPResponse<[NSummary]>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_BOOKING_HISTORY,
                              parameters: ["page":page, "type": type], headers: nil,
                              complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    var summaries: [NSummary]? = nil
                                    if let summaryArray = json["summary"] as? Array<[String: Any]>, !summaryArray.isEmpty {
                                        summaries = []
                                        for summaryJson in summaryArray {
                                            var summary: NSummary? = nil
                                            if let id = summaryJson["id"] as? String {
                                                summary = NSummary.getSummary(using: id)
                                            }
                                            if summary == nil {
                                                summary = NSummary.init(entity: NSEntityDescription.entity(forEntityName: "NSummary", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                            }
                                            summary!.parse(json: summaryJson)
                                            summaries!.append(summary!)
                                        }
                                    } else if let summaryString = json["summary"] as? String {
                                        do {
                                            let data = summaryString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                            let summaryArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                                            summaries = []
                                            for summaryJson in summaryArray {
                                                var summary: NSummary? = nil
                                                if let id = summaryJson["id"] as? String {
                                                    summary = NSummary.getSummary(using: id)
                                                }
                                                if summary == nil {
                                                    summary = NSummary.init(entity: NSEntityDescription.entity(forEntityName: "NSummary", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                                                }
                                                summary!.parse(json: summaryJson)
                                                summaries!.append(summary!)
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    complete(NHTTPResponse(resultStatus: true, data: summaries, error: nil))
                                }

                                
        })
    }
}

