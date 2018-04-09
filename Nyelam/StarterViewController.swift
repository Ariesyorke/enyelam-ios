//
//  ViewController.swift
//  Nyelam
//
//  Created by Bobi on 4/1/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

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
                //TODO CREATE POPUP
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
            self.goToHomepage()
        })
    }
    
    internal func goToHomepage() {

    }
}

