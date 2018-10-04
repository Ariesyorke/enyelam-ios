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
import Google

class BaseViewController: UIViewController, UITextFieldDelegate {
    var firstTime: Bool = true
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !self.isKind(of: DiveServiceController.self) || !self.isKind(of: BookingDetailController.self) {
            self.navigationItem.rightBarButtonItem = nil
        }
        if self.isKind(of: MainRootController.self) || self.isKind(of: EcoTripIntroductionController.self) {
            self.moveSafeAreaInsets()
        } else {
            self.resetInsets()
        }
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

    func goToAuth(completion: @escaping ()->()) {
        let _ = AuthNavigationController.present(on: self, dismissCompletion: completion)
    }
    
    func goToAccount() {
        let accountViewController = AccountTableViewController(nibName: "AccountTableViewController", bundle: nil)
        if let navigation = navigationController {
            navigation.pushViewController(accountViewController, animated: true)
        } else {
            self.present(accountViewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        if let navigation = self.navigationController as? BaseNavigationController {
            if (self.isKind(of: SearchFormController.self) || self.isKind(of: EcoTripIntroductionController.self) || self.isKind(of: DiveServiceSearchResultController.self) || self.isKind(of: DiveServiceController.self)
                 || self.isKind(of: BookingDetailController.self) || self.isKind(of: EditProfileViewController.self) || self.isKind(of: ChangePasswordViewController.self) || self.isKind(of: TermsViewController.self)) && navigation.viewControllers.count == 2 {
                navigation.setNavigationBarHidden(true, animated: true)
                self.moveSafeAreaInsets()
                navigation.navigationBar.barTintColor = UIColor.primary
            }

            if navigation.viewControllers.count == 1, navigation.isKind(of: AuthNavigationController.self) {
                navigation.dismiss(animated: true, completion: navigation.dismissCompletion)
            } else {
                if navigation.viewControllers[navigation.viewControllers.count - 1].isKind(of: MainRootController.self) {
                    return
                }
                navigation.popViewController(animated: true)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func moveSafeAreaInsets() {
        if #available(iOS 11.0, *) {
            if let navigation = self.navigationController {
                navigation.additionalSafeAreaInsets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    func resetInsets() {
        if #available(iOS 11.0, *) {
            if let navigation = self.navigationController {
                navigation.additionalSafeAreaInsets = UIEdgeInsets.zero
            }
        }
    }

}
