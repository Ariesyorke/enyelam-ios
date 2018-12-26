//
//  MainNavigationController.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/10/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class MainNavigationController: BaseNavigationController {
    var inbox: Inbox?
    static func present(on controller: UIViewController, with inbox: Inbox?) -> MainNavigationController {
        let root: MainRootController = MainRootController(nibName: "MainRootController", bundle: nil)
        let nav: MainNavigationController = MainNavigationController(rootViewController: root)
        nav.inbox = inbox
        controller.present(nav, animated: true, completion: nil)
        
        return nav
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.firstime, let inbox = inbox {
            self.firstime = false
            var closed = true
            if let status = inbox.status, status.lowercased() == "open" {
                closed = false
            }
            if let authReturn = NAuthReturn.authUser(), let user = authReturn.user {
                let _ = InboxDetailController.push(on: self, inbox: inbox, senderId: user.id!, closed: closed)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToAuth(dismisCompletion: ()->()) {
        let auth = AuthNavigationController.present(on: self, dismissCompletion: dismissCompletion)
    }
}
