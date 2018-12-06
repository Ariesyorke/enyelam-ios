//
//  NHelper.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftDate

class NHelper {
    static var ecoTripDates: [Date]? = nil
    
    static func generateEcoTripDates()->[Date] {
        var dates: [Date] = []
        var cal = CalendarName.gregorian.calendar
        let months = 13 - cal.component(.month, from: Date())
        for var i in 0..<months {
            var date = Date()
            let currentCal = CalendarName.gregorian.calendar
            var cmp = DateComponents()
            cmp.calendar = CalendarName.gregorian.calendar
            cmp.year = currentCal.component(.year, from: date)
            cmp.month = currentCal.component(.month, from: date)
            cmp.day = 1
            cmp.hour = 0
            cmp.minute = 0
            
            date = DateInRegion(components: cmp)!.absoluteDate
            
            date = currentCal.date(byAdding: .month, value: i, to: date)!
            date = currentCal.date(byAdding: .weekOfMonth, value: 1, to: date)!
            let region = Region(tz: TimeZoneName.asiaJakarta, cal: CalendarName.gregorian, loc: LocaleName.englishUnitedStates)
//            date = DateInRegion(absoluteDate: date, in: region).startWeek.absoluteDate
            date = DateInRegion(absoluteDate: date).startWeek.absoluteDate
            var week = currentCal.component(.weekOfMonth, from: date)
            
            if week < 3 {
                week = 3 - week
                date = currentCal.date(byAdding: .weekOfMonth, value: week, to: date)!
                week = currentCal.component(.weekOfMonth, from: date)
            }
            if week == 3 {
                let weekday = currentCal.component(.weekday, from: date)
                if weekday == 5 {
                    date = currentCal.date(byAdding: .day, value: 1, to: date)!
                }
                for var j in 0..<7 {
                    date = currentCal.date(byAdding: .day, value: j, to: date)!
                    let day = currentCal.component(.weekday, from: date)
                    if day == 7 {
                        dates.append(date)
                        break
                    }
                }
            }
        }
        return dates
    }
    
    static func handleConnectionError(completion: @escaping ()->()) {
        if #available(iOS 10.0, *) {
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)     else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    completion()
                })
            }
        } else {
            completion()
        }
    }
    
    static func getMaximumBirthDate() -> Date {
        let cal =  CalendarName.gregorian.calendar
        let pickedDate = cal.date(byAdding: .year, value: -13, to: Date())
        return pickedDate!
    }
    
    static func formatAddress(address: NAddress) -> String {
        var a = ""
        if let addr = address.address {
            a = addr
        }
        var locationName = ""
        if let district = address.district, let districtName = district.name {
            locationName = districtName
        }
        if let city = address.city, let cityName = city.name {
            locationName = "\(locationName), \(cityName)"
        }
        if let province = address.province, let provinceName = province.name {
            locationName = "\(locationName)\n\(provinceName)"
        }
        if let zipCode = address.zipcode {
            locationName = "\(locationName) - \(zipCode)"
        }
        
        a = "\(a)\n\(locationName)"
        return a
    }
    
    static func isLogin()->Bool {
        if let _ = NAuthReturn.authUser() {
            return true
        }
        return false
    }
    static func calculateCourier(merchants: [Merchant]) -> [Courier] {
        var couriers: [Courier] = []
        for _ in merchants {
            couriers.append(Courier())
        }
        return couriers
    }
    static func calculateCourierTypes(merchants: [Merchant]) -> [CourierType] {
        var courierTypes: [CourierType] = []
        for _ in merchants {
            courierTypes.append(CourierType())
        }
        return courierTypes
    }
}
