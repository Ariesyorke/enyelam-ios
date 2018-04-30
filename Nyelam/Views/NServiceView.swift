//
//  NServiceView.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/11/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import Cosmos

@IBDesignable
class NServiceView: UIView {
    
    var contentView: UIView?
    
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var serviceStartDateEndDateLabel: UILabel!
    @IBOutlet weak var totalDivesLabel: UILabel!
    @IBOutlet weak var totalDaysLabel: UILabel!
    @IBOutlet weak var normalPriceLabel: UILabel!
    @IBOutlet weak var specialPriceLabel: UILabel!
    @IBOutlet weak var linceseNeededImageView: UIImageView!
    @IBOutlet weak var control: UIControl!
    @IBOutlet weak var scheduleHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var diveDaysVerticalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var specialPriceVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var normalPriceContainerView: UIView!
    @IBOutlet weak var rateView: CosmosView!
    
    var isDoTrip: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    init() {
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
        let nib = UINib(nibName: "NServiceView", bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }

    func addTarget(_ target: Any?, action: Selector) {
        self.control.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
    }
    
    func initData(diveService: NDiveService) {
        self.serviceNameLabel.text = diveService.name
        self.totalDivesLabel.text = String(diveService.totalDives) + " Dive" + (diveService.totalDives>1 ? "s" : "")
        self.totalDaysLabel.text = String(diveService.totalDays) + " Day" + (diveService.totalDays>1 ? "s" : "")
        if let url = diveService.featuredImage {
           self.serviceImageView.loadImage(from: url, contentMode: .scaleAspectFill, with: "bg_placeholder.png")
        }
        if let schedule = diveService.schedule {
            let startDate = Date(timeIntervalSince1970: schedule.startDate).formatDate(dateFormat: "MMMM yyyy")
            let endDate = Date(timeIntervalSince1970: schedule.endDate).formatDate(dateFormat: "MMMM yyyy")
            self.serviceStartDateEndDateLabel.text = "\(startDate) - \(endDate)"
        }
        
        if isDoTrip {
            self.diveDaysVerticalSpacingConstraint.constant = 8
            self.scheduleHeightConstant.constant = 18
            self.serviceStartDateEndDateLabel.isHidden = false
        } else {
            self.diveDaysVerticalSpacingConstraint.constant = 0
            self.scheduleHeightConstant.constant = 0
            self.serviceStartDateEndDateLabel.isHidden = true
        }
        
        self.normalPriceLabel.text = diveService.normalPrice.toCurrencyFormatString(currency: "Rp.")
        self.specialPriceLabel.text = diveService.specialPrice.toCurrencyFormatString(currency:"Rp.")
        if diveService.normalPrice == diveService.specialPrice {
            self.normalPriceContainerView.isHidden = true
        } else {
            self.normalPriceContainerView.isHidden = false
        }
        
        if diveService.license {
            self.linceseNeededImageView.image = UIImage(named: "icon_license_on")
        } else {
            self.linceseNeededImageView.image = UIImage(named: "icon_license_off")
        }
        self.rateView.rating = Double(Int(diveService.rating))
    }
}
