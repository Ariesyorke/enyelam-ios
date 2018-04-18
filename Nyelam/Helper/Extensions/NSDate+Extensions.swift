//
//  NSDate+Extensions.swift
//  Nyelam
//
//  Created by Bobi on 4/18/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    func formatDate(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self as Date)
    }
}

extension Date {
    func formatDate(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
