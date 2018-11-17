//
//  DoShopNavigationController.swift
//  Nyelam
//
//  Created by Bobi on 11/7/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class DoShopNavigationController: BaseNavigationController {

    static func present(on controller: UIViewController) -> DoShopNavigationController {
        let root: DoShopHomeController = DoShopHomeController(nibName: "DoShopHomeController", bundle: nil)
        let nav: DoShopNavigationController = DoShopNavigationController(rootViewController: root)
        controller.present(nav, animated: true, completion: nil)
        return nav
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
