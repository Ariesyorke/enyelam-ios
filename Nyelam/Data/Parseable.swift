//
//  Parseable.swift
//  Nyelam
//
//  Created by Bobi on 4/2/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation

protocol Parseable {
    func parse(json: [String: Any])
    func serialized() -> [String: Any]
}
