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
    static func handleErrorMessage(viewController: UIViewController, error: String, completion: @escaping ()->()) {
        var title: String = error
        var actionButtonTitle: String = "OK"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionButtonTitle, style: .cancel, handler: {alert in
            completion()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    static func handleErrorMessage(viewController: UIViewController, error: BaseError, completion: @escaping (BaseError)->()) {
        var title: String = "Unknown Error"
        var actionButtonTitle: String = "OK"
        if error.isKind(of: NotConnectedInternetError.self) {
            title = "Unable connect to server. Please check your internet connection and try again"
            if #available(iOS 10.0, *) {
                actionButtonTitle = "Setting"
            }
        } else {
            title = error.title!
        }
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionButtonTitle, style: .cancel, handler: {alert in
            completion(error)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func handlePopupMessage(viewController: UIViewController, title: String, actionButtonTitle: String, completion: @escaping ()->()) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionButtonTitle, style: .cancel, handler: {alert in
            completion()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertWithMultipleChoices(title: String, message: String?, viewController: UIViewController, buttons: [UIAlertAction]) -> Void {
        let dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for button in buttons {
            dialog.addAction(button)
        }
        viewController.present(dialog, animated: true, completion: nil)
    }

}
