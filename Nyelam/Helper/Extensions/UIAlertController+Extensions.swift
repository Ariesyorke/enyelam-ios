//
//  UIAlertView+Extensions.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func handleErrorMessage(viewController: UIViewController, error: BaseError, completion: @escaping (BaseError)->()) {
        var title: String = "Unknown Error"
        var actionButtonTitle: String = "OK"
        if error.isKind(of: NotConnectedInternetError.self) {
            title = "Unable connect to server. Please check your internet connection and try again"
            if #available(iOS 10.0, *) {
                actionButtonTitle = "Setting"
            }
        }
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionButtonTitle, style: .cancel, handler: {alert in
            completion(error)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
