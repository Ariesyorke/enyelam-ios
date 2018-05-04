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
import SideMenu
import MessageUI
import SwiftDate

class HomeController: BaseViewController, UIScrollViewDelegate, MFMailComposeViewControllerDelegate {
    private var bannerImages: [String] = ["banner_1", "banner_2", "banner_3"]
    @IBOutlet weak var bannerScroller: UIScrollView!
    @IBOutlet weak var bannerPageControl: UIPageControl!
    @IBOutlet weak var btDoDive: UIControl!
    @IBOutlet weak var btEcoTrip: UIControl!
    @IBOutlet weak var btDoShop: UIControl!
    @IBOutlet weak var btDoCourse: UIControl!
    @IBOutlet weak var btSeeAllDoTrip: UIControl!
    @IBOutlet weak var doTripScroller: UIScrollView!
    @IBOutlet weak var doTripLoadingView: UIActivityIndicatorView!
    @IBOutlet weak var doTripContainer: UIView!
    @IBOutlet weak var doTripScrollerHeight: NSLayoutConstraint!
    
    var contentViews: [UIView] = []
    var sideMenuController: SideMenuController?
    
    var banners: [Banner]? {
        didSet {
            for subview: UIView in self.bannerScroller.subviews {
                subview.removeFromSuperview()
            }
            if self.banners != nil {
                var i: Int = 0
                var leftView: UIView? = nil
    
                for banner: Banner in self.banners! {

                    let view: UIControl = self.createView(for: banner, atindex: i)
                    view.tag = i
                    view.addTarget(self, action: #selector(HomeController.onBannerClicked(at:)), for: UIControlEvents.touchUpInside)
                    self.bannerScroller.addSubview(view)
                    self.bannerScroller.delegate = self
                    self.contentViews.append(view)
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
                    view.isDoTrip = true
                    view.initData(diveService: doTrip)
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
        self.setupSideMenu()
        self.banners = [Banner(), Banner(), Banner()]
        self.getDoTrips()
    }
    
    internal func getDoTrips() {
        self.doTripScrollerHeight.constant = 0
        self.doTripLoadingView.isHidden = false
        NHTTPHelper.httpGetHomepageModule(complete: {response in
            self.doTripLoadingView.isHidden = true
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.getDoTrips()
                    })
                }
                return
            }
            if let modules = response.data {
                var diveServices: [NDiveService] = []
                for module in modules {
                    if module.isKind(of: TripModule.self) {
                        let tripModule = module as! TripModule
                        if let services = tripModule.diveServices, !services.isEmpty {
                            diveServices.append(contentsOf: services)
                        }
                    }
                }
                self.doTripScrollerHeight.constant = 384
                self.doTrips = diveServices
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}

// MARK: - Outlets & Actions
extension HomeController {
    @IBAction func sideMenuButtonAction(_ sender: Any) {
        self.present(SideMenuManager.menuRightNavigationController!, animated: true, completion: {
            self.sideMenuController!.tableView.reloadData()
        })
    }

    @IBAction func onMenuClicked(_ sender: UIControl) {
        if sender == self.btDoDive {
            SearchFormController.push(on: self.navigationController!, forDoTrip: false)
        } else if sender == self.btEcoTrip {
            EcoTripIntroductionController.push(on: self.navigationController!)
        } else if sender == self.btDoShop || sender == self.btDoCourse {
            UIAlertController.handlePopupMessage(viewController: self, title: "Coming Soon!", actionButtonTitle: "OK", completion: {})
        }
    }
    
    @IBAction func onSeeAllDoTripClicked(_ sender: UIControl) {
        DiveServiceSearchResultController.push(on: self.navigationController!, forDoTrip: true, selectedDiver: 1)
    }
    
    @objc func onBannerClicked(at sender: UIControl) {
        let index: Int = sender.tag
        // TODO:
    }
    
    @objc func onDoTripClicked(at sender: UIControl) {
        let index: Int = sender.tag
        let trip = self.doTrips![index]
        let result = SearchResultService()
        let schedule = trip.schedule!
        let date = Date(timeIntervalSince1970: schedule.startDate)
        _ = DiveServiceController.push(on: self.navigationController!, forDoTrip: true, selectedKeyword: result, selectedLicense: trip.license, selectedDiver: 1, selectedDate: date, ecoTrip: nil, diveService: trip)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let gap = Int((scrollView.contentSize.width - scrollView.contentOffset.x)/scrollView.bounds.width)
        let index = Int(contentViews.count - gap)
        self.bannerPageControl.currentPage = index
    }
    
    internal func setupSideMenu() {
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuFadeStatusBar = false
        self.sideMenuController = SideMenuController(nibName: "SideMenuController", bundle: nil)
        let sideMenuNavController: UISideMenuNavigationController = UISideMenuNavigationController(rootViewController: sideMenuController!)
        sideMenuNavController.setNavigationBarHidden(true, animated: false)
        SideMenuManager.menuRightNavigationController = sideMenuNavController
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.view, forMenu: UIRectEdge.right)
        sideMenuController!.handleMenuItem = {item in
            switch item {
            case SideMenuItemType.login:
                self.goToAuth()
                break
            case SideMenuItemType.contactus:
                self.contactUs()
                break
            case SideMenuItemType.account:
                self.openAccount()
                break
            case SideMenuItemType.logout:
                self.logout()
                break
            case SideMenuItemType.terms:
                self.terms()
                break
            default:
                break
            }
        }
    }
    internal func contactUs() {
        let composeVC = MFMailComposeViewController()
        composeVC.setToRecipients(["info@e-nyelam.com"])
        composeVC.mailComposeDelegate = self
        if let parent = self.parent {
            parent.present(composeVC, animated: true, completion: nil)
        } else {
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    internal func openAccount() {
        if let parent = self.parent as? BaseViewController {
            parent.goToAccount()
        }
    }
    internal func logout() {
        _ = NAuthReturn.deleteAllAuth()
        if let sideMenu = self.sideMenuController {
            sideMenu.tableView.reloadData()
        }
    }
    
    internal func terms() {
        let vc = TermsViewController(nibName: "TermsViewController", bundle: nil)
        if let parent = self.parent {
            if let navigation = parent.navigationController {
                navigation.pushViewController(vc, animated: true)
            }
        } else {
            self.present(vc, animated: true, completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Views Setup
extension HomeController {
    
    fileprivate func createView(forDoTrip service: NDiveService) -> NServiceView {
        let view: NServiceView = NServiceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width * 75/100))
        return view
    }
    
    fileprivate func createView(for banner: Banner, atindex: Int) -> UIControl {
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
        imgView.clipsToBounds = true
        imgView.backgroundColor = UIColor.clear
        imgView.image = UIImage(named: bannerImages[atindex])!
        if banner.imageUrl != nil, let url: URL = URL(string: banner.imageUrl!) {
            imgView.af_setImage(withURL: url)
        } else {
            progress.isHidden = true
        }
        control.addSubview(imgView)
        control.addConstraints([
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: imgView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: imgView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: imgView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: control, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: imgView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: control, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
            ])
        return control
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
}
