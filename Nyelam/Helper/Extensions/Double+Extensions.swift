//
//  Double+Extensions.swift
//  Nyelam
//
//  Created by Bobi on 4/19/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    func toCurrencyFormatString(currency: String) -> String {
        if self <= 0 {
            return "Free"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_us")
        formatter.currencySymbol = currency + " "
        formatter.currencyGroupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.alwaysShowsDecimalSeparator = false
        formatter.allowsFloats = false
        let formatPrice: String = formatter.string(from: NSNumber(value: self))!
        let endIndex = formatPrice.index(formatPrice.endIndex, offsetBy: -3)
        let realPrice = formatPrice.substring(to: endIndex)
        return realPrice
    }

}
