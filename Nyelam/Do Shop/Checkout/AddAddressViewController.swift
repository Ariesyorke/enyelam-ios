//
//  AddAddressViewController.swift
//  Nyelam
//
//  Created by Bobi on 11/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import KMPlaceholderTextView
import MBProgressHUD
import ActionSheetPicker_3_0
import DLRadioButton
import UINavigationControllerWithCompletionBlock

class AddAddressViewController: BaseViewController, UITextViewDelegate {
    @IBOutlet weak var fullnameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var provinceTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var postalCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var noteTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var addressTextField: KMPlaceholderTextView!
    @IBOutlet weak var districtTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkButtonContainer: UIControl!
    @IBOutlet weak var checkButton: DLRadioButton!
    
    
    var defaultShip: Int = 0
    var defaultBill: Int = 0
    var address: NAddress?
    var successCompletion: (Bool, NAddress) -> () = {shipsameasbill, address in }
    
    static func push(on controller: UINavigationController, defaultShipping: Int, defaultBillng: Int, successCompletion: @escaping (Bool, NAddress) -> ()) -> AddAddressViewController {
        let vc = AddAddressViewController(nibName: "AddAddressViewController", bundle: nil)
        vc.defaultShip = defaultShipping
        vc.defaultBill = defaultBillng
        controller.pushViewController(vc, animated: true)
        vc.successCompletion = successCompletion
        return vc
    }
    
    static func push(on controller: UINavigationController, defaultShipping: Int, defaultBillng: Int, address: NAddress, successCompletion: @escaping (Bool, NAddress) -> ()) -> AddAddressViewController {
        let vc = AddAddressViewController(nibName: "AddAddressViewController", bundle: nil)
        vc.defaultShip = defaultShipping
        vc.defaultBill = defaultBillng
        vc.address = address
        controller.pushViewController(vc, animated: true)
        vc.successCompletion = successCompletion
        return vc
    }
    
    fileprivate var province: NProvince? {
        didSet {
            self.provinceTextField.text = self.province!.name
            self.city = nil
            self.cityTextField.text = ""
            self.district = nil
            self.districtTextField.text = ""
        }
    }
    
    fileprivate var city: NCity? {
        didSet {
            if let city = self.city {
                self.cityTextField.text = city.name
                self.district = nil
                self.districtTextField.text = ""
            }
        }
    }
    fileprivate var district: NDistrict?  {
        didSet {
            if let district = self.district {
                self.districtTextField.text = district.name
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Address"
        self.fullnameTextField.delegate = self
        self.provinceTextField.delegate = self
        self.cityTextField.delegate = self
        self.postalCodeTextField.delegate = self
        self.noteTextField.delegate = self
        self.addressTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        self.districtTextField.delegate = self
        self.addressTextField.layer.borderWidth = 1
        self.addressTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        if self.defaultShip == 1 {
            self.checkButtonContainer.isHidden = false
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func keyboardWillHide(animationDuration: TimeInterval) {
        super.keyboardWillHide(animationDuration: animationDuration)
        UIView.animate(withDuration: animationDuration, animations: {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    override func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
        super.keyboardWillShow(keyboardFrame: keyboardFrame, animationDuration: animationDuration)
        UIView.animate(withDuration: animationDuration, animations: {
            self.bottomConstraint.constant = keyboardFrame.height
            self.view.layoutIfNeeded()
        })
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.fullnameTextField {
            self.addressTextField.becomeFirstResponder()
        } else if textField == self.postalCodeTextField {
            self.phoneNumberTextField.becomeFirstResponder()
        } else if textField == self.phoneNumberTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func provinceButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.tryLoadProvince()
    }
    @IBAction func cityButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if self.province == nil {
            UIAlertController.handleErrorMessage(viewController: self, error: "Please pick province first!", completion: {})
            return
        }
        self.view.endEditing(true)
        self.tryLoadCity(provinceId: self.province!.id!)

    }
    @IBAction func districtButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if self.city == nil {
            UIAlertController.handleErrorMessage(viewController: self, error: "Please pick city first!", completion: {})
            return
        }
        self.view.endEditing(true)
        self.tryLoadDistrict(cityId: self.city!.id!)
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        let fullname  = self.fullnameTextField.text!
        let phoneNumber = self.phoneNumberTextField.text!
        let zipCode = self.postalCodeTextField.text!
        let note = self.noteTextField.text!
        let address = self.addressTextField.text!
        let emailAddress = NAuthReturn.authUser()!.user!.email!
        if let error = self.validateError(fullname: fullname, address: address, province: self.province, city: self.city, district: self.district, phoneNumber: phoneNumber) {
            UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {})
            return
        }
        if let addr = self.address {
            self.tryEditAddress(addressId: addr.addressId!, emailAddress: emailAddress, fullname: fullname, phoneNumber: phoneNumber, zipCode: zipCode, note: note, address: address, province: self.province!, city: self.city!, district: self.district!, defaultBilling: self.defaultBill, defaultShipping: self.checkButton.isSelected ? 1 : self.defaultShip)
        } else {
           self.tryAddAddress(emailAddress: emailAddress, fullname: fullname, phoneNumber: phoneNumber, zipCode: zipCode, note: note, address: address, province: self.province!, city: self.city!, district: self.district!, defaultBilling: self.defaultBill, defaultShipping: self.checkButton.isSelected ? 1 : self.defaultShip)
        }
        
    }
    fileprivate func tryEditAddress(addressId: String, emailAddress: String, fullname: String, phoneNumber: String, zipCode: String, note: String, address: String, province: NProvince, city: NCity, district: NDistrict, defaultBilling: Int, defaultShipping: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpEditAddressRequest(addressId: addressId, emailAddress: emailAddress, fullname: fullname, address: address, phoneNumber: phoneNumber, provinceId: province.id!, provinceName: province.name!, cityId: city.id!, cityName: city.name!, districtId: district.id!, districtName: district.name!, defaultBill: defaultBilling, defaultShip: defaultBilling, zipCode: zipCode, label: note, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryAddAddress(emailAddress: emailAddress, fullname: fullname, phoneNumber: phoneNumber, zipCode: zipCode, note: note, address: emailAddress, province: province, city: city, district: district, defaultBilling: defaultBilling, defaultShipping: defaultShipping)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                        
                    })
                }
                return
            }
            if let datas = response.data, !datas.isEmpty {
                UIAlertController.handlePopupMessage(viewController: self, title: "Address successfully added!", actionButtonTitle: "OK", completion: {
                    self.findAddress(addresses: datas)
                })
            }
            
        })

    }
    fileprivate func tryAddAddress(emailAddress: String, fullname: String, phoneNumber: String, zipCode: String, note: String, address: String, province: NProvince, city: NCity, district: NDistrict, defaultBilling: Int, defaultShipping: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpAddAddressRequest(emailAddress: emailAddress, fullname: fullname, address: address, phoneNumber: phoneNumber, provinceId: province.id!, provinceName: province.name!, cityId: city.id!, cityName: city.name!, districtId: district.id!, districtName: district.name!, defaultBill: defaultBilling, defaultShip: defaultBilling, zipCode: zipCode, label: note, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryAddAddress(emailAddress: emailAddress, fullname: fullname, phoneNumber: phoneNumber, zipCode: zipCode, note: note, address: emailAddress, province: province, city: city, district: district, defaultBilling: defaultBilling, defaultShipping: defaultShipping)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                        
                    })
                }
                return
            }
            if let datas = response.data, !datas.isEmpty {
                UIAlertController.handlePopupMessage(viewController: self, title: "Address successfully added!", actionButtonTitle: "OK", completion: {
                    self.findAddress(addresses: datas)
                })
            }

        })
    }
    fileprivate func tryLoadProvince() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpGetProvince(complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadProvince()
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let _ = error as! StatusFailedError
                    })
                }
                return
            }
            if let datas = response.data, !datas.isEmpty {
                self.pickProvince(provinces: datas)
            }
        })
    }
    
    fileprivate func tryLoadCity(provinceId: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpGetCity(provinceId: provinceId, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadCity(provinceId: provinceId)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let _ = error as! StatusFailedError
                        
                    })
                }
                return
            }
            
            if let datas = response.data, !datas.isEmpty {
                self.pickCity(cities: datas)
            }
        })
    }

    
    fileprivate func tryLoadDistrict(cityId: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpGetDistrict(cityId: cityId, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadDistrict(cityId: cityId)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                        
                    })
                }
                return
            }
            if let datas = response.data, !datas.isEmpty {
                self.pickDistrict(districts: datas)
            }
        })
    }

    
    fileprivate func pickProvince(provinces: [NProvince]) {
        var provs: [String] = []
        var position = -1
        var i = 0
        for province in provinces {
            provs.append(province.name!)
            if let p = self.province, p.id == province.id {
                position = i
            }
            i += 1
        }
        let actionSheet = ActionSheetStringPicker.init(title: "Choose Province", rows: provs, initialSelection: position >= 0 ? position : 0, doneBlock: {picker, index, value in
            self.province = provinces[index]
        }, cancel: {_ in return
        }, origin: self.view)
        actionSheet!.show()
    }
    
    fileprivate func pickDistrict(districts: [NDistrict]) {
        var distrs: [String] = []
        var position = -1
        var i = 0
        for district in districts {
            distrs.append(district.name!)
            if let d = self.district, d.id == district.id {
                position = i
            }
            i+=1
        }
        let actionSheet = ActionSheetStringPicker.init(title: "Choose District", rows: distrs, initialSelection: position >= 0 ? position : 0, doneBlock: {picker, index, value in
            self.district = districts[index]
        }, cancel: {_ in return
        }, origin: self.view)
        actionSheet!.show()
    }
    
    fileprivate func pickCity(cities: [NCity]) {
        var cits: [String] = []
        var position = -1
        var i = 0
        for city in cities {
            cits.append(city.name!)
            if let c = self.city, c.id == city.id {
                position = i
            }
            i+=1
        }
        let actionSheet = ActionSheetStringPicker.init(title: "Choose City", rows: cits, initialSelection: position >= 0 ? position : 0, doneBlock: {picker, index, value in
            self.city = cities[index]
        }, cancel: {_ in return
        }, origin: self.view)
        actionSheet!.show()
    }

    fileprivate func validateError(fullname: String, address: String, province: NProvince?, city: NCity?, district: NDistrict?, phoneNumber: String) -> String? {
        if fullname.isEmpty {
            return "Fullname cannot be empty!"
        } else if address.isEmpty {
            return "Address cannot be empty!"
        } else if province == nil {
            return "Province cannot be empty!"
        } else if city == nil {
            return "City cannot be empty!"
        } else if district == nil {
            return "District cannot be empty!"
        } else if phoneNumber.isEmpty {
            return "Phone number cannot be empty!"
        }
        return nil
    }

    @IBAction func checkButtonAction(_ sender: Any) {
        if self.checkButton.isSelected {
            self.checkButton.isSelected = false
        } else {
            self.checkButton.isSelected = true
        }
    }
    
    func findAddress(addresses: [NAddress]) {
        for address in addresses {
            if self.defaultBill == 1 {
                if address.default_billling == Int16(1) {
                    self.navigationController!.popViewController(animated: true, withCompletionBlock: {
                        self.successCompletion(self.checkButton.isSelected, address)
                    })
                    break
                }
            }
            if self.defaultShip == 1 {
                if address.default_shipping == Int16(1) {
                    self.navigationController!.popViewController(animated: true, withCompletionBlock: {
                        self.successCompletion(self.checkButton.isSelected, address)
                    })
                    break
                }
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
