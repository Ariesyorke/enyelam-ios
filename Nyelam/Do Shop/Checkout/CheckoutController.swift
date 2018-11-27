//
//  CheckoutController.swift
//  Nyelam
//
//  Created by Bobi on 11/23/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import MBProgressHUD
import DLRadioButton
import ActionSheetPicker_3_0

class CheckoutController: BaseViewController, UITextViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var personalInformationContainer: UIView!
    @IBOutlet weak var personalContainer: UIView!
    @IBOutlet weak var shippingAddressContainer: UIView!
    @IBOutlet weak var shippingContainer: UIView!
    @IBOutlet weak var shippingInformationContainer: UIView!
    @IBOutlet weak var checkButton: DLRadioButton!    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var inputBillingAddressView: NInputAddressView?
    var inputShippingAddressView: NInputAddressView?
    
    var shippingAddress: NAddress?
    var billingAddress: NAddress?
    
    static func push(on controller: UINavigationController) -> CheckoutController {
        let vc = CheckoutController(nibName: "CheckoutController", bundle: nil)
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rightView.halfCircledView()
        self.leftView.halfCircledView()
        self.middleView.halfCircledView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.firstTime {
            self.tryLoadAddress()
        }
    }
    
    func tryLoadAddress() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpAddressListRequest(complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadAddress()
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                        
                    })
                }
                return
            }
            self.personalContainer.isHidden = false
            if let datas = response.data, !datas.isEmpty {
                self.findDefaultAddresses(addresses: datas)
                if self.billingAddress == nil {
                    self.inputBillingAddress()
                } else {
                    self.createAddressDetail(address: self.billingAddress!, container: self.personalInformationContainer)
                }
            } else {
                self.inputBillingAddress()
            }
        })
    }
    
    fileprivate func findDefaultAddresses(addresses: [NAddress]) {
        for address in addresses {
            if address.default_shipping == 1 {
                self.shippingAddress = address
            }
            if address.default_shipping == 1 {
                self.billingAddress = address
            }
        }
    }
    
    fileprivate func inputShippingAddress() {
        for subview in self.shippingInformationContainer.subviews {
            subview.removeFromSuperview()
            
            self.inputShippingAddressView = NInputAddressView(delegate: self, textViewDelegate: self)
            self.inputShippingAddressView!.translatesAutoresizingMaskIntoConstraints = false
            self.shippingInformationContainer.addConstraints([
                NSLayoutConstraint(item: self.shippingInformationContainer, attribute: .leading, relatedBy: .equal, toItem: self.inputShippingAddressView, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.shippingInformationContainer, attribute: .trailing, relatedBy: .equal, toItem: self.inputShippingAddressView, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.shippingInformationContainer, attribute: .top, relatedBy: .equal, toItem: self.inputShippingAddressView, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.shippingInformationContainer, attribute: .bottom, relatedBy: .equal, toItem: self.inputShippingAddressView, attribute: .bottom, multiplier: 1, constant: 0)
                ])
            self.inputShippingAddressView!.onOpenProvince = {view in
                self.view.endEditing(true)
                self.tryLoadProvince(view: view)
            }
            
            self.inputShippingAddressView!.onOpenCity = {view in
                if view.province == nil {
                    UIAlertController.handleErrorMessage(viewController: self, error: "Please pick province first!", completion: {})
                    return
                }
                self.view.endEditing(true)
                self.tryLoadCity(view: view, provinceId: view.province!.id!)
            }
            
            self.inputShippingAddressView!.onOpenDistrict = {view in
                if view.city == nil {
                    UIAlertController.handleErrorMessage(viewController: self, error: "Please pick city first!", completion: {})
                    return
                }
                self.view.endEditing(true)
                self.tryLoadDistrict(view: view, cityId: view.city!.id!)
            }
        }
    }
    fileprivate func inputBillingAddress() {
        for subview in self.personalInformationContainer.subviews {
            subview.removeFromSuperview()
        }
        
        self.inputBillingAddressView = NInputAddressView(delegate: self, textViewDelegate: self)
        self.inputBillingAddressView!.translatesAutoresizingMaskIntoConstraints = false
        self.personalInformationContainer.addSubview(self.inputBillingAddressView!)
        self.personalInformationContainer.translatesAutoresizingMaskIntoConstraints = false
        self.personalInformationContainer.addConstraints([
            NSLayoutConstraint(item: self.personalInformationContainer, attribute: .leading, relatedBy: .equal, toItem: self.inputBillingAddressView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.personalInformationContainer, attribute: .trailing, relatedBy: .equal, toItem: self.inputBillingAddressView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.personalInformationContainer, attribute: .top, relatedBy: .equal, toItem: self.inputBillingAddressView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.personalInformationContainer, attribute: .bottom, relatedBy: .equal, toItem: self.inputBillingAddressView, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        
        self.inputBillingAddressView!.onOpenProvince = {view in
            self.view.endEditing(true)
            self.tryLoadProvince(view: view)
        }
        
        self.inputBillingAddressView!.onOpenCity = {view in
            if view.province == nil {
                UIAlertController.handleErrorMessage(viewController: self, error: "Please pick province first!", completion: {})
                return
            }
            self.view.endEditing(true)
            self.tryLoadCity(view: view, provinceId: view.province!.id!)
        }
        
        self.inputBillingAddressView!.onOpenDistrict = {view in
            if view.city == nil {
                UIAlertController.handleErrorMessage(viewController: self, error: "Please pick city first!", completion: {})
                return
            }
            self.view.endEditing(true)
            self.tryLoadDistrict(view: view, cityId: view.city!.id!)
        }
    }
    
    fileprivate func tryLoadDistrict(view: NInputAddressView, cityId: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpGetDistrict(cityId: cityId, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadDistrict(view: view, cityId: cityId)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                        
                    })
                }
                return
            }
            if let datas = response.data, !datas.isEmpty {
                self.pickDistrict(districts: datas, view: view)
            }
        })
    }
    
    fileprivate func tryLoadCity(view: NInputAddressView, provinceId: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpGetCity(provinceId: provinceId, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadCity(view: view, provinceId: provinceId)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let _ = error as! StatusFailedError
                        
                    })
                }
                return
            }
            
            if let datas = response.data, !datas.isEmpty {
                self.pickCity(cities: datas, view: view)
            }
        })
    }
    
    fileprivate func tryLoadProvince(view: NInputAddressView) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpGetProvince(complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadProvince(view: view)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let _ = error as! StatusFailedError
                    })
                }
                return
            }
            if let datas = response.data, !datas.isEmpty {
                self.pickProvince(provinces: datas, view: view)
            }
        })
    }
    
    fileprivate func pickDistrict(districts: [NDistrict], view: NInputAddressView) {
        var distrs: [String] = []
        var position = -1
        var i = 0
        for district in districts {
            distrs.append(district.name!)
            if let d = view.district, d.id == district.id {
                position = i
            }
            i+=1
        }
        let actionSheet = ActionSheetStringPicker.init(title: "Choose District", rows: distrs, initialSelection: position >= 0 ? position : 0, doneBlock: {picker, index, value in
            view.district = districts[index]
        }, cancel: {_ in return
        }, origin: self.view)
        actionSheet!.show()
    }
    
    fileprivate func pickCity(cities: [NCity], view: NInputAddressView) {
        var cits: [String] = []
        var position = -1
        var i = 0
        for city in cities {
            cits.append(city.name!)
            if let c = view.city, c.id == city.id {
                position = i
            }
            i+=1
        }
        let actionSheet = ActionSheetStringPicker.init(title: "Choose City", rows: cits, initialSelection: position >= 0 ? position : 0, doneBlock: {picker, index, value in
            view.city = cities[index]
        }, cancel: {_ in return
        }, origin: self.view)
        actionSheet!.show()
    }
    
    fileprivate func pickProvince(provinces: [NProvince], view: NInputAddressView) {
        var provs: [String] = []
        var position = -1
        var i = 0
        for province in provinces {
            provs.append(province.name!)
            if let p = view.province, p.id == province.id {
                position = i
            }
            i += 1
        }
        let actionSheet = ActionSheetStringPicker.init(title: "Choose Province", rows: provs, initialSelection: position >= 0 ? position : 0, doneBlock: {picker, index, value in
            view.province = provinces[index]
        }, cancel: {_ in return
        }, origin: self.view)
        actionSheet!.show()
    }
    
    fileprivate func createAddressDetail(address: NAddress, container: UIView) {
        for subview in container.subviews {
            subview.removeFromSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "FiraSans-SemiBold", size: 14)
        titleLabel.text = address.fullname
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont(name: "FiraSans-Regular", size: 14)
        descriptionLabel.text = NHelper.formatAddress(address: address)
        self.personalInformationContainer.addSubview(titleLabel)
        self.personalInformationContainer.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.addConstraints([
            NSLayoutConstraint(item: container, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .top, multiplier: 1, constant: 0)])

        descriptionLabel.addConstraints([
            NSLayoutConstraint(item: container, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: descriptionLabel, attribute: .top, multiplier: 1, constant: -8)])
    }
    
    @IBAction func billingNextStepButtonAction(_ sender: Any) {
        if self.inputBillingAddressView == nil {
            if let billingAddress = self.billingAddress {
                if self.checkButton.isSelected {
                    self.shippingAddress = billingAddress
                }
                if let shippingAddress = self.shippingAddress {
                    self.createAddressDetail(address: shippingAddress, container: self.shippingInformationContainer)
                }
            }
        } else {
            if let error = self.validateError(view: self.inputBillingAddressView!) {
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {})
                return
            }
            self.tryAddAddress(view:self.inputBillingAddressView!, defaultBill: 1, defaultShip: self.checkButton.isSelected ? 1 : 0)
        }
    }
    
    fileprivate func tryAddAddress(view: NInputAddressView, defaultBill: Int, defaultShip: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if let authReturn = NAuthReturn.authUser(), let user = authReturn.user {
            NHTTPHelper.httpAddAddressRequest(emailAddress: user.email!, fullname: view.fullnameTextField.text!, address: view.addressTextView.text!, phoneNumber: view.phoneNumberTextfield.text!, provinceId: view.province!.id!, provinceName: view.province!.name!, cityId: view.city!.id!, cityName: view.city!.name!, districtId: view.district!.id!, districtName: view.district!.name!, defaultBill: defaultBill, defaultShip: defaultShip, zipCode: view.zipCodeTextField.text, addressId: nil, label: view.noteTextField.text, complete: {response in
                MBProgressHUD.hide(for: self.view, animated: true)
                if let error = response.error {
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.tryAddAddress(view: view, defaultBill: defaultBill, defaultShip: defaultShip)
                        })
                    } else if error.isKind(of: StatusFailedError.self) {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                            let err = error as! StatusFailedError
                            
                        })
                    }
                    return
                }
                if let data = response.data {
                    if defaultBill == 1 {
                        self.billingAddress = data
                        self.createAddressDetail(address: self.billingAddress!, container: self.personalInformationContainer)
                    }
                    if defaultShip == 1 {
                        self.shippingAddress = data
                        self.createAddressDetail(address: self.shippingAddress!, container: self.shippingInformationContainer)

                    }
                    if self.shippingAddress == nil {
                        
                    }
                }
            })

        }
    }
    
    @IBAction func shippingNextStepButtonAction(_ sender: Any) {
        if let shippingAddress = self.shippingAddress {
            self.createAddressDetail(address: shippingAddress, container: self.shippingInformationContainer)
        } else {
            
        }
    }
    
    @IBAction func checkButtonAction(_ sender: Any) {
        if self.checkButton.isSelected {
            self.checkButton.isSelected = false
        } else {
            self.checkButton.isSelected = true
        }
    }
    
    override func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
        super.keyboardWillShow(keyboardFrame: keyboardFrame, animationDuration: animationDuration)
        UIView.animate(withDuration: animationDuration, animations: {
            self.bottomConstraint.constant = keyboardFrame.height
            self.view.layoutIfNeeded()
        })
    }
    
    override func keyboardWillHide(animationDuration: TimeInterval) {
        super.keyboardWillHide(animationDuration: animationDuration)
        UIView.animate(withDuration: animationDuration, animations: {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func validateError(view: NInputAddressView) -> String? {
        if view.fullnameTextField.text!.isEmpty {
            return "Fullname cannot be empty!"
        } else if view.addressTextView.text!.isEmpty {
            return "Address cannot be empty!"
        } else if view.province == nil {
            return "Province cannot be empty!"
        } else if view.city == nil {
            return "City cannot be empty!"
        } else if view.district == nil {
            return "District cannot be empty!"
        } else if view.phoneNumberTextfield.text!.isEmpty {
            return "Phone number cannot be empty!"
        }
        return nil
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
