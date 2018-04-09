//
//  UIView+CustomFont.swift
//  Travly
//
//  Created by Ramdhany Dwi Nugroho on 12/4/17.
//  Copyright © 2017 Flightspeed. All rights reserved.
//

import UIKit

extension UIView {
    public func settingFontFamily(name: String) {
        settingFontFamily(name: name, hasStyle: false)
    }
    
    public func settingFontFamily(name: String, hasStyle: Bool) {
        
        if self is UILabel {
            let t: UILabel = self as! UILabel
            
            let fontName: String! = UIView.resolveFontName(name, fontDescriptor: t.font.fontDescriptor, hasStyle: hasStyle)
            t.font = UIFont(name: fontName, size: t.font!.pointSize)
        } else if self is UITextView {
            let t: UITextView = self as! UITextView
            
            let fontName: String! = UIView.resolveFontName(name, fontDescriptor: t.font!.fontDescriptor, hasStyle: hasStyle)
            t.font = UIFont(name: fontName, size: t.font!.pointSize)
        } else if self is UIButton {
            let temp: UIButton = self as! UIButton
            if temp.titleLabel != nil {
                let fontName: String! = UIView.resolveFontName(name, fontDescriptor: temp.titleLabel!.font!.fontDescriptor, hasStyle: hasStyle)
                
                temp.titleLabel!.font = UIFont(name: fontName, size: temp.titleLabel!.font!.pointSize)
            }
        } else if self is UITableViewCell {
            let cell: UITableViewCell = self as! UITableViewCell
            
            if cell.textLabel != nil {
                let fontName: String! = UIView.resolveFontName(name, fontDescriptor: cell.textLabel!.font!.fontDescriptor, hasStyle: hasStyle)
                cell.textLabel!.font = UIFont(name: fontName, size: cell.textLabel!.font!.pointSize)
            }
            
            if cell.detailTextLabel != nil {
                let fontName: String! = UIView.resolveFontName(name, fontDescriptor: cell.detailTextLabel!.font!.fontDescriptor, hasStyle: hasStyle)
                cell.detailTextLabel!.font = UIFont(name: fontName, size: cell.detailTextLabel!.font!.pointSize)
            }
        } else if self is UISegmentedControl {
            let t: UISegmentedControl = self as! UISegmentedControl
            let fontName: String! = UIView.resolveFontName(name, fontDescriptor: nil, hasStyle: hasStyle)
            let font: UIFont? = UIFont(name: fontName, size: 17.0)
            t.setTitleTextAttributes([
                NSAttributedStringKey.font: font!
                ], for: UIControlState())
        }
    }
    
    fileprivate static func resolveFontName(_ fontFamilyName: String!, fontDescriptor: UIFontDescriptor?, hasStyle: Bool) -> String! {
        if !hasStyle {
            return fontFamilyName
        } else {
            let fontNameBold: String = fontFamilyName + "-Bold"
            let fontNameRegular: String = fontFamilyName + "-Regular"
            let fontNameItalic: String = fontFamilyName + "-Regular"
            
            if fontDescriptor == nil {
                return fontNameRegular
            } else if fontDescriptor!.symbolicTraits == UIFontDescriptorSymbolicTraits.traitBold {
                return fontNameBold
            } else if fontDescriptor!.symbolicTraits == UIFontDescriptorSymbolicTraits.traitItalic {
                return fontNameItalic
            } else {
                return fontNameRegular
            }
        }
    }
}
