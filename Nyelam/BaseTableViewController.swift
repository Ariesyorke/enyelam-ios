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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back_button_white"), style: .plain, target: self, action: #selector(backButtonAction(_:)))
    }
    
    func disableLeftBarButton() {
        self.navigationItem.leftBarButtonItem = nil
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        if let navigation = self.navigationController as? BaseNavigationController {
            if navigation.viewControllers.count == 1 {
                navigation.dismiss(animated: true, completion: navigation.dismissCompletion)
            } else {
                navigation.popViewController(animated: true)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
