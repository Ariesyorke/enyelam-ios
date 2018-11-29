//
//  ChooseCourierView.swift
//  Nyelam
//
//  Created by Bobi on 11/28/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import KMPlaceholderTextView

class NChooseCourierView: UIView {
    var contentView: UIView?
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var productViewContainer: UIView!
    @IBOutlet weak var noteTextField: KMPlaceholderTextView!
    @IBOutlet weak var courierTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var courierTypeTextField: SkyFloatingLabelTextField!
    var pickedCourier: Courier? {
        didSet {
            if let courier = self.pickedCourier {
                self.courierTextField.text = courier.name
                self.pickedCourierType = nil
            } else {
                self.courierTextField.text = "-"
            }
        }
    }
    
    var pickedCourierType: CourierType? {
        didSet {
            if let courierType = self.pickedCourierType {
                var type = courierType.service
                if let costs = courierType.costs {
                    type = ("\(courierType) - \(String(costs[0].value))")
                }
                self.courierTypeTextField.text = type
            } else {
                self.courierTypeTextField.text = "-"
            }
        }
    }
    var onOpenCourier: (NChooseCourierView) -> () = {view in}
    var onOpenCourierType: (NChooseCourierView) -> () = {view in}
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    init(delegate: UITextFieldDelegate, textViewDelegate: UITextViewDelegate) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        xibSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
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
        let nib = UINib(nibName: "NChooseCourierView", bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }

    @IBAction func courierButtonAction(_ sender: Any) {
        self.onOpenCourier(self)
    }
    
    @IBAction func courierTybeButtonAction(_ sender: Any) {
        self.onOpenCourierType(self)
    }
    
    fileprivate func setDelegate(delegate: UITextFieldDelegate, textDelegate: UITextViewDelegate) {
        self.noteTextField.delegate = textDelegate
    }
    
    fileprivate func initView() {
        self.noteTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.noteTextField.layer.borderWidth = 1
    }
        
}
