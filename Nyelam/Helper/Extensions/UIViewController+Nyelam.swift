//
//  UIViewController+Nyelam.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func handleHTTP(error: BaseError, withOkHandler okHandler: (() -> Void)?) {
        handleHTTP(error: error, withOkHandler: okHandler, andAuthSuccessHandler: nil)
    }
    
    public func handleHTTP(error: BaseError, withOkHandler okHandler: (() -> Void)?, andAuthSuccessHandler authHandler: (() -> Void)?) {
        if error is InvalidTokenError {
            // TODO: present AuthController. dan callback sukses login/register dari AuthController, di teruskan ke authHandler di func ini.
        } else {
            self.presentAlert(message: error.message != nil ? error.message! : "Something went wrong, please contact Application Suppor", completion: nil, okHandler: okHandler)
        }
    }
}
