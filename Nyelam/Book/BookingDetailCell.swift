//
//  BookingDetailCell.swift
//  Nyelam
//
//  Created by Bobi on 5/2/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import Cosmos

class BookingDetailCell: NTableViewCell {
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
//    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var visitedLabel: UILabel!
    @IBOutlet weak var diveCenterNameLabel: UILabel!
    @IBOutlet weak var diveCenterLocationName: UILabel!
    @IBOutlet weak var summaryContainer: UIView!
    fileprivate var additionalViews: [UIView]?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initData(diveService: NDiveService, selectedDate: Date) {
        self.eventLabel.text = diveService.name
//        self.rateView.rating = diveService.rating
        self.bookingDateLabel.text = selectedDate.formatDate(dateFormat: "dd MMMM yyyy")
//        self.visitedLabel.text = "\(diveService.ratingCount) / \(diveService.visited) visited"
        if let diveCenter = diveService.divecenter {
            self.diveCenterNameLabel.text = diveCenter.name
            if let contact = diveCenter.contact, let location = contact.location {
                self.diveCenterLocationName.text = "\(location.city!.name!), \(location.province!.name!) - \(location.country!)"
            } else if let location = diveCenter.location {
                self.diveCenterLocationName.text = "\(location.city!.name!), \(location.province!.name!) - \(location.country!)"
            }
        }
    }
    
    func initData(diveService: NDiveService, subTotal: Double, total: Double, selectedDate: Date, selectedDiver: Int, additionals: [Additional]?, equipments: [Equipment]? = nil) {
        self.eventLabel.text = diveService.name
        //        self.rateView.rating = diveService.rating
        self.bookingDateLabel.text = selectedDate.formatDate(dateFormat: "dd MMMM yyyy")
        //        self.visitedLabel.text = "\(diveService.ratingCount) / \(diveService.visited) visited"
        if let diveCenter = diveService.divecenter {
            self.diveCenterNameLabel.text = diveCenter.name
            if let contact = diveCenter.contact, let location = contact.location {
                self.diveCenterLocationName.text = "\(location.city!.name!), \(location.province!.name!) - \(location.country!)"
            } else if let location = diveCenter.location {
                self.diveCenterLocationName.text = "\(location.city!.name!), \(location.province!.name!) - \(location.country!)"
            }
        }

        let serviceAddtionalView: NAdditionalView = NAdditionalView(frame: CGRect.zero)
        serviceAddtionalView.translatesAutoresizingMaskIntoConstraints = false
        serviceAddtionalView.initData(title: "Sub Total", price: subTotal)
        self.additionalViews = []
        for view in self.summaryContainer.subviews {
            view.removeFromSuperview()
        }
        self.summaryContainer.addSubview(serviceAddtionalView)
        self.additionalViews!.append(serviceAddtionalView)
        self.summaryContainer.addConstraints([
            NSLayoutConstraint(item: self.summaryContainer, attribute: .leading, relatedBy: .equal, toItem: serviceAddtionalView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.summaryContainer, attribute: .trailing, relatedBy: .equal, toItem: serviceAddtionalView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.summaryContainer, attribute: .top, relatedBy: .equal, toItem: serviceAddtionalView, attribute: .top, multiplier: 1, constant: 0)
            ])
        var i: Int = 0
        if let equipments = equipments, !equipments.isEmpty {
            for equipment in equipments {
                let additionalView = NAdditionalView(frame: CGRect.zero)
                additionalView.translatesAutoresizingMaskIntoConstraints = false
                additionalView.initData(title: "\(equipment.name!) x\(equipment.quantity)", price: equipment.specialPrice)
                self.summaryContainer.addSubview(additionalView)
                self.summaryContainer.addConstraints([
                    NSLayoutConstraint(item: self.summaryContainer, attribute: .leading, relatedBy: .equal, toItem: additionalView, attribute: .leading, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: self.summaryContainer, attribute: .trailing, relatedBy: .equal, toItem: additionalView, attribute: .trailing, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: self.additionalViews![i], attribute: .bottom,
                                       relatedBy: .equal, toItem: additionalView, attribute: .top,
                                       multiplier: 1, constant: -4)
                    ])
                self.additionalViews!.append(additionalView)
                if additionals == nil || additionals!.isEmpty {
                    self.summaryContainer.addConstraint(NSLayoutConstraint(item: self.summaryContainer, attribute: .bottom, relatedBy: .equal, toItem: additionalView, attribute: .bottom, multiplier: 1, constant: 0))
                }
                self.additionalViews!.append(additionalView)
                i += 1
            }
        }
        if let additionals = additionals, !additionals.isEmpty {
            var j: Int = 0
            for additional in additionals {
                let additionalView = NAdditionalView(frame: CGRect.zero)
                additionalView.translatesAutoresizingMaskIntoConstraints = false
                additionalView.initData(title: additional.title!, price: additional.value!)
                //                additionalView.addConstraint(NSLayoutConstraint(item: additionalView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 54))
                self.summaryContainer.addSubview(additionalView)
                self.summaryContainer.addConstraints([
                    NSLayoutConstraint(item: self.summaryContainer, attribute: .leading, relatedBy: .equal, toItem: additionalView, attribute: .leading, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: self.summaryContainer, attribute: .trailing, relatedBy: .equal, toItem: additionalView, attribute: .trailing, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: self.additionalViews![i], attribute: .bottom,
                                       relatedBy: .equal, toItem: additionalView, attribute: .top,
                                       multiplier: 1, constant: -4)
                    ])
//                if j >= additionals.count - 1 {
//                    self.summaryContainer.addConstraint(NSLayoutConstraint(item: self.summaryContainer, attribute: .bottom, relatedBy: .equal, toItem: additionalView, attribute: .bottom, multiplier: 1, constant: 0))
//                }
                self.additionalViews!.append(additionalView)
                j += 1
                i += 1
            }
            let additionalView = NAdditionalView(frame: CGRect.zero)
            additionalView.translatesAutoresizingMaskIntoConstraints = false
            additionalView.initData(title: "Total", price: total)
            additionalView.titleLabel.textColor = UIColor.nyOrange
            additionalView.priceLabel.textColor = UIColor.nyOrange
            self.summaryContainer.addSubview(additionalView)
            self.summaryContainer.addConstraints([
                NSLayoutConstraint(item: self.summaryContainer, attribute: .leading, relatedBy: .equal, toItem: additionalView, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.summaryContainer, attribute: .trailing, relatedBy: .equal, toItem: additionalView, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.additionalViews![i], attribute: .bottom,
                                   relatedBy: .equal, toItem: additionalView, attribute: .top,
                                   multiplier: 1, constant: -4)
                ])
            self.summaryContainer.addConstraint(NSLayoutConstraint(item: self.summaryContainer, attribute: .bottom, relatedBy: .equal, toItem: additionalView, attribute: .bottom, multiplier: 1, constant: 0))
            self.additionalViews!.append(additionalView)
        } else {
            let additionalView = NAdditionalView(frame: CGRect.zero)
            additionalView.translatesAutoresizingMaskIntoConstraints = false
            additionalView.initData(title: "Total", price: total)
            additionalView.titleLabel.textColor = UIColor.nyOrange
            additionalView.priceLabel.textColor = UIColor.nyOrange
            self.summaryContainer.addSubview(additionalView)
            self.summaryContainer.addConstraints([
                NSLayoutConstraint(item: self.summaryContainer, attribute: .leading, relatedBy: .equal, toItem: additionalView, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.summaryContainer, attribute: .trailing, relatedBy: .equal, toItem: additionalView, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.additionalViews![i], attribute: .bottom,
                                   relatedBy: .equal, toItem: additionalView, attribute: .top,
                                   multiplier: 1, constant: -4)
                ])
            self.summaryContainer.addConstraint(NSLayoutConstraint(item: self.summaryContainer, attribute: .bottom, relatedBy: .equal, toItem: additionalView, attribute: .bottom, multiplier: 1, constant: 0))
    
            self.additionalViews!.append(additionalView)
            i += 1
            self.summaryContainer.addConstraint(NSLayoutConstraint(item: self.summaryContainer, attribute: .bottom, relatedBy: .equal, toItem: self.additionalViews![i], attribute: .bottom, multiplier: 1, constant: 0))
        }
    }
}

