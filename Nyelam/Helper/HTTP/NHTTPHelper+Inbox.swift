//
//  NHTTPHelper+Inbox.swift
//  Nyelam
//
//  Created by Bobi on 9/17/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

extension NHTTPHelper {
    static func httpGetInbox(page: Int, complete: @escaping (NHTTPResponse<[Inbox]>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_GET_INBOX, 
            parameters: ["page": String(page)], headers: nil, complete: {status, data, error in
                if let error = error {
                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                    return
                }
                if let data = data, let json = data as? [String: Any] {
                    var inboxes: [Inbox]? = nil
                    if let inboxArray = json["inbox_datas"] as? Array<[String: Any]>, !inboxArray.isEmpty {
                        inboxes = []
                        for inboxJson in inboxArray {
                            let inbox = Inbox(json: inboxJson)
                            inboxes!.append(inbox)
                        }
                    } else if let inboxString = json["inbox_datas"] as? String {
                        do {
                            let data = inboxString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                            let inboxArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                            inboxes = []
                            for inboxJson in inboxArray {
                                let inbox = Inbox(json: inboxJson)
                                inboxes!.append(inbox)
                            }
                        } catch {
                            print(error)
                        }
                    }
                    complete(NHTTPResponse(resultStatus: true, data: inboxes, error: nil))
                }
        })
    }
    
    static func httpGetInboxDetail(page: Int, inboxId: String, complete: @escaping (NHTTPResponse<Inbox>)->()) {
        self.basicAuthRequest(URLString: HOST_URL + API_PATH_INBOX_DETAIL, parameters: ["page": String(page), "ticket_id": inboxId],
                              headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var inbox: Inbox? = nil
                
                if let detailJson = json["detail"] as? [String: Any] {
                    inbox = Inbox(json: detailJson)
                } else if let detailString = json["detail"] as? String {
                    do {
                        let data = detailString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let detailJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        inbox = Inbox(json: detailJson)
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: inbox, error: nil))
            }
        })
    }
    
    static func httpPostInbox(subjectName: String, subjectDetail: String, attachment: Data?, inboxType: Int, refId: String?,
                              complete: @escaping (NHTTPResponse<Bool>)->()) {
        var param: [String: Any] = ["subject_name": subjectName, "subject_detail": subjectDetail, "inbox_type": String(inboxType)]
        if let refId = refId {
            param["ref_id"] = refId
        }
        var multipartParam: [String: Data]? = nil
        if let attachment = attachment {
            multipartParam = ["file": attachment]
        }
        self.basicUploadRequest(URLString: HOST_URL + API_PATH_POST_INBOX, multiparts: multipartParam, parameters: param, headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: false, error: error))
                return
            }
            complete(NHTTPResponse(resultStatus: true, data: true, error: nil))
        })
    }
    
    static func httpPostInboxDetail(ticketId: String, subjectDetail: String, attachment: Data?,complete: @escaping (NHTTPResponse<Bool>)->()) {
        var param: [String: Any] = ["ticket_id": ticketId, "subject_detail": subjectDetail]
        var multipartParam: [String: Data]? = nil
        if let attachment = attachment {
            multipartParam = ["file": attachment]
        }
        self.basicUploadRequest(URLString: HOST_URL + API_PATH_POST_INBOX_DETAIL, multiparts: multipartParam, parameters: param, headers: nil, complete: {status, data, error in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: false, error: error))
                return
            }
            complete(NHTTPResponse(resultStatus: true, data: true, error: nil))
        })
    }
}
