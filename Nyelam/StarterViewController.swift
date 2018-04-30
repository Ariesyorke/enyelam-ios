//
//  ViewController.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import CoreData

class StarterViewController: BaseViewController {
    
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
            NSManagedObjectContext.saveData()
            self.loadMinMaxPrice(type: "1")
        })
    }
    
    internal func loadMinMaxPrice(type: String) {
        NHTTPHelper.httpGetMinMaxPrice(type: type, complete: {response in
            if let error = response.error {
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.loadMinMaxPrice(type: type)
                        })
                    }
                })
                return
            }
            if let data = response.data {
                if type == "1" {
                    PriceRangeManager.shared.doDivePriceRange = data
                } else {
                    PriceRangeManager.shared.doTripPriceRange = data
                }
            }
            if type == "1" {
                self.loadMinMaxPrice(type: "2")
            } else {
                self.goToHomepage()
            }
        })
    }
    
    internal func goToHomepage() {
        let _ = MainNavigationController.present(on: self)
    }
}
