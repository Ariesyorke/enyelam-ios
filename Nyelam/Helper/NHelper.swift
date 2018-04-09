//
//  NHelper.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

class NHelper {
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
}
