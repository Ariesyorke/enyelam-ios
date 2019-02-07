//
//  NSMutableAttributedString+Extensions.swift
//  Nyelam
//
//  Created by Bobi on 14/01/19.
//  Copyright © 2019 e-Nyelam. All rights reserved.
//

import Foundation
extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String, fontName: String, size: CGFloat) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            _ = NSMutableAttributedString(string: textToFind)
            // Set Attribuets for Color, HyperLink and Font Size
            let attributes = [NSAttributedStringKey.font: UIFont(name: fontName, size: size), NSAttributedStringKey.link:NSURL(string: linkURL)!, NSAttributedStringKey.foregroundColor: UIColor.blue]
            
            self.setAttributes(attributes, range: foundRange)
            return true
        }
        return false
    }
}
