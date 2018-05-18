//
//  EditProfileViewController.swift
//  Nyelam
//
//  Created by Bobi on 4/16/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MMNumberKeyboard
import ActionSheetPicker_3_0
import MBProgressHUD
import CoreData

class EditProfileViewController: BaseViewController, MMNumberKeyboardDelegate {
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var genderTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var birthPlaceTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var birthdateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var countryTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var nationalityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var languageTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var certificateDateTextFIeld: SkyFloatingLabelTextField!
    @IBOutlet weak var certificateNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var bottomScrollView: NSLayoutConstraint!
    @IBOutlet weak var organizatinLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var licenseTypeLabel: SkyFloatingLabelTextField!
    
    var phoneRegionCode: String = "ID"
    var userRegionCode: String = "ID"
    
    var countryCodes: [NCountryCode]? = NCountryCode.getCountryCodes()
    var languages: [NLanguage]? = NLanguage.getLanguages()
    var numberKeyboard: MMNumberKeyboard?
    var pickedCountryCode: NCountryCode?
    var pickedCountry: NCountry?
    var pickedLanguage: NLanguage?
    var pickedNationality: NNationality?
    var pickedBirthdate: Date?
    var pickedCertificateDate: Date?
    var pickedGender: String?
    var pickedOrganization: NMasterOrganization?
    var pickedLicenseType: NLicenseType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initData()
        self.title = "Edit Profile"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateButtonAction(_ sender: Any) {
        let firstName = self.firstNameTextField.text!
        let lastName = self.lastNameTextField.text!
        let emailAddress = self.emailTextField.text!
        let phoneNumber = self.phoneNumberTextField.text!
        let birthPlace = self.birthPlaceTextField.text!
        let birthDate = self.pickedBirthdate
        let certificateDate = self.pickedCertificateDate
        let pickedGender = self.pickedGender
        let countryId = self.pickedCountry?.id
        let languageId = self.pickedLanguage?.id
        let countryCodeId = self.pickedCountryCode?.id
        let nationalityId = self.pickedNationality?.id
        let organizationId = self.pickedOrganization?.id
        let licenseTypeId = self.pickedLicenseType?.id
        let certificateNumber = self.certificateNumberTextField.text
        if let error = validateError(firstName: firstName, phoneNumber: phoneNumber) {
            UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {
                
            })
            return
        }
        var fullName = firstName
        if !lastName.isEmpty {
            fullName = ("\(firstName) \(lastName)")
        }

        self.tryEditProfile(fullname: fullName, countryCode: countryCodeId!, emailAddress: emailAddress, phoneNumber: phoneNumber, gender: pickedGender, birthPlace: birthPlace, birthDate: pickedBirthdate, countryId: countryId, nationalityId: nationalityId, languageId: languageId, certificateDate: certificateDate, certificateNumber: certificateNumber, organizationId: organizationId, licenseTypeId: licenseTypeId)
    }
    
    @IBAction func certificateDateButtonAction(_ sender: Any) {
        let datePickerController = DTMDatePickerController(nibName: "DTMDatePickerController", bundle: nil)
        datePickerController.modalPresentationStyle = .popover
        datePickerController.preferredContentSize = CGSize(width: self.view.frame.width/2, height: self.view.frame.height/2)
        if let pickedDate = self.pickedCertificateDate {
            datePickerController.defaultDate = pickedDate
        }
        datePickerController.onDatePickedHandler = {controller, date in
            self.pickedCertificateDate = date
            self.certificateDateTextFIeld.text = date.formatDate(dateFormat: "dd/MM/yyyy")
        }
        self.present(datePickerController, animated: true, completion: nil)
        let popoverPresentationController = datePickerController.popoverPresentationController
        popoverPresentationController!.sourceView = sender as? UIView
        popoverPresentationController!.sourceRect = CGRect(x: 0, y: 0, width: (sender as AnyObject).frame.size.width, height: (sender as AnyObject).frame.size.height)
    }
    
    @IBAction func languageButtonAction(_ sender: Any) {
        if let languages = self.languages, !languages.isEmpty {
            var c: [String] = []
            for language in languages {
                c.append(language.name!)
            }
            let position = self.pickedLanguage != nil ? NLanguage.getPosition(by: self.pickedLanguage!.id!) : 0
            let actionSheet = ActionSheetStringPicker.init(title: "Language", rows: c, initialSelection: position, doneBlock: {picker, index, value in
                self.pickedLanguage = languages[index]
                self.languageTextField.text = value as! String
            }, cancel: {_ in return
            }, origin: sender)
            actionSheet!.show()
        }
    }
    @IBAction func nationalityButtonAction(_ sender: Any) {
        if let pickedCountry = pickedCountry {
            self.nationalityTextField.text = ""
            self.pickedNationality = nil
            self.tryGetNationality(countryId: pickedCountry.id!, sender: sender)
        }
    }
    @IBAction func countryButtonAction(_ sender: Any) {
        if let countryCodes = self.countryCodes, !countryCodes.isEmpty {
            var c: [String] = []
            for countryCode in countryCodes {
                if let countryName = countryCode.countryName {
                    c.append("\(countryName)")
                }
            }
            let actionSheet = ActionSheetStringPicker.init(title: "Country", rows: c, initialSelection: NCountryCode.getPosition(by: self.userRegionCode), doneBlock: {picker, index, value in
                let countryCode = countryCodes[index]
                self.countryTextField.text = countryCode.countryName
                self.pickedCountry = NCountry.getCountry(using: countryCode.id!)
                if self.pickedCountry == nil {
                    self.pickedCountry = NCountry.init(entity: NSEntityDescription.entity(forEntityName: "NCountry", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                }
                self.pickedCountry!.name = countryCode.countryName
                self.pickedCountry!.id = countryCode.id
                NSManagedObjectContext.saveData()
            }, cancel: {_ in return

            }, origin: sender)

            actionSheet!.show()
        }
    }
    @IBAction func birthdateButtonAction(_ sender: Any) {
        let datePickerController = DTMDatePickerController(nibName: "DTMDatePickerController", bundle: nil)
        datePickerController.modalPresentationStyle = .popover
        if let pickedDate = self.pickedBirthdate {
            datePickerController.defaultDate = pickedDate
        }
        datePickerController.preferredContentSize = CGSize(width: self.view.frame.width/2, height: self.view.frame.height/2)
        datePickerController.onDatePickedHandler = {controller, date in
            self.pickedBirthdate = date
            self.birthdateTextField.text = date.formatDate(dateFormat: "dd/MM/yyyy")
        }
        self.present(datePickerController, animated: true, completion: nil)
        let popoverPresentationController = datePickerController.popoverPresentationController
        popoverPresentationController!.sourceView = sender as? UIView
        popoverPresentationController!.sourceRect = CGRect(x: 0, y: 0, width: (sender as AnyObject).frame.size.width, height: (sender as AnyObject).frame.size.height)
    }
    @IBAction func organizationButtonAction(_ sender: Any) {
        self.onShowMasterOrganization()
    }
    
    @IBAction func licenseButtonAction(_ sender: Any) {
        if self.pickedOrganization == nil {
            UIAlertController.handleErrorMessage(viewController: self, error: "Please choose organization first!", completion: {})
            return
        }
        self.onShowLicenseType(organizaitonId: self.pickedOrganization!.id!)
    }
    
    
    @IBAction func genderButtonAction(_ sender: Any) {
        var genders: [String] = ["Male", "Female"]
        var position = 0
        if let gender = self.pickedGender {
            if gender.lowercased() == "1" {
                position = 0
            } else {
                position = 1
            }
        }
        let actionSheet = ActionSheetStringPicker.init(title: "Gender", rows: genders, initialSelection: position, doneBlock: {picker, index, value in
            self.pickedGender = String(index + 1)
            self.genderTextField.text = value as! String
        }, cancel: {_ in return
        }, origin: sender)
        actionSheet!.show()
    }
    
    @IBAction func countryCodeButtonAction(_ sender: Any) {
        if let countryCodes = self.countryCodes, !countryCodes.isEmpty {
            var c: [String] = []
            for countryCode in countryCodes {
                if let number = countryCode.countryNumber, let countryName = countryCode.countryName {
                    c.append("+\(number) \(countryName)")
                }
            }
            
            let actionSheet = ActionSheetStringPicker.init(title: "Country Code", rows: c, initialSelection: NCountryCode.getPosition(by: self.phoneRegionCode), doneBlock: {picker, index, value in
                self.pickedCountryCode = countryCodes[index]
                self.phoneRegionCode = countryCodes[index].countryCode!
                self.countryCodeLabel.text = ("+ \(countryCodes[index].countryNumber!)")
            }, cancel: {_ in return
                
            }, origin: sender)
            
            actionSheet!.show()
        }
    }
    
    internal func initView() {
        self.numberKeyboard = MMNumberKeyboard(frame: CGRect.zero)
        self.numberKeyboard!.returnKeyTitle = "Done"
        self.numberKeyboard!.allowsDecimalPoint = false
        self.numberKeyboard!.delegate = self
        self.birthPlaceTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        self.genderTextField.delegate = self
        self.birthdateTextField.delegate = self
        self.countryTextField.delegate = self
        self.nationalityTextField.delegate = self
        self.languageTextField.delegate = self
        self.certificateDateTextFIeld.delegate = self
        self.certificateNumberTextField.delegate = self
        self.phoneNumberTextField.inputView = self.numberKeyboard
    }
    
    internal func initData() {
        if let authReturn = NAuthReturn.authUser(), let user = authReturn.user {
            if let fullname = user.fullname, !fullname.isEmpty {
                var names: [String] = user.fullname!.components(separatedBy: " ")
                self.firstNameTextField.text = names[0]
                self.lastNameTextField.text = names[1]
            }
            self.emailTextField.text = user.email
            self.phoneNumberTextField.text = user.phone
            if let countryCode = user.countryCode, let countryNumber = countryCode.countryNumber {
                self.pickedCountryCode = user.countryCode
                self.countryCodeLabel.text = ("+\(countryNumber)")
                self.phoneRegionCode = countryCode.countryCode!
            } else {
                self.pickedCountryCode =  NCountryCode.getCountryCode(by: self.phoneRegionCode)
                self.countryCodeLabel.text = ("+\(self.pickedCountryCode!.countryNumber!)")
            }
            if let country = user.country {
                self.pickedCountry = country
                self.countryTextField.text = country.name
                let countryCode = NCountryCode.getCountryCode(with: country.id!)!
                self.userRegionCode = countryCode.countryCode!
            }
            
            self.genderTextField.text = user.gender
            if let birthDate = user.birthDate {
                self.birthdateTextField.text = birthDate.formatDate(dateFormat: "dd/MM/yyyy")
            }
            if let certificateDate = user.certificateDate {
                self.certificateDateTextFIeld.text = certificateDate.formatDate(dateFormat: "dd/MM/yyyy")
            }
            self.certificateNumberTextField.text = user.certificateNumber
            if let country = user.country {
                self.pickedCountry = country
                self.countryTextField.text = country.name
            }
            if let nationality = user.nationality {
                self.pickedNationality = nationality
                self.nationalityTextField.text = nationality.name
            }
            if let language = user.language {
                self.languageTextField.text = language.name
            }
            if let organization = user.organization {
                self.pickedOrganization = organization
                self.organizatinLabel.text = organization.name
            }
            if let licenseType = user.licenseType {
                self.pickedLicenseType = licenseType
                self.licenseTypeLabel.text = licenseType.name
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func keyboardWillHide(animationDuration: TimeInterval) {
        super.keyboardWillHide(animationDuration: animationDuration)
        super.keyboardWillHide(animationDuration: animationDuration)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration) {
            self.bottomScrollView.constant = 0
            self.view.layoutIfNeeded()
        }

    }
    
    override func keyboardWillShow(keyboardFrame: CGRect, animationDuration: TimeInterval) {
        super.keyboardWillShow(keyboardFrame: keyboardFrame, animationDuration: animationDuration)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration) {
            self.bottomScrollView.constant = keyboardFrame.height
            self.view.layoutIfNeeded()
        }
    }
    
    func numberKeyboardShouldReturn(_ numberKeyboard: MMNumberKeyboard!) -> Bool {
        numberKeyboard.resignFirstResponder()
        return true
    }
    
    internal func tryGetNationality(countryId: String, sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpGetMasterNationality(countryId: countryId, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryGetNationality(countryId: countryId, sender: sender)
                    })
                }
                return
            }
            if let nationalities = response.data, !nationalities.isEmpty {
                var c: [String] = []
                for nationality in nationalities {
                    c.append(nationality.name!)
                }
                let actionSheet = ActionSheetStringPicker.init(title: "Nationality", rows: c, initialSelection: 0, doneBlock: {picker, index, value in
                    self.pickedNationality = nationalities[index]
                    self.nationalityTextField.text = value as! String
                }, cancel: {_ in return
                }, origin: sender)
                actionSheet!.show()
            }
        })
    }
    
    internal func validateError(firstName: String, phoneNumber: String) -> String? {
        if firstName.isEmpty {
            return "First name cannot be empty"
        } else if phoneNumber.isEmpty {
            return "Phone number cannot be empty"
        }
        return nil
    }
    
    internal func tryEditProfile(fullname: String, countryCode: String, emailAddress: String, phoneNumber: String, gender: String?, birthPlace: String?, birthDate: Date?, countryId: String?, nationalityId: String?, languageId: String?, certificateDate: Date?, certificateNumber: String?, organizationId: String?, licenseTypeId: String?) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpUpdateProfile(fullname: fullname, username: nil, gender: gender, birthDate: birthDate, countryCodeId: countryCode, phoneNumber: phoneNumber, certificateDate: certificateDate, certificateNumber: certificateNumber, birthPlace: birthPlace, countryId: countryId, nationalityId: nationalityId, languageId: languageId, organizationId: organizationId, licenseTypeId: licenseTypeId, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)

            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryEditProfile(fullname: fullname, countryCode: countryCode, emailAddress: emailAddress, phoneNumber: phoneNumber, gender: gender, birthPlace: birthPlace, birthDate: birthDate, countryId: countryId, nationalityId: nationalityId, languageId: languageId, certificateDate: certificateDate, certificateNumber: certificateNumber, organizationId: organizationId, licenseTypeId: licenseTypeId)
                    })
                }
                return
            }
            UIAlertController.handlePopupMessage(viewController: self, title: "Update Profile Successfull", actionButtonTitle: "OK", completion: {
                if let navigation = self.navigationController {
                    navigation.popViewController(animated: true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        })
    }
    
    internal func onShowMasterOrganization() {
        if let organizations = NMasterOrganization.getOrganizations(), !organizations.isEmpty {
            var c: [String] = []
            for organization in organizations {
                c.append(organization.name!)
            }
            let actionSheet = ActionSheetStringPicker.init(title: "Association", rows: c, initialSelection: self.pickedOrganization != nil ? NMasterOrganization.getPosition(by: self.pickedOrganization!.id!) : 0, doneBlock: {picker, index, value in
                self.pickedOrganization = organizations[index]
                self.pickedLicenseType = nil
                self.licenseTypeLabel.text = ""
                self.organizatinLabel.text = self.pickedOrganization!.name
            }, cancel: {_ in return
            }, origin: self.view)
            actionSheet!.show()
        }
    }
    
    internal func onShowLicenseType(organizaitonId: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpGetLicenseType(organizationId: organizaitonId, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.onShowLicenseType(organizaitonId: organizaitonId)
                    })
                }
                return
            }
            if let licenseTypes = response.data, !licenseTypes.isEmpty {
                var c: [String] = []
                for licenseType in licenseTypes {
                    c.append(licenseType.name!)
                }
                let actionSheet = ActionSheetStringPicker.init(title: "License Type", rows: c, initialSelection: 0, doneBlock: {picker, index, value in
                    self.pickedLicenseType = licenseTypes[index]
                    self.licenseTypeLabel.text = self.pickedLicenseType!.name
                }, cancel: {_ in return
                }, origin: self.view)
                actionSheet!.show()
            } else {
                UIAlertController.handleErrorMessage(viewController: self, error: "License not found!", completion: {})
            }
        })
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
