//
//  EcoTripPickerView.swift
//  Nyelam
//
//  Created by Bobi on 4/20/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import SwiftDate
import UIKit

class EcoTripPickerView: UIPickerView {
    var dates: [Date]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dates = NHelper.generateEcoTripDates()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dates = NHelper.generateEcoTripDates()
    }
    
    func convertToString(in row: Int) -> String {
        if let dates = self.dates, !dates.isEmpty {
            var date = dates[row]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            dateFormatter.locale = Locale(identifier: "us")
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    internal func generatePickerDate() {
        self.dates = []
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
                        self.dates?.append(date)
                        break
                    }
                }
            }
        }
    }
}
