//
//  EcoTripIntroductionController.swift
//  Nyelam
//
//  Created by Bobi on 4/19/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import UINavigationControllerWithCompletionBlock

class EcoTripIntroductionController: BaseViewController {
    static func push(on controller: UINavigationController, onOpenEcoTrip: @escaping (UIViewController)->()) -> EcoTripIntroductionController {
        let vc: EcoTripIntroductionController = EcoTripIntroductionController(nibName: "EcoTripIntroductionController", bundle: nil)
        vc.onOpenEcoTrip = onOpenEcoTrip
//        controller.setNavigationBarHidden(false, animated: true)
//        controller.navigationBar.barTintColor = UIColor.nyGreen
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    static func present(on controller: UINavigationController, onOpenEcoTrip: @escaping (UIViewController)->()) -> EcoTripIntroductionController {
        let vc: EcoTripIntroductionController = EcoTripIntroductionController(nibName: "EcoTripIntroductionController", bundle: nil)
        vc.onOpenEcoTrip = onOpenEcoTrip
        controller.present(vc, animated: true, completion: nil)
        return vc
    }

    var onOpenEcoTrip: (UIViewController)->() = {controller in }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        if let navigation = self.navigationController {
            navigation.popViewController(animated: true)
        }
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openUrlAction(_ sender: Any) {
        guard let url = URL(string: "https://www.sosis.id") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func bookButtonAction(_ sender: Any) {
        self.onOpenEcoTrip(self)
//        if let navigation = self.navigationController {
//            navigation.popViewController(animated: true, withCompletionBlock: {
//                SearchFormController.push(on: navigation, forDoTrip: false, isEcotrip: true)
//            })
//        }
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
