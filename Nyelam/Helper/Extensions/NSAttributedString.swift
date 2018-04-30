//
//  NSAttributedString.swift
//  Nyelam
//
//  Created by Bobi on 4/30/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    static func htmlAttriButedText(str : String, fontName: String, size: CGFloat, color: UIColor) -> NSAttributedString{
        let attrStr = try! NSMutableAttributedString(data: str.data(using: String.Encoding.utf8, allowLossyConversion: true)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        attrStr.addAttribute(NSAttributedStringKey.font, value: UIFont(name: fontName, size: size), range:  NSMakeRange(0, attrStr.length))
        attrStr.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSMakeRange(0, attrStr.length))
        return attrStr
    }
}
