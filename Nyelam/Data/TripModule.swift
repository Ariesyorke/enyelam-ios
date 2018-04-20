//
//  TripModule.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import CoreData

public class TripModule: Module {
    private let KEY_TRIPS = "trips"
    var diveServices: [NDiveService]?
    
    override func parse(json: [String : Any]) {
        super.parse(json: json)
        if let diveServiceArray = json[KEY_TRIPS] as? Array<[String: Any]>, !diveServiceArray.isEmpty {
            diveServices = []
            for diveServiceJson in diveServiceArray {
                var diveService: NDiveService? = nil
                if let id = diveServiceJson["id"] as? String {
                    diveService = NDiveService.getDiveService(using: id)
                }
                if diveService == nil {
                    diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                }
                diveService!.parse(json: diveServiceJson)
                diveServices!.append(diveService!)
            }
        } else if let diveServiceString = json[KEY_TRIPS] as? String {
            do {
                let data = diveServiceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let diveServiceArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                diveServices = []
                for diveServiceJson in diveServiceArray {
                    var diveService: NDiveService? = nil
                    if let id = diveServiceJson["id"] as? String {
                        diveService = NDiveService.getDiveService(using: id)
                    }
                    if diveService == nil {
                        diveService = NDiveService.init(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                    }
                    diveService!.parse(json: diveServiceJson)
                    diveServices!.append(diveService!)
                }
            } catch {
                print(error)
            }
        }
    }
    
    override func serialized() -> [String : Any] {
        var json = super.serialized()
        if let diveServices = self.diveServices, !diveServices.isEmpty {
            var array: Array<[String: Any]> = []
            for diveService in diveServices {
                array.append(diveService.serialized())
            }
            json[KEY_TRIPS] = array
        }
        return json
    }
    
    init(json: [String: Any]) {
        super.init()
        self.parse(json: json)
    }
}
