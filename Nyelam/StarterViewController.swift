//
//  ViewController.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import CoreData
import Crashlytics

class StarterViewController: BaseViewController {
    var inbox: Inbox?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUpdate()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    internal func getUpdate() {
        if let _ = NAuthReturn.authUser() {
            AppDelegate.updateFirebase()
        }
        NHTTPHelper.httpGetUpdateVersion(complete: {response in
            if let error = response.error {
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.getUpdate()
                        })
                    }
                })
                return
            }
            if let data = response.data {
                return
            }
        
            self.loadCategories(page: 1)
        })
    }
    
    internal func loadCategories(page: Int) {
        NHTTPHelper.httpGetMasterCategories(page: String(page), complete: {response in
            if let error = response.error {
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in 
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.loadCategories(page: page)
                        })
                    }
                })
                return
            }
            NSManagedObjectContext.saveData()
            self.loadCountryCodes(page: page)
        })
    }
    
    internal func loadCountryCodes(page: Int) {
        NHTTPHelper.httpGetMasterCountryCode(page: String(page), complete: {response in
            if let error = response.error {
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.loadCountryCodes(page: page)
                        })
                    }
                })
                return
            }
            if let data = response.data, !data.isEmpty {
                let nextPage = page + 1
                self.loadCountryCodes(page: nextPage)
                return
            }
            NSManagedObjectContext.saveData()
            self.loadLanguages()
        })
    }
    
    internal func loadLanguages() {
        NHTTPHelper.httpGetMasterLanguage(complete: {response in
            if let error = response.error {
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.loadLanguages()
                        })
                    }
                })
                return
            }
            NSManagedObjectContext.saveData {
            self.loadMasterOrganization()
//                self.goToHomepage()
            }
        })
    }
    
    internal func loadMasterOrganization() {
        NHTTPHelper.httpGetMasterOrganization(complete: {response in
            if let error = response.error {
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.loadMasterOrganization()
                        })
                    }
                })
                return
            }
            NSManagedObjectContext.saveData {
                if let _ = NAuthReturn.authUser() {
                    self.goToHomepage()
                } else {
                    self.goToOnBoarding()
                }
            }
        })
    }
    
    internal func goToOnBoarding() {
        let _ = OnboardingController.present(on: self)
    }
    internal func goToHomepage() {
//        let _ = MainRootController.present(on: self)
        let _ = MainNavigationController.present(on: self, with: inbox)
    }
}
