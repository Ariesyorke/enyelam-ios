//
//  NHTTPHelper+Equipment.swift
//  Nyelam
//
//  Created by Bobi on 5/21/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import CoreData

extension NHTTPHelper {
    static func httpGetEquipmentList(date: Date, diveCenterId: String, complete: @escaping (NHTTPResponse<[Equipment]>)->()) {
        self.basicPostRequest(URLString: HOST_URL + API_PATH_EQUIPMENT_LIST,
                              parameters: [
                                "date": String(date.timeIntervalSince1970),
                                "divecenter_id": diveCenterId],
                              headers: nil,
                              complete: {status, data, error  in
            if let error = error {
                complete(NHTTPResponse(resultStatus: false, data: nil, error: error))
                return
            }
            if let data = data, let json = data as? [String: Any] {
                var equipments: [Equipment]? = nil
                if let equipmentArray = json["equipment_rents"] as? Array<[String: Any]>, !equipmentArray.isEmpty {
                    equipments = []
                    for equipmentJson in equipmentArray {
                        var equipment: Equipment? = nil
                        equipment = Equipment(json: equipmentJson)
                        equipments!.append(equipment!)
                    }
                } else if let equipmentString = json["equipment_rents"] as? String {
                    do {
                        let data = equipmentString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let equipmentArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                        equipments = []
                        for equipmentJson in equipmentArray {
                            var equipment: Equipment? = nil
                            equipment = Equipment(json: equipmentJson)
                            equipments!.append(equipment!)
                        }
                    } catch {
                        print(error)
                    }
                }
                complete(NHTTPResponse(resultStatus: true, data: equipments, error: nil))
            }
        })
    }
}
