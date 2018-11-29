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
    @IBOutlet weak var billingInformationContainer: UIView!
    @IBOutlet weak var personalContainer: UIView!
    @IBOutlet weak var shippingAddressContainer: UIView!
    @IBOutlet weak var shippingInformationContainer: UIView!
    @IBOutlet weak var checkButton: DLRadioButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var billingContentView: UIView!
    @IBOutlet weak var shippingContentView: UIView!
    @IBOutlet weak var courierInformationContainer: UIView!
    @IBOutlet weak var courierContainer: UIView!
    
    fileprivate var inputBillingAddressView: NInputAddressView?
    fileprivate var inputShippingAddressView: NInputAddressView?
    fileprivate var shippingAddress: NAddress?
    fileprivate var billingAddress: NAddress?
    
    var cartReturn: CartReturn?
    var courierViews: [NChooseCourierView]?
//    var couriers: [Courier]? {
//        didSet {
//
//        }
//    }

    static func push(on controller: UINavigationController, cartReturn: CartReturn) -> CheckoutController {
        let vc = CheckoutController(nibName: "CheckoutController", bundle: nil)
        vc.cartReturn = cartReturn
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
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.tryLoadAddress(type: "billing", completion: {
                self.tryLoadAddress(type: "shipping", completion: {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.personalContainer.isHidden = false
                    if self.billingAddress == nil {
                        self.inputBillingAddress()
                    } else {
                        self.createAddressDetail(address: self.billingAddress!, container: self.billingContentView)
                        if self.shippingAddress == nil {
                            self.inputShippingAddress()
                        } else {
                            self.createAddressDetail(address: self.shippingAddress!, container: self.shippingContentView)
                        }

                    }
                })
            })
        }
    }
    
    func tryLoadAddress(type: String, completion: @escaping () -> ()) {
        NHTTPHelper.httpAddressListRequest(type: type, complete: {response in
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadAddress(type: type, completion: completion)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                        
                    })
                }
                return
            }
            if let datas = response.data, !datas.isEmpty {
                self.findDefaultAddresses(addresses: datas, type: type)
            }
            completion()
        })
    }
    
    fileprivate func findDefaultAddresses(addresses: [NAddress], type: String) {
        for address in addresses {
            if type == "shipping" {
                if address.default_shipping == Int16(1) {
                    self.shippingAddress = address
                    break
                }
            }
            
            if type == "billing" {
                if address.default_billling == Int16(1) {
                    self.billingAddress = address
                    break
                }
            }
        }
    }
    
    fileprivate func inputShippingAddress() {
        self.shippingAddressContainer.isHidden = false
        for subview in self.shippingInformationContainer.subviews {
            subview.removeFromSuperview()
        }
        self.inputShippingAddressView = NInputAddressView(delegate: self, textViewDelegate: self)
        self.inputShippingAddressView!.translatesAutoresizingMaskIntoConstraints = false
        self.shippingInformationContainer.addSubview(self.inputShippingAddressView!)
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
    
    fileprivate func inputBillingAddress() {
        for subview in self.billingInformationContainer.subviews {
            subview.removeFromSuperview()
        }
        
        self.inputBillingAddressView = NInputAddressView(delegate: self, textViewDelegate: self)
        self.inputBillingAddressView!.translatesAutoresizingMaskIntoConstraints = false
        self.billingInformationContainer.addSubview(self.inputBillingAddressView!)
        self.billingInformationContainer.translatesAutoresizingMaskIntoConstraints = false
        self.billingInformationContainer.addConstraints([
            NSLayoutConstraint(item: self.billingInformationContainer, attribute: .leading, relatedBy: .equal, toItem: self.inputBillingAddressView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.billingInformationContainer, attribute: .trailing, relatedBy: .equal, toItem: self.inputBillingAddressView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.billingInformationContainer, attribute: .top, relatedBy: .equal, toItem: self.inputBillingAddressView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.billingInformationContainer, attribute: .bottom, relatedBy: .equal, toItem: self.inputBillingAddressView, attribute: .bottom, multiplier: 1, constant: 0)
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
        self.shippingAddressContainer.isHidden = false
        for subview in container.subviews {
            subview.removeFromSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "FiraSans-SemiBold", size: 14)
        titleLabel.text = address.fullname
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont(name: "FiraSans-Regular", size: 14)
        descriptionLabel.text = NHelper.formatAddress(address: address)
        descriptionLabel.numberOfLines = 0
        container.addSubview(titleLabel)
        container.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addConstraints([
            NSLayoutConstraint(item: container, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .top, multiplier: 1, constant: 0)])

        container.addConstraints([
            NSLayoutConstraint(item: container, attribute: .leading, relatedBy: .equal, toItem: descriptionLabel, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container, attribute: .trailing, relatedBy: .equal, toItem: descriptionLabel, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: descriptionLabel, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: descriptionLabel, attribute: .top, multiplier: 1, constant: -8)])
        if container == self.shippingContentView {
            self.createChooseDelivery()
        }
    }
    
    @IBAction func billingNextStepButtonAction(_ sender: Any) {
        if self.inputBillingAddressView == nil {
            if let billingAddress = self.billingAddress {
                if self.checkButton.isSelected {
                    self.shippingAddress = billingAddress
                }
                if let shippingAddress = self.shippingAddress {
                    self.createAddressDetail(address: shippingAddress, container: self.shippingContentView)
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
                if let datas = response.data, !datas.isEmpty {
                    self.findDefaultAddresses(addresses: datas, type: defaultBill == 1 ? "billing" : "shipping")
                    if self.billingAddress == nil {
                        self.inputBillingAddress()
                    } else {
                        self.createAddressDetail(address: self.billingAddress!, container: self.billingContentView)
                    }
                    if self.shippingAddress == nil {
                        self.inputShippingAddress()
                    } else {
                        self.createAddressDetail(address: self.shippingAddress!, container: self.shippingContentView)
                    }
                }
            })

        }
    }
    
    @IBAction func shippingNextStepButtonAction(_ sender: Any) {
        if let shippingAddress = self.shippingAddress {
            self.createAddressDetail(address: shippingAddress, container: self.shippingInformationContainer)
        } else {
            if let error = self.validateError(view: self.inputShippingAddressView!) {
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {})
                return
            }
            self.tryAddAddress(view:self.inputShippingAddressView!, defaultBill: 0, defaultShip: 1)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    fileprivate func createChooseDelivery() {
        self.courierContainer.isHidden = false
        self.courierViews = []
        for subview in self.courierInformationContainer.subviews {
            subview.removeFromSuperview()
        }
        if let cartReturn = self.cartReturn, let cart = cartReturn.cart, let merchants = cart.merchants, !merchants.isEmpty {
            var topView: UIView? = nil
            var i = 0
            for merchant in merchants {
                let view = self.createView(for: merchant)
                self.courierInformationContainer.translatesAutoresizingMaskIntoConstraints = false
                self.courierInformationContainer.addSubview(view)
                self.courierInformationContainer.addConstraints([NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: courierInformationContainer, attribute: .leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: courierInformationContainer, attribute: .trailing, multiplier: 1, constant: 0)])
                if topView == nil {
                    self.courierInformationContainer.addConstraint(NSLayoutConstraint(item: self.courierInformationContainer, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
                } else {
                    self.courierInformationContainer.addConstraint(NSLayoutConstraint(item: topView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 8))
                }
                if i >= merchants.count - 1 {
                    self.courierInformationContainer.addConstraint(NSLayoutConstraint(item: courierInformationContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
                }
                view.onOpenCourierType = {v in
                    if v.pickedCourier == nil {
                        UIAlertController.handleErrorMessage(viewController: self, error: "Please choose courier first!", completion: {})
                        return
                    }
                    self.pickCourierType(courierTypes: v.pickedCourier!.courierTypes!, view: v)
                }
                view.onOpenCourier = {v in
                    self.tryLoadCourier(originId: merchant.districtId!, destinationId: self.shippingAddress!.district!.id!,  weight: Int(ceil(merchant.totalWeight)), view: v)

                }
                topView = view
                self.courierViews!.append(view)
                i+=1
            }
        }
    }
    
    fileprivate func createView(for merchant: Merchant) -> NChooseCourierView {
        let view = NChooseCourierView(delegate: self, textViewDelegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    fileprivate func tryLoadCourier(originId: String, destinationId: String, weight: Int, view: NChooseCourierView) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpDoShopDeliveryCostRequest(originType: "subdistrict", destinationType: "subdistrict", courier: "jne:tiki", weight: weight, originId: originId, destinationId: destinationId, complete: {response in
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadCourier(originId: originId, destinationId: destinationId, weight: weight, view: view)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                        
                    })
                }
                return
            }
            if let datas = response.data, !datas.isEmpty {
//                self.couriers = datas
            }
        })
    }
    
    fileprivate func pickCouriers(couriers: [Courier], view: NChooseCourierView) {
        var cours: [String] = []
        var position = -1
        var i = 0
        for courier in couriers {
            cours.append(courier.name!)
            if let c = view.pickedCourier, c.code == courier.code {
                position = i
            }
            i += 1
        }
        let actionSheet = ActionSheetStringPicker.init(title: "Choose Courier", rows: cours, initialSelection: position >= 0 ? position : 0, doneBlock: {picker, index, value in
            view.pickedCourier = couriers[index]
       }, cancel: {_ in return
        }, origin: self.view)
        actionSheet!.show()
    }
    
    fileprivate func pickCourierType(courierTypes: [CourierType], view: NChooseCourierView) {
        var types: [String] = []
        var position = -1
        var i = 0
        for courierType in courierTypes {
            var type = courierType.service!
            if let costs = courierType.costs, !costs.isEmpty {
                type = "\(type) - \(String(costs[0].value))"
            }
            types.append(type)
            if let t = view.pickedCourierType, t.service == courierType.service {
                position = i
            }
            i += 1
        }
        let actionSheet = ActionSheetStringPicker.init(title: "Choose Courier Types", rows: types, initialSelection: position >= 0 ? position : 0, doneBlock: {picker, index, value in
            view.pickedCourierType = courierTypes[index]
        }, cancel: {_ in return
        }, origin: self.view)
        actionSheet!.show()
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
