//
//  AuthNavigationController.swift
//  Nyelam
//
//  Created by Bobi on 4/10/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class AuthNavigationController: BaseNavigationController {
    var dismissCompletion: ()->() = {}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static func present(on controller: UIViewController, dismissCompletion: @escaping ()->()) -> AuthNavigationController {
        let loginController: LoginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let nav: AuthNavigationController = AuthNavigationController(rootViewController: loginController)
        nav.dismissCompletion = dismissCompletion
        controller.present(nav, animated: true, completion: nil)
        return nav
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
