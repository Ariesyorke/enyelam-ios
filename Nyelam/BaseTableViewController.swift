//
//  BaseTableViewController.swift
//  Nyelam
//
//  Created by Bobi on 4/16/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        dtmViewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
