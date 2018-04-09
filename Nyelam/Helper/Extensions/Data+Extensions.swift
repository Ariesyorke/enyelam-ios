//
//  Data+Extensions.swift
//  Nyelam
//
//  Created by Bobi on 4/5/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    var extensionTypeForImageData: String {
        let data = self as NSData
        var c = [UInt32](repeating: 0, count: 1)
        data.getBytes(&c, length: 1)
        switch (c[0]) {
        case 0xFF:
            return ".jpg"
        case 0x89:
            return ".png"
        case 0x47:
            return ".gif"
        case 0x49, 0x4D:
            return ".tiff"
        default:
            return ".uknown"
        }
        
    }
    var contentTypeForImageData: String {
        let data = self as NSData
        var c = [UInt32](repeating: 0, count: 1)
        data.getBytes(&c, length: 1)
        switch (c[0]) {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x49, 0x4D:
            return "image/tiff"
        default:
            return "unknown"
        }
    }

}
