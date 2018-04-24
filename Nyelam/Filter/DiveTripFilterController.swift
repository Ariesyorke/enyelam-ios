//
//  DiveTripFilterController.swift
//  Nyelam
//
//  Created by Bobi on 4/24/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class DiveTripFilterController: BaseViewController {

    static func push(on controller: UINavigationController, filter: NFilter) -> DiveTripFilterController {
        let vc: DiveTripFilterController = DiveTripFilterController(nibName: "DiveTripFilterController", bundle: nil)
        vc.filter = filter
        controller.pushViewController(vc, animated: true)
        return vc
    }

    var filter: NFilter?
    
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
