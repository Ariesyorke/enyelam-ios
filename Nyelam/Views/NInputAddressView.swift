//
//  NInputAddressView.swift
//  Nyelam
//
//  Created by Bobi on 11/26/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import KMPlaceholderTextView

class NInputAddressView: UIView {
    var contentView: UIView?

    @IBOutlet weak var fullnameTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var phoneNumberTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var zipCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var provinceTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var districtTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var addressTextView: KMPlaceholderTextView!
    @IBOutlet weak var noteTextField: SkyFloatingLabelTextField!
    
    
    var province: NProvince? {
        didSet {
            self.provinceTextField.text = self.province!.name
            self.city = nil
            self.cityTextField.text = ""
            self.district = nil
            self.districtTextField.text = ""
        }
    }
    var city: NCity? {
        didSet {
            if let city = self.city {
                self.cityTextField.text = city.name
                self.district = nil
                self.districtTextField.text = ""
            }
        }
    }
    var district: NDistrict? {
        didSet {
            if let district = self.district {
                self.districtTextField.text = district.name
            }
        }
    }
    
    var onOpenProvince: (NInputAddressView) -> () = {view in}
    var onOpenCity: (NInputAddressView) -> () = {view in}
    var onOpenDistrict: (NInputAddressView) -> () = {view in}
    
    func setDelegate(delegate: UITextFieldDelegate, textViewDelegate: UITextViewDelegate) {
        self.fullnameTextField.delegate = delegate
        self.phoneNumberTextfield.delegate = delegate
        self.districtTextField.delegate = delegate
        self.cityTextField.delegate = delegate
        self.provinceTextField.delegate = delegate
        self.noteTextField.delegate = delegate
        self.addressTextView.delegate = textViewDelegate
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        initView()
    }
    
    init(delegate: UITextFieldDelegate, textViewDelegate: UITextViewDelegate) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        xibSetup()
        initView()
        setDelegate(delegate: delegate, textViewDelegate: textViewDelegate)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
        initView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
        initView()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NInputAddressView", bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    fileprivate func initView() {
        self.addressTextView.layer.borderColor = UIColor.darkGray.cgColor
        self.addressTextView.layer.borderWidth = 1
    }
    
    @IBAction func provinceButtonAction(_ sender: Any) {
        self.onOpenProvince(self)
    }
    
    @IBAction func cityButtonAction(_ sender: Any) {
        self.onOpenCity(self)
    }
    
    @IBAction func districtButtonAction(_ sender: Any) {
        self.onOpenDistrict(self)
    }
    
}
