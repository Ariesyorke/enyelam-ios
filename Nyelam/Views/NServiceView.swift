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
    @IBOutlet weak var diveCenterName: UILabel!
    
    @IBOutlet weak var rateView: CosmosView!
    var isDoTrip: Bool = false
    var isDoCourse: Bool = false
    
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
        self.translatesAutoresizingMaskIntoConstraints = false
        self.serviceNameLabel.text = diveService.name
        if self.isDoCourse {
//            self.totalDivesLabel.text = String(diveService.totalDives) + " Dive" + (diveService.totalDives>1 ? "s" : "")
            
            self.totalDivesLabel.text = String(diveService.totalDays) + " Day" + (diveService.totalDays>1 ? "s" : "") + " class"
            self.totalDaysLabel.text = String(diveService.dayOnSite) + " Day" +
                (diveService.dayOnSite>1 ? "s" : "") + " on-site"
        } else {
            self.totalDivesLabel.text = String(diveService.totalDives) + " Dive" + (diveService.totalDives>1 ? "s" : "")
            self.totalDaysLabel.text = String(diveService.totalDays) + " Day" + (diveService.totalDays>1 ? "s" : "")
        }
        if let featuredImage = diveService.featuredImage, let url = URL(string: featuredImage) {
            self.serviceImageView.af_setImage(withURL: url, placeholderImage: UIImage(named: "bg_placeholder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: true, completion: nil)
//           self.serviceImageView.loadImage(from: url, contentMode: .scaleAspectFill, with: "bg_placeholder.png")
        } else {
            self.serviceImageView.image = UIImage(named: "bg_placeholder")
        }
        if let schedule = diveService.schedule {
            let startDate = Date(timeIntervalSince1970: schedule.startDate).formatDate(dateFormat: "dd MMM yyyy")
            let endDate = Date(timeIntervalSince1970: schedule.endDate).formatDate(dateFormat: "dd MMM yyyy")
            self.serviceStartDateEndDateLabel.text = "\(startDate) - \(endDate)"
        }
        
        if self.isDoTrip || self.isDoCourse {
            self.diveDaysVerticalSpacingConstraint.constant = 8
            self.scheduleHeightConstant.constant = 18
            self.serviceStartDateEndDateLabel.isHidden = false
            self.specialPriceVerticalConstraint.constant = 8
        } else {
            self.diveDaysVerticalSpacingConstraint.constant = 0
            self.scheduleHeightConstant.constant = 0
            self.serviceStartDateEndDateLabel.isHidden = true
            self.specialPriceVerticalConstraint.constant = 0            
        }
        
        self.normalPriceLabel.text = diveService.normalPrice.toCurrencyFormatString(currency: "Rp.")
        self.specialPriceLabel.text = diveService.specialPrice.toCurrencyFormatString(currency:"Rp.")
        
        if diveService.normalPrice == diveService.specialPrice {
            self.normalPriceContainerView.isHidden = true
        } else {
            self.normalPriceContainerView.isHidden = false
        }
        if let diveCenter = diveService.divecenter {
            self.diveCenterName.text = diveCenter.name
        }
        if diveService.license {
            self.linceseNeededImageView.image = UIImage(named: "icon_license_on")
        } else {
            self.linceseNeededImageView.image = UIImage(named: "icon_license_off")
        }
        self.layoutIfNeeded()
        self.rateView.rating = Double(Int(diveService.rating))
    }
}
