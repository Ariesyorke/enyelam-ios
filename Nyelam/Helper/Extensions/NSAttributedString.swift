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
    static func customNumbering(
        array: [String],
        bullets: [String],
        fontName: String,
        size: CGFloat, color: UIColor,
        indentation: CGFloat = 20,
        lineSpacing: CGFloat = 2,
        paragraphSpacing: CGFloat = 12) -> NSAttributedString {
        let font = UIFont(name: fontName, size: size)!
        let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: color]
        let bulletAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: color]
        
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        
        let bulletList = NSMutableAttributedString()
        var i: Int = 0
        for string in array {
            let formattedString = "\(bullets[i]).\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)
            
            attributedString.addAttributes(
                [NSAttributedStringKey.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))
            
            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))
            
            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: "\(String(string)).")
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
            i+=1
        }
        
        return bulletList
    }
    static func numberringAttributedText(
        array: [String], fontName: String,
        size: CGFloat, color: UIColor,
        indentation: CGFloat = 20,
        lineSpacing: CGFloat = 2,
        paragraphSpacing: CGFloat = 12) -> NSAttributedString {
        let font = UIFont(name: fontName, size: size)!
        let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: color]
        let bulletAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: color]
        
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        
        let numberingList = NSMutableAttributedString()
        var number: Int = 1
        for string in array {
            let formattedString = "\(String(number)).\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)
            
            attributedString.addAttributes(
                [NSAttributedStringKey.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))
            
            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))
            
            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: "\(String(number)).")
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            numberingList.append(attributedString)
            number += 1
        }
        
        return numberingList
    }
    static func htmlAttriButedText(str : String, fontName: String, size: CGFloat, color: UIColor) -> NSAttributedString{
        let attrStr = try! NSMutableAttributedString(data: str.data(using: String.Encoding.utf8, allowLossyConversion: true)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        attrStr.addAttribute(NSAttributedStringKey.font, value: UIFont(name: fontName, size: size), range:  NSMakeRange(0, attrStr.length))
        attrStr.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSMakeRange(0, attrStr.length))
        return attrStr
    }
}
