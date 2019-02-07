//
//  OrderViewController.swift
//  Nyelam
//
//  Created by Bobi on 12/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import MBProgressHUD

class OrderViewController: ButtonBarPagerTabStripViewController {
    static func push(on controller: UINavigationController) -> OrderViewController {
        let vc = OrderViewController(nibName: "OrderViewController", bundle: nil)
        controller.pushViewController(vc, animated: true)
        return vc
    }
    override func viewDidLoad() {
        
        self.settings.style.buttonBarBackgroundColor = UIColor.primary
        self.settings.style.buttonBarItemFont = UIFont(name: "FiraSans-Bold", size: 14)!
        self.settings.style.buttonBarItemTitleColor = UIColor.darkGray
        self.settings.style.selectedBarBackgroundColor = UIColor.white
        self.settings.style.buttonBarItemBackgroundColor = UIColor.primary
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
        self.settings.style.buttonBarHeight = 66
        self.settings.style.selectedBarHeight = 3
        self.changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.white
            newCell?.label.textColor = UIColor.white
        }
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back_button_white"), style: .plain, target: self, action: #selector(backButtonAction(_:)))
        self.title = "Orders"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationController!.additionalSafeAreaInsets = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
            })
        }
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [OrderListController.create(paymentType: 1), OrderListController.create(paymentType: 2),
               OrderListController.create(paymentType: 3), OrderListController.create(paymentType: 4),
               OrderListController.create(paymentType: 5), OrderListController.create(paymentType: 6),
               OrderListController.create(paymentType: 7), OrderListController.create(paymentType: 8)]
    }
    
    func disableLeftBarButton() {
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func resetInsets() {
        if #available(iOS 11.0, *) {
            if let navigation = self.navigationController {
                navigation.additionalSafeAreaInsets = UIEdgeInsets.zero
            }
        }
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
        self.resetInsets()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
