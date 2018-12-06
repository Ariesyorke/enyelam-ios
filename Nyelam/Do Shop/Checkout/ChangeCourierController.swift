//
//  ChangeCourierController.swift
//  Nyelam
//
//  Created by Bobi on 11/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import KMPlaceholderTextView
import ActionSheetPicker_3_0
import UINavigationControllerWithCompletionBlock
import MBProgressHUD

class ChangeCourierController: BaseViewController {
    var completion: (Int, Courier, CourierType) -> () = {row, courier, courierType in }
    var pickedCourier: Courier? {
        didSet {
            self.pickedCourierType = nil
        }
    }
    var pickedCourierType: CourierType?
    var originAddresId: String?
    var destinationAddressId: String?
    var weight: Int = 0
    var row: Int = 0
    
    @IBOutlet weak var courierTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var courierTypeTextField: SkyFloatingLabelTextField!
    
    static func push(on controller: UINavigationController,
                     row: Int,
                     originAddressId: String,
                     destinationAddressId: String,
                     weight: Int,
                     pickedCourier: Courier?,
                     pickedCourierType: CourierType?,
                     completion: @escaping (Int, Courier, CourierType) -> ()) -> ChangeCourierController {
        let vc = ChangeCourierController(nibName: "ChangeCourierController", bundle: nil)
        vc.row = row
        vc.completion = completion
        vc.pickedCourier = pickedCourier
        vc.pickedCourierType = pickedCourierType
        vc.originAddresId = originAddressId
        vc.destinationAddressId = destinationAddressId
        vc.weight = weight
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let courier = self.pickedCourier, let code = courier.code {
            self.courierTextField.text = code.uppercased()
        }
        
        if let courierType = self.pickedCourierType {
            if let service = courierType.service {
                var type = courierType.service!
                if let costs = courierType.costs, !costs.isEmpty {
                type = "\(type) - \(Double(costs[0].value).toCurrencyFormatString(currency: "Rp"))"
                }
                self.courierTypeTextField.text = type
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func courierButtonAction(_ sender: Any) {
        self.tryLoadCourier(originId: self.originAddresId!, destinationId: self.destinationAddressId!, weight: self.weight)
    }
    
    @IBAction func courierTypeButtonAction(_ sender: Any) {
        if self.pickedCourier == nil {
            UIAlertController.handleErrorMessage(viewController: self, error: "Please pick courier first!", completion: {})
            return
        }
        self.pickCourierType(courierTypes: self.pickedCourier!.courierTypes!)
    }
    
    
    @IBAction func changeCourierButtonAction(_ sender: Any) {
        if let error = self.validateError(courier: self.pickedCourier, courierType: self.pickedCourierType) {
            UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {})
            return
        }
        self.navigationController!.popViewController(animated: true, withCompletionBlock: {
            self.completion(self.row, self.pickedCourier!, self.pickedCourierType!)
        })
    }
    
    fileprivate func validateError(courier: Courier?, courierType: CourierType?) -> String? {
        if courier == nil {
            return "Please pick courier first!"
        } else if courierType == nil {
            return "Pleasee pick courier type first!"
        }
        return nil
    }
    
    fileprivate func tryLoadCourier(originId: String, destinationId: String, weight: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpDoShopDeliveryCostRequest(originType: "subdistrict", destinationType: "subdistrict", courier: "jne:tiki:jnt", weight: weight, originId: originId, destinationId: destinationId, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadCourier(originId: originId, destinationId: destinationId, weight: weight)
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                        let err = error as! StatusFailedError
                        
                    })
                }
                return
            }
            if let datas = response.data, !datas.isEmpty {
                self.pickCouriers(couriers: datas)
            }
        })
    }
    
    fileprivate func pickCouriers(couriers: [Courier]) {
        var cours: [String] = []
        var position = -1
        var i = 0
        for courier in couriers {
            cours.append(courier.name!)
            if let c = self.pickedCourier, c.code == courier.code {
                position = i
            }
            i += 1
        }
        let actionSheet = ActionSheetStringPicker.init(title: "Choose Courier", rows: cours, initialSelection: position >= 0 ? position : 0, doneBlock: {picker, index, value in
            self.pickedCourier = couriers[index]
            self.courierTextField.text = self.pickedCourier!.code!.uppercased()
            self.courierTypeTextField.text = "-"
        }, cancel: {_ in return
        }, origin: self.view)
        actionSheet!.show()
    }
    
    fileprivate func pickCourierType(courierTypes: [CourierType]) {
        var types: [String] = []
        var position = -1
        var i = 0
        for courierType in courierTypes {
            var type = courierType.service!
            if let costs = courierType.costs, !costs.isEmpty {
                type = "\(type) - \(String(costs[0].value))"
            }
            types.append(type)
            if let t = self.pickedCourierType, t.service == courierType.service {
                position = i
            }
            i += 1
        }
        let actionSheet = ActionSheetStringPicker.init(title: "Choose Courier Types", rows: types, initialSelection: position >= 0 ? position : 0, doneBlock: {picker, index, value in
            self.pickedCourierType = courierTypes[index]
            var t = self.pickedCourierType!.service!
            if let costs = self.pickedCourierType!.costs, !costs.isEmpty {
                t = "\(t) - \(String(costs[0].value))"
            }
            self.courierTypeTextField.text = t
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
