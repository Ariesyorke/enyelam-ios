//
//  UIImageView+Extensions.swift
//  Nyelam
//
//  Created by Bobi on 4/19/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire

extension UIImageView {
    func loadImage(from url: String) {
        Alamofire.request(url).responseImage(completionHandler: {response in
            if let _ = response.error {
                return
            }
            if let image = response.result.value {
                self.image = image
            }
        })
    }
    
    func loadImage(from url: String, contentMode: UIViewContentMode) {
        Alamofire.request(url).responseImage(completionHandler: {response in
            if let _ = response.error {
                return
            }
            if let image = response.result.value {
                self.image = image
                self.contentMode = contentMode
            }
        })
    }
    
    func loadImage(from url: String, contentMode: UIViewContentMode, with placeHolder: String) {
        self.image = UIImage(named: placeHolder)
        Alamofire.request(url).responseImage(completionHandler: {response in
            if let _ = response.error {
                return
            }
            if let image = response.result.value {
                self.image = image
                self.contentMode = contentMode
            }
        })
    }
    
}
