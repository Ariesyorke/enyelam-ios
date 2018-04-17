//
//  MainNavigationController.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/10/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class MainNavigationController: BaseNavigationController {
    
    static func present(on controller: UIViewController) -> MainNavigationController {
        let root: MainRootController = MainRootController(nibName: "MainRootController", bundle: nil)
        let nav: MainNavigationController = MainNavigationController(rootViewController: root)
        controller.present(nav, animated: true, completion: nil)
        return nav
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToAuth(dismisCompletion: ()->()) {
        let auth = AuthNavigationController.present(on: self, dismissCompletion: dismissCompletion)
    }
}
