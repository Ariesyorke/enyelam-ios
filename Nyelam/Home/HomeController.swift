//
//  HomeController.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/11/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreData

class HomeController: BaseViewController, UIScrollViewDelegate {
    @IBOutlet weak var bannerScroller: UIScrollView!
    @IBOutlet weak var bannerPageControl: UIPageControl!
    @IBOutlet weak var btDoDive: UIControl!
    @IBOutlet weak var btEcoTrip: UIControl!
    @IBOutlet weak var btDoShop: UIControl!
    @IBOutlet weak var btDoCourse: UIControl!
    @IBOutlet weak var btSeeAllDoTrip: UIControl!
    @IBOutlet weak var doTripScroller: UIScrollView!
    
    var banners: [Banner]? {
        didSet {
            for subview: UIView in self.bannerScroller.subviews {
                subview.removeFromSuperview()
            }
            
            if self.banners != nil {
                var i: Int = 0
                var leftView: UIView? = nil
                for banner: Banner in self.banners! {
                    let view: UIControl = self.createView(for: banner)
                    view.tag = i
                    view.addTarget(self, action: #selector(HomeController.onBannerClicked(at:)), for: UIControlEvents.touchUpInside)
                    
                    self.bannerScroller.addSubview(view)
                    self.bannerScroller.addConstraints([
                        NSLayoutConstraint(item: self.bannerScroller, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self.bannerScroller, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self.bannerScroller, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
                        ])
                    
                    if leftView == nil {
                        self.bannerScroller.addConstraint(NSLayoutConstraint(item: self.bannerScroller, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
                    } else {
                        self.bannerScroller.addConstraint(NSLayoutConstraint(item: leftView!, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
                    }
                    
                    if i == self.banners!.count - 1 {
                        self.bannerScroller.addConstraint(NSLayoutConstraint(item: self.bannerScroller, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0))
                    }
                    
                    i += 1
                    leftView = view
                }
            }
        }
    }
    
    var doTrips: [NDiveService]? {
        didSet {
            for subview: UIView in self.doTripScroller.subviews {
                subview.removeFromSuperview()
            }
            
            if self.doTrips != nil {
                var i: Int = 0
                var leftView: UIView? = nil
                for doTrip: NDiveService in self.doTrips! {
                    let view: NServiceView = self.createView(forDoTrip: doTrip)
                    view.addTarget(self, action: #selector(HomeController.onDoTripClicked(at:)))
                    DTMHelper.addShadow(view)
                    
                    self.doTripScroller.addSubview(view)
                    self.doTripScroller.addConstraints([
                        NSLayoutConstraint(item: self.doTripScroller, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self.doTripScroller, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
                        ])
                    
                    if leftView == nil {
                        self.doTripScroller.addConstraint(NSLayoutConstraint(item: self.doTripScroller, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: -16))
                    } else {
                        self.doTripScroller.addConstraint(NSLayoutConstraint(item: leftView!, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: -8))
                    }
                    
                    if i == self.doTrips!.count - 1 {
                        self.doTripScroller.addConstraint(NSLayoutConstraint(item: self.doTripScroller, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 16))
                    }
                    
                    i += 1
                    leftView = view
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TESTING
        self.banners = [Banner(), Banner(), Banner()]
        self.doTrips = [
            NDiveService(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext),
            NDiveService(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext),
            NDiveService(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext),
            NDiveService(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext),
            NDiveService(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext),
            NDiveService(entity: NSEntityDescription.entity(forEntityName: "NDiveService", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UIScrollViewDelegate
}

// MARK: - Outlets & Actions
extension HomeController {
    
    @IBAction func onMenuClicked(_ sender: UIControl) {
        // TODO:
    }
    
    @IBAction func onSeeAllDoTripClicked(_ sender: UIControl) {
        // TODO:
    }
    
    @objc func onBannerClicked(at sender: UIControl) {
        let index: Int = sender.tag
        // TODO:
    }
    
    @objc func onDoTripClicked(at sender: UIControl) {
        let index: Int = sender.tag
        // TODO:
    }
}

// MARK: - Views Setup
extension HomeController {
    
    fileprivate func createView(forDoTrip service: NDiveService) -> NServiceView {
        let view: NServiceView = NServiceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300))
        return view
    }
    
    fileprivate func createView(for banner: Banner) -> UIControl {
        let control: UIControl = UIControl(frame: CGRect(x: 0, y: 0, width: 0, height: 0    ))
        control.translatesAutoresizingMaskIntoConstraints = false
        
        let progress: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.tintColor = UIColor.primary
        progress.startAnimating()
        
        control.addSubview(progress)
        control.addConstraints([
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: progress, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: progress, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
            ])
        
        let imgView: UIImageView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = UIViewContentMode.scaleAspectFill
        imgView.backgroundColor = UIColor.clear
        imgView.image = nil
        if banner.imageUrl != nil, let url: URL = URL(string: banner.imageUrl!) {
            imgView.af_setImage(withURL: url)
        } else {
            progress.isHidden = true
        }
        control.addSubview(imgView)
        control.addConstraints([
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: imgView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: imgView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: imgView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: imgView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
            ])
        
        return control
    }
}
