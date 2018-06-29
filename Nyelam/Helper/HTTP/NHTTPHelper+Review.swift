//
//  NHTTPHelper+Review.swift
//  Nyelam
//
//  Created by Bobi on 6/25/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

extension NHTTPHelper {
    static func httpGetReviewList(serviceId: String, complete: @escaping (NHTTPResponse<[Review]>)->()) {
        self.basicPostRequest(URLString: HOST_URL+API_PATH_REVIEW_LIST,
                              parameters: ["service_id": serviceId],
                              headers: nil,
                              complete: {status, data, error in
                                if let error = error {
                                    complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                                    return
                                }
                                if let data = data, let json = data as? [String: Any] {
                                    var reviews: [Review]? = nil
                                    if let reviewArray = json["reviews"] as? Array<[String: Any]>, !reviewArray.isEmpty {
                                        reviews = []
                                        for reviewJson in reviewArray {
                                            let review = Review(json: reviewJson)
                                            reviews!.append(review)
                                        }
                                    } else if let reviewString = json["reviews"] as? String {
                                        do {
                                            let data = reviewString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                            let reviewArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                                            reviews = []
                                            for reviewJson in reviewArray {
                                                let review = Review(json: reviewJson)
                                                reviews!.append(review)
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    complete(NHTTPResponse(resultStatus: true, data: reviews, error: nil))
                                }
        })
    }
}
