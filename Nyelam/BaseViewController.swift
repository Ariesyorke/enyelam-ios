//
//  BaseViewController.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class BaseViewController: UIViewController, UITextFieldDelegate {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dtmViewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back_button_white"), style: .plain, target: self, action: #selector(backButtonAction(_:)))
    }
    
    func disableLeftBarButton() {
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func handleAuthResponse(response: NHTTPResponse<NAuthReturn>, errorCompletion: @escaping (BaseError)->(), successCompletion: @escaping(NAuthReturn)->()) {
        MBProgressHUD.hide(for: self.view, animated: true)
        if let error = response.error {
            UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                errorCompletion(error)
            })
            return
        }
        if let data = response.data {
            successCompletion(data)
        }
    }
    
    override func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) {
            if self.navigationItem.rightBarButtonItem == nil {
                let rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction(_:)))
                self.navigationItem.rightBarButtonItem = rightBarButtonItem
            }
        }
    }
    
    override func keyboardWillHide(animationDuration: TimeInterval) {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }

    func goToAuth() {
        let auth = AuthNavigationController.present(on: self, dismissCompletion: {
        })
    }
    
    func goToAccount() {
        let accountViewController = AccountTableViewController(nibName: "AccountTableViewController", bundle: nil)
        if let navigation = navigationController {
            navigation.pushViewController(accountViewController, animated: true)
        } else {
            self.present(accountViewController, animated: true, completion: nil)
        }
    }
    
    
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        if let navigation = self.navigationController as? BaseNavigationController {
            if self.isKind(of: SearchFormController.self) {
                navigation.navigationBar.barTintColor = UIColor.primary
            }

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
