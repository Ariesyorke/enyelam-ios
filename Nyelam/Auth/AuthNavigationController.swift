//
//  AuthNavigationController.swift
//  Nyelam
//
//  Created by Bobi on 4/10/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import UINavigationControllerWithCompletionBlock

class AuthNavigationController: BaseNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        
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
    
    func authentificationSuccess() {
        self.dismiss(animated: true, completion: dismissCompletion)
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
