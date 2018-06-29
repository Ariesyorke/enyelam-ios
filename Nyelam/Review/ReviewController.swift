//
//  ReviewController.swift
//  Nyelam
//
//  Created by Bobi on 5/30/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
class ReviewController: BaseViewController {
    static func present(on controller: UINavigationController, bookingId: String) -> ReviewController {
        let vc: ReviewController = ReviewController(nibName: "ReviewController", bundle: nil)
        vc.bookingId = bookingId
        controller.present(vc, animated: true, completion: {})
        return vc
    }
    
    fileprivate var bookingId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
