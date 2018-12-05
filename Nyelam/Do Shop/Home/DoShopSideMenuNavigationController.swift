//
//  DoShopSideMenuNavigationController.swift
//  Nyelam
//
//  Created by Bobi on 11/21/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

class DoShopSideMenuNavigationController: UISideMenuNavigationController {
    var onSideMenuClicked: (DoShopSideMenuType, NProductCategory?) -> () = {menu, category in }
    static func create() -> DoShopSideMenuNavigationController {
        let vc = DoShopSideMenuHomeController(nibName: "DoShopSideMenuHomeController", bundle: nil)
        let controller = DoShopSideMenuNavigationController(rootViewController: vc)
        return controller
   }
}
