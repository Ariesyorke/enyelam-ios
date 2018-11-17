//
//  DiveServiceController.swift
//  Nyelam
//
//  Created by Bobi on 4/29/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import Cosmos
import MBProgressHUD
import UIScrollView_InfiniteScroll

class DiveServiceController: BaseViewController {
    let file = "review.json"

    static func push(on controller: UINavigationController, forDoTrip: Bool, selectedKeyword: SearchResult?, selectedLicense: Bool, selectedDiver: Int, selectedDate: Date, ecoTrip: Int?, diveService: NDiveService) -> DiveServiceController {
        let vc: DiveServiceController = DiveServiceController(nibName: "DiveServiceController", bundle: nil)
        vc.selectedLicense = selectedLicense
        vc.selectedDiver = selectedDiver
        vc.selectedDate = selectedDate
        vc.selectedKeyword = selectedKeyword
        vc.diveService = diveService
        vc.ecotrip = ecoTrip
        vc.forDoTrip = forDoTrip
        controller.setNavigationBarHidden(false, animated: true)
        controller.navigationBar.barTintColor = UIColor.primary
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    static func push(on controller: UINavigationController, forDoTrip: Bool, selectedKeyword: SearchResult?, selectedLicense: Bool, selectedDiver: Int, selectedDate: Date, ecoTrip: Int?) -> DiveServiceController {
        let vc: DiveServiceController = DiveServiceController(nibName: "DiveServiceController", bundle: nil)
        vc.selectedLicense = selectedLicense
        vc.selectedDiver = selectedDiver
        vc.selectedDate = selectedDate
        vc.selectedKeyword = selectedKeyword
        vc.ecotrip = ecoTrip
        vc.forDoTrip = forDoTrip
        controller.setNavigationBarHidden(false, animated: true)
        controller.navigationBar.barTintColor = UIColor.primary
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    static func push(on controller: UINavigationController, forDoCourse: Bool, selectedKeyword: SearchResult?, selectedDiver: Int, selectedDate: Date, diveService: NDiveService?, selectedOrganization: NMasterOrganization, selectedLicenseType: NLicenseType) -> DiveServiceController {
        let vc: DiveServiceController = DiveServiceController(nibName: "DiveServiceController", bundle: nil)
        vc.selectedDiver = selectedDiver
        vc.selectedDate = selectedDate
        vc.selectedKeyword = selectedKeyword
        vc.diveService = diveService
        vc.forDoCourse = forDoCourse
        vc.selectedOrganization = selectedOrganization
        vc.selectedLicenseType = selectedLicenseType
        controller.setNavigationBarHidden(false, animated: true)
        controller.navigationBar.barTintColor = UIColor.primary
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    
    fileprivate var forDoTrip: Bool = false
    fileprivate var forDoCourse: Bool = false
    fileprivate var ecotrip: Int?
    fileprivate var diveService: NDiveService?
    fileprivate var selectedKeyword: SearchResult?
    fileprivate var selectedDate: Date?
    fileprivate var selectedDiver: Int = 1
    fileprivate var selectedLicense: Bool = false
    fileprivate var page: Int = 1
    fileprivate var strechyHeaderView: NStickyHeaderView?
    fileprivate var relatedDiveServices: [NDiveService]?
    fileprivate var selectedOrganization: NMasterOrganization?
    fileprivate var selectedLicenseType: NLicenseType?
    fileprivate var state: TableState = .detail
    fileprivate var equipments: [Equipment]?
    fileprivate var reviews: [Review]? {
        didSet{
            if self.reviews != nil && !self.reviews!.isEmpty {
                if self.state == .review {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reviewNotFoundLabel: UILabel!
    @IBOutlet weak var stockTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.firstTime {
            self.firstTime = false
            self.initView()
            let id = self.diveService != nil ? self.diveService!.id!:self.selectedKeyword!.id!
            self.tryLoadServiceDetail(serviceId: id, selectedLicense: selectedLicense.number, selectedDate: selectedDate!, selectedDiver: selectedDiver, forDoTrip: self.forDoTrip, forDoCourse: self.forDoCourse)
            self.tryGetReviews(serviceId: id)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var item = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonAction(_:)))
        item.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "FiraSans-SemiBold", size: 15)!,
                                     NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        self.navigationItem.rightBarButtonItem = item
    }
    
    fileprivate func tryGetReviews(serviceId: String) {
        print("GET REVIEW!!")
        NHTTPHelper.httpGetReviewList(page: String(page), serviceId: serviceId, complete: {response in
            self.tableView.finishInfiniteScroll()
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryGetReviews(serviceId: serviceId)
                    })
                }
                return
            }
            if let datas = response.data, !datas.isEmpty {
                self.page += 1
                if self.reviews == nil {
                    self.reviews = []
                }
                self.reviews!.append(contentsOf: datas)
            }
        })
    }
    
    @objc func shareButtonAction(_ button: UIBarButtonItem) {
        let url = URL(string: "https://e-nyelam.com/download")!
        let message = "Download for free on App Store\n"
        let share = [message, url] as [Any]
        let activityViewController = UIActivityViewController(activityItems: share, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }

    
    fileprivate func initView() {
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
        if self.forDoCourse {
            let title = self.selectedDate!.formatDate(dateFormat: "MMM yyyy")
            self.title = title
        } else {
            let title = self.selectedDate!.formatDate(dateFormat: "dd MMM yyyy")
            self.title = title
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nibViews = Bundle.main.loadNibNamed("NStickyHeaderView", owner: self, options: nil)
        self.strechyHeaderView = nibViews!.first as! NStickyHeaderView
        self.strechyHeaderView!.delegate = self
        self.strechyHeaderView!.expansionMode = .topOnly
        self.strechyHeaderView!.tabDetailLineView.isHidden = false
        self.tableView.addSubview(self.strechyHeaderView!)
        self.stockTextField.text = String(describing: self.selectedDiver)
        
        self.tableView.register(UINib(nibName: "DiveServiceDetailCell", bundle: nil), forCellReuseIdentifier: "DiveServiceDetailCell")
        self.tableView.register(UINib(nibName: "DiveServiceRelatedCell", bundle: nil), forCellReuseIdentifier: "DiveServiceRelatedCell")
        self.tableView.register(UINib(nibName: "AddOnCell", bundle: nil), forCellReuseIdentifier: "AddOnCell")
        self.tableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        
        self.tableView.addInfiniteScroll(handler: {tableView in
            if self.state == .review {
                let id = self.diveService != nil ? self.diveService!.id!:self.selectedKeyword!.id!
                self.tryGetReviews(serviceId: id)
            }
        })
    }
    
    fileprivate func tryLoadServiceDetail(serviceId: String, selectedLicense: Int, selectedDate: Date, selectedDiver: Int, forDoTrip: Bool, forDoCourse: Bool) {
        self.loadingView.isHidden = false
        self.tableView.isHidden = true
        if forDoTrip {
            NHTTPHelper.httpDetail(doTripId: serviceId, diver: selectedDiver, certificate: selectedLicense, date: selectedDate, complete: {response in
                if let error = response.error {
                    self.loadingView.isHidden = true
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                        if error.isKind(of: NotConnectedInternetError.self) {
                            NHelper.handleConnectionError(completion: {
                                self.tryLoadServiceDetail(serviceId: serviceId, selectedLicense: selectedLicense, selectedDate: selectedDate, selectedDiver: selectedDiver, forDoTrip: forDoTrip, forDoCourse: forDoCourse)
                            })
                        }
                    })
                }
                if let data = response.data {
                    self.diveService = data
                    if let featuredImage = self.diveService!.featuredImage, !featuredImage.isEmpty {
                        var images: [String] = [featuredImage]
                        if let imgs = self.diveService!.images, !imgs.isEmpty {
                            images.append(contentsOf: imgs)
                        }
                        self.strechyHeaderView!.initBanner(images: images)
                    }
                    let diveCenter = self.diveService!.divecenter!
                    self.tryLoadRelatedServices(diveCenterId: diveCenter.id!, selectedLicense: selectedLicense, selectedDate: selectedDate, selectedDiver: selectedDiver, ecoTrip: self.ecotrip, forDoTrip: forDoTrip, forDoCourse: self.forDoCourse, organizationId: self.selectedOrganization != nil ? self.selectedOrganization!.id! : nil, licenseTypeId: self.selectedLicenseType != nil ? self.selectedLicenseType!.id! : nil)
                } else {
                    UIAlertController.handleErrorMessage(viewController: self, error: "Stock not available", completion: {
                        self.backButtonAction(UIBarButtonItem())
                    })
                }
            })
        } else if forDoCourse {
            NHTTPHelper.httpDetail(doCourseId: serviceId, diver: selectedDiver, date: selectedDate, complete: {response in
                if let error = response.error {
                    self.loadingView.isHidden = true
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                        if error.isKind(of: NotConnectedInternetError.self) {
                            NHelper.handleConnectionError(completion: {
                                self.tryLoadServiceDetail(serviceId: serviceId, selectedLicense: selectedLicense, selectedDate: selectedDate, selectedDiver: selectedDiver, forDoTrip: forDoTrip, forDoCourse: forDoCourse)
                            })
                        }
                    })
                }
                if let data = response.data {
                    self.diveService = data
                    if let featuredImage = self.diveService!.featuredImage, !featuredImage.isEmpty {
                        var images: [String] = [featuredImage]
                        if let imgs = self.diveService!.images, !imgs.isEmpty {
                            images.append(contentsOf: imgs)
                        }
                        self.strechyHeaderView!.initBanner(images: images)
                    }
                    let diveCenter = self.diveService!.divecenter!
                    self.tableView.isHidden = false
                    self.tableView.reloadData()

                    self.tryLoadRelatedServices(diveCenterId: diveCenter.id!, selectedLicense: selectedLicense, selectedDate: selectedDate, selectedDiver: selectedDiver, ecoTrip: self.ecotrip, forDoTrip: forDoTrip, forDoCourse: self.forDoCourse, organizationId: self.selectedOrganization != nil ? self.selectedOrganization!.id! : nil, licenseTypeId: self.selectedLicenseType != nil ? self.selectedLicenseType!.id! : nil)
                } else {
                    UIAlertController.handleErrorMessage(viewController: self, error: "Stock not available", completion: {
                        self.backButtonAction(UIBarButtonItem())
                    })
                }
            })
        } else {
            NHTTPHelper.httpDetail(serviceId: serviceId, diver: selectedDiver, certificate: selectedLicense, date: selectedDate, complete: {response in
                if let error = response.error {
                    self.loadingView.isHidden = true
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                        if error.isKind(of: NotConnectedInternetError.self) {
                            NHelper.handleConnectionError(completion: {
                                self.tryLoadServiceDetail(serviceId: serviceId, selectedLicense: selectedLicense, selectedDate: selectedDate, selectedDiver: selectedDiver, forDoTrip: forDoTrip, forDoCourse: forDoCourse)
                            })
                        }
                    })
                }
                
                if let data = response.data {
                    self.diveService = data
                    if let featuredImage = self.diveService!.featuredImage, !featuredImage.isEmpty {
                        var images: [String] = [featuredImage]
                        if let imgs = self.diveService!.images, !imgs.isEmpty {
                            images.append(contentsOf: imgs)
                        }
                        self.strechyHeaderView!.initBanner(images: images)
                    }
                    let diveCenter = self.diveService!.divecenter!
//                    self.tableView.isHidden = false
//                    self.tableView.reloadData()

                    self.tryLoadRelatedServices(diveCenterId: diveCenter.id!, selectedLicense: selectedLicense, selectedDate: selectedDate, selectedDiver: selectedDiver, ecoTrip: self.ecotrip, forDoTrip: forDoTrip, forDoCourse: self.forDoCourse, organizationId: self.selectedOrganization != nil ? self.selectedOrganization!.id! : nil, licenseTypeId: self.selectedLicenseType != nil ? self.selectedLicenseType!.id! : nil)
                } else {
                    UIAlertController.handleErrorMessage(viewController: self, error: "Stock not available", completion: {
                        self.backButtonAction(UIBarButtonItem())
                    })
                }
            })
        }
    }
    
    fileprivate func tryLoadRelatedServices(diveCenterId: String, selectedLicense: Int, selectedDate: Date, selectedDiver: Int, ecoTrip: Int?, forDoTrip: Bool, forDoCourse: Bool, organizationId: String?, licenseTypeId: String?) {
        if forDoTrip {
            NHTTPHelper.httpDoTripSearchBy(diveCenterId: diveCenterId, page: "1", diver: selectedDiver, certificate: nil, date: Date().timeIntervalSince1970, sortBy: 1, ecoTrip: self.ecotrip, totalDives: nil, categories: nil, facilities: nil, priceMin: nil, priceMax: nil, complete: {response in
                self.loadingView.isHidden = true
                if let data = response.data, !data.isEmpty {
                    let diveServices = self.removeSameData(diveService: data)
                    self.relatedDiveServices = diveServices
                }
                self.tableView.isHidden = false
                self.tableView.reloadData()
            })
        } else if forDoCourse {
          NHTTPHelper.httpDoCourseSearchBy(diveCenterId: diveCenterId, page: "1", date: selectedDate.timeIntervalSince1970, selectedDiver: selectedDiver, sortBy: 1, organizationId: organizationId!, licenseTypeId: licenseTypeId!, openWater: nil, priceMin: nil, priceMax: nil, facilities: nil, complete: {response in
            self.loadingView.isHidden = true
                if let data = response.data, !data.isEmpty {
                    let diveServices = self.removeSameData(diveService: data)
                    self.relatedDiveServices = diveServices
                }
                self.tableView.isHidden = false
                self.tableView.reloadData()

          })
        } else {
            NHTTPHelper.httpDoDiveSearchBy(diveCenterId: diveCenterId, page: "1", diver: selectedDiver, certificate: selectedLicense, date: selectedDate.timeIntervalSince1970, sortBy: 1, ecoTrip: self.ecotrip, totalDives: nil, categories: nil, facilities: nil, priceMin: nil, priceMax: nil, complete: {response in
                self.loadingView.isHidden = true
                if let data = response.data, !data.isEmpty {
                    let diveServices = self.removeSameData(diveService: data)
                    self.relatedDiveServices = diveServices
                }
                self.tableView.isHidden = false
                self.tableView.reloadData()
            })
        }
    }
    
    func removeSameData(diveService: [NDiveService]) -> [NDiveService] {
        var i: Int = 0
        var temp = diveService
        for service in diveService {
            if self.diveService!.id! == service.id! {
                temp.remove(at: i)
                break
            }
            i += 1
        }
        return temp
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        if let diveService = self.diveService {
            let difference = Int(diveService.availability) - self.selectedDiver
            if difference > 0 && self.selectedDiver < 10 {
                self.selectedDiver += 1
                self.stockTextField.text = String(describing: self.selectedDiver)
            }
        }
    }
    
    
     @IBAction func minusButtonAction(_ sender: Any) {
        if let _ = self.diveService {
            if self.selectedDiver > 1 {
                self.selectedDiver -= 1
                self.stockTextField.text = String(describing: self.selectedDiver)
            }
        }
     }
    
    @IBAction func bookNowButtonAction(_ sender: Any) {
        if let _ = self.diveService {
            if let authUser = NAuthReturn.authUser() {
                self.book(user: authUser.user!)
            } else {
                self.goToAuth(completion: {
                    if let authUser = NAuthReturn.authUser() {
                        self.book(user: authUser.user!)
                    }
                })
            }
        }
    }
    
    override func goToAuth(completion: @escaping () -> ()) {
        let _ = AuthNavigationController.present(on: self, dismissCompletion: completion)
    }
    
    fileprivate func book(user: NUser) {
        let diveCenter = self.diveService!.divecenter!
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if self.forDoCourse {
            NHTTPHelper.httpBookService(diveCenterId: diveCenter.id!, diveServiceId: self.diveService!.id!, diver: self.selectedDiver, schedule: self.selectedDate!, type: 1, licenseTypeId: self.selectedLicenseType!.id!, organizationId: self.selectedOrganization!.id!, equipments: self.equipments, complete: {response in
                MBProgressHUD.hide(for: self.view, animated: true)
                if let error = response.error {
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.book(user: user)
                        })
                    } else if error.isKind(of: StatusFailedError.self) {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                            let err = error as! StatusFailedError
                            
                        })
                    }
                }
                MBProgressHUD.hide(for: self.view, animated: true)
                if let data = response.data {
                    let contact = self.createContact(user: user)
                    let participants = self.createParticipants(diver: self.selectedDiver, user: user)
                    _ = OrderController.push(on: self.navigationController!, diveService: self.diveService!, cartReturn: data, contact: contact, participants: participants, selectedDate: self.selectedDate!)
                }
            })
        } else {
            NHTTPHelper.httpBookService(diveCenterId: diveCenter.id!, diveServiceId: self.diveService!.id!, diver: self.selectedDiver, schedule: self.selectedDate!, type: 1, equipments: self.equipments, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
                if let error = response.error {
                    if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.book(user: user)
                        })
                    } else if error.isKind(of: StatusFailedError.self) {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: { _ in
                            
                        })
                    }
                }
                MBProgressHUD.hide(for: self.view, animated: true)
                if let data = response.data {
                    let contact = self.createContact(user: user)
                    let participants = self.createParticipants(diver: self.selectedDiver, user: user)
                    _ = OrderController.push(on: self.navigationController!, diveService: self.diveService!, cartReturn: data, contact: contact, participants: participants, selectedDate: self.selectedDate!)
                }
            })
        }
    }
    
    func createContact(user: NUser) -> BookingContact {
        let contact = BookingContact()
        
        if let gender = user.gender, gender.lowercased() == "male" {
            contact.titleName = .mr
        } else {
            contact.titleName = .mrs
        }
        
        contact.name = user.fullname
        contact.email = user.email
        if let countryCode = user.countryCode {
            contact.countryCode = countryCode
            contact.phoneNumber = user.phone
        }
        return contact
    }
    
    func createParticipants(diver: Int, user:NUser) -> [Participant] {
        var participants: [Participant] = []
        for var i in 0..<diver {
            let participant = Participant()
            if i == 0 {
                participant.name = user.fullname
                participant.email = user.email
                if let gender = user.gender, gender.lowercased() == "male" {
                    participant.titleName = .mr
                } else {
                    participant.titleName = .mrs
                }
            }
            participants.append(participant)
        }
        return participants
    }
}

extension DiveServiceController: NStickyHeaderViewDelegate {
    func stickyHeaderView(_ headerView: NStickyHeaderView, didSelectTabAt index: Int) {
        if index == 0 {
            self.reviewNotFoundLabel.isHidden = true
            self.strechyHeaderView!.tabDetailLineView.isHidden = false
            self.strechyHeaderView!.tabReviewLineView.isHidden = true
            self.state = .detail

        } else {
            self.reviewNotFoundLabel.isHidden = true
            self.strechyHeaderView!.tabDetailLineView.isHidden = true
            self.strechyHeaderView!.tabReviewLineView.isHidden = false
            self.state = .review
            //todo fetch review
        }
        self.tableView.reloadData()
    }
}
extension DiveServiceController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.state == .detail {
            if indexPath.section == 1 {
                _ = EquipmentRentController.present(on: self.navigationController!, diveCenterId: self.diveService!.divecenter!.id!, selectedDate: self.selectedDate!, equipments: self.equipments, onUpdateEquipment: {controller, equipments in
                    controller.dismiss(animated: true, completion: {
                        let indexSet = IndexSet(integer: 1)
                        self.equipments = equipments
                        self.tableView.reloadSections(indexSet, with: .automatic)
                    })
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return -20
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        } else {
            return -20
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "DiveServiceDetailCell", for: indexPath) as! DiveServiceDetailCell
//            cell.forDoCourse = self.forDoCourse
//            cell.initData(diveService: self.diveService!)
//            cell.onDiveCenterClicked = {diveCenter in
//                if self.forDoCourse {
//                    _ = DiveCenterController.push(on: self.navigationController!, forDoCourse: self.forDoCourse, selectedKeyword: self.selectedKeyword, selectedDiver: 1, selectedDate: self.selectedDate!, selectedOrganization: self.selectedOrganization!, selectedLicenseType: self.selectedLicenseType!, diveCenter: diveCenter)
//                } else {
//                    _ = DiveCenterController.push(on: self.navigationController!, forDoTrip: self.forDoTrip, selectedKeyword: self.selectedKeyword, selectedLicense: self.selectedLicense, selectedDiver: 1, selectedDate: self.selectedDate!, ecoTrip: self.ecotrip, diveCenter: diveCenter)
//                }
//            }
//            return cell
//        } else if indexPath.row == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "DiveServiceRelatedCell", for: indexPath) as! DiveServiceRelatedCell
//            cell.isDoTrip = self.forDoTrip
//            cell.controller = self
//            if cell.relatedDiveServices == nil || cell.relatedDiveServices!.isEmpty {
//                cell.relatedDiveServices = self.relatedDiveServices
//            }
//            cell.relatedServiceLabel.text = "You may like these"
//            cell.onRelatedServiceClicked = {diveService in
//                if self.forDoTrip {
//                    let date = Date(timeIntervalSince1970: diveService.schedule!.startDate)
//                    _ = DiveServiceController.push(on: self.navigationController!, forDoTrip: self.forDoTrip, selectedKeyword: self.selectedKeyword, selectedLicense: diveService.license, selectedDiver: 1, selectedDate: date, ecoTrip: self.ecotrip, diveService: diveService)
//                } else if  self.forDoCourse {
//                    let date = Date(timeIntervalSince1970: diveService.schedule!.startDate)
//                    _ = DiveServiceController.push(on: self.navigationController!, forDoCourse: self.forDoCourse, selectedKeyword: self.selectedKeyword, selectedDiver: 1, selectedDate: date, diveService: diveService, selectedOrganization: self.selectedOrganization!, selectedLicenseType: self.selectedLicenseType!)
//                } else {
//                    _ = DiveServiceController.push(on: self.navigationController!, forDoTrip: self.forDoTrip, selectedKeyword: self.selectedKeyword, selectedLicense: diveService.license, selectedDiver: 1, selectedDate: self.selectedDate!, ecoTrip: self.ecotrip, diveService: diveService)
//                }
//            }
//            return cell
//        }
//        return UITableViewCell()
        if indexPath.section == 0 {
            if state == .detail {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DiveServiceDetailCell", for: indexPath) as! DiveServiceDetailCell
                cell.forDoCourse = self.forDoCourse
                cell.initData(diveService: self.diveService!)
                cell.onChatDCClicked = {serviceId in
                    if let authUser = NAuthReturn.authUser() {
                        CreateInboxController.push(on: self.navigationController!, inboxType: 1, fromHome: false, refId: serviceId, subject: self.diveService!.name!, completion: {})
                    } else {
                        self.goToAuth(completion: {
                            if let authUser = NAuthReturn.authUser() {
                                CreateInboxController.push(on: self.navigationController!, inboxType: 1, fromHome: false, refId: serviceId, subject: self.diveService!.name!, completion: {})
                            }
                        })
                    }
                }
                cell.onDiveCenterClicked = {diveCenter in
                    if self.forDoCourse {
                        _ = DiveCenterController.push(on: self.navigationController!, forDoCourse: self.forDoCourse, selectedKeyword: self.selectedKeyword, selectedDiver: 1, selectedDate: self.selectedDate!, selectedOrganization: self.selectedOrganization!, selectedLicenseType: self.selectedLicenseType!, diveCenter: diveCenter)
                    } else {
                        _ = DiveCenterController.push(on: self.navigationController!, forDoTrip: self.forDoTrip, selectedKeyword: self.selectedKeyword, selectedLicense: self.selectedLicense, selectedDiver: 1, selectedDate: self.selectedDate!, ecoTrip: self.ecotrip, diveCenter: diveCenter)
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
                let review = self.reviews![indexPath.row]
                cell.dateLabel.text = review.date!.formatDate(dateFormat: "dd MMM yyyy")
                cell.ratingView.rating = review.rating
                cell.userCommentLabel.text = review.content
                if let user = review.user {
                    cell.userNameLabel.text = user.fullname
                    if let picture = user.picture, !picture.isEmpty {
                        cell.userProfileImageView.af_setImage(withURL: URL(string: picture)!)
                    }
                }
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddOnCell", for: indexPath) as! AddOnCell
            if let equipments = self.equipments, !equipments.isEmpty, indexPath.row < equipments.count {
                cell.equipmentItemLabel.text = "\(equipments[indexPath.row].name!) x\(equipments[indexPath.row].quantity)"
                cell.equipmentItemLabel.textColor = UIColor.black
            } else {
                cell.equipmentItemLabel.text = "Add Item"
                cell.equipmentItemLabel.textColor = UIColor.darkGray
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiveServiceRelatedCell", for: indexPath) as! DiveServiceRelatedCell
            cell.isDoTrip = self.forDoTrip
            cell.controller = self
            if cell.relatedDiveServices == nil || cell.relatedDiveServices!.isEmpty {
                cell.relatedDiveServices = self.relatedDiveServices
            }
            cell.onRelatedServiceClicked = {diveService in
                if self.forDoTrip {
                    let date = Date(timeIntervalSince1970: diveService.schedule!.startDate)
                    _ = DiveServiceController.push(on: self.navigationController!, forDoTrip: self.forDoTrip, selectedKeyword: self.selectedKeyword, selectedLicense: diveService.license, selectedDiver: 1, selectedDate: date, ecoTrip: self.ecotrip, diveService: diveService)
                } else {
                    _ = DiveServiceController.push(on: self.navigationController!, forDoTrip: self.forDoTrip, selectedKeyword: self.selectedKeyword, selectedLicense: diveService.license, selectedDiver: 1, selectedDate: self.selectedDate!, ecoTrip: self.ecotrip, diveService: diveService)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
        var count = 0
        if state == .detail {
            if let _ = self.diveService {
                count += 2
            }
            if let diveServices = self.relatedDiveServices, !diveServices.isEmpty {
                count += 1
            }
        } else {
            if let reviews = self.reviews,!reviews.isEmpty {
                count += 1
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return nil
        if section == 1 {
            let sectionTitle = NBookingTitleSection(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
            sectionTitle.subtitleLabel.isHidden = true
            sectionTitle.titleLabel.text = "Add-on(s)"
            sectionTitle.baseView.backgroundColor = UIColor.nyOrange
            return sectionTitle
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var count = 0
//        if state == .detail {
//            if let _ = self.diveService {
//                count += 1
//            }
//            if let diveServices = self.relatedDiveServices, !diveServices.isEmpty {
//                count += 1
//            }
//        }
//        return count
        var count = 0
        if state == .detail {
            if section == 0 {
                count += 1
            } else if section == 1 {
                var count = 1
                if let equipments = self.equipments, !equipments.isEmpty {
                    count += equipments.count
                }
                return count
            } else if section == 2 {
                 count += 1
            }
        } else {
            if state == .review {
                if let reviews = self.reviews, !reviews.isEmpty {
                    count += reviews.count
                }
            }
        }
        return count
    }
}
class DiveServiceDetailCell: NTableViewCell {
    let faciltyMapping: [String: [String]] = [
        "towel": ["ic_towel_active", "ic_towel_unactive"],
        "food": ["ic_food_and_drink_active", "ic_food_and_drink_unactive"],
        "equipment": ["ic_equipment_active", "ic_equipment_unactive"],
        "dive_guide": ["ic_dive_guide_active", "ic_dive_guide_unactive"],
        "accomodation": ["ic_accomodation_active", "ic_accomodation_unactive"],
        "transport": ["ic_transportation_active", "ic_transportation_unactive"]
    ]
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var diveCenterImage: UIImageView!
    @IBOutlet weak var diveCenterNameLabel: UILabel!
    @IBOutlet weak var divespotLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var visitorCounterLabel: UILabel!
    @IBOutlet weak var normalPriceContainer: UIView!
    @IBOutlet weak var specialPriceLabel: UILabel!
    @IBOutlet weak var totalDivesCounterLabel: UILabel!
    @IBOutlet weak var divespotCounterLabel: UILabel!
    @IBOutlet weak var tripDurationLabel: UILabel!
    @IBOutlet weak var licenseImageView: UIImageView!
    @IBOutlet weak var licenseContainer: UIView!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var categoryContainer: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var diveGuideImageView: UIImageView!
    @IBOutlet weak var equipmentImageView: UIImageView!
    @IBOutlet weak var foodAndDrinkImageView: UIImageView!
    @IBOutlet weak var transportationImageView: UIImageView!
    @IBOutlet weak var towelImageView: UIImageView!
    @IBOutlet weak var accomodationImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var normalPriceLabel: UILabel!
    @IBOutlet weak var divespotTopSpacing: NSLayoutConstraint!
    @IBOutlet weak var additionalLabel1: UILabel!
    @IBOutlet weak var additionalLabel2: UILabel!
    @IBOutlet weak var additionalLabel3: UILabel!
    @IBOutlet weak var additionalLabel4: UILabel!
    @IBOutlet weak var additionalLabel4Height: NSLayoutConstraint!
    @IBOutlet weak var additionalLabel4Colon: UILabel!
    @IBOutlet weak var categoryHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var licenseTopSpacing: NSLayoutConstraint!
    @IBOutlet weak var specialPriceTopSpacing: NSLayoutConstraint!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var aboutTitleLabel: UILabel!
    @IBOutlet weak var normalPriceHeight: NSLayoutConstraint!
    
    fileprivate var forDoCourse: Bool = false
    fileprivate var diveService: NDiveService?
    var onDiveCenterClicked: (NDiveCenter) -> () = {divecenter in }
    var onChatDCClicked: (String) -> () = {serviceId in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func chatButtonAction(_ sender: Any) {
        self.onChatDCClicked(self.diveService!.id!)
    }
    
    @IBAction func diveCenterButtonAction(_ sender: Any) {
        self.onDiveCenterClicked(diveService!.divecenter!)
    }
    
    func initData(diveService: NDiveService) {
        self.diveService = diveService
        if let name = diveService.name {
            self.titleLabel.text = name
        }
        if let diveCenter = diveService.divecenter {
            if let imageLogo = diveCenter.imageLogo {
                self.diveCenterImage.loadImage(from: imageLogo, contentMode: .scaleAspectFit, with: "image_default.png")
            } else {
                self.diveCenterImage.image = UIImage(named: "image_default.png")
            }
            self.diveCenterNameLabel.text = diveCenter.name
        }
        if let diveSpots = diveService.diveSpots, !diveSpots.isEmpty {
            var i:Int = 0
            var diveSpotList: String = ""
            for divespot in diveSpots {
                diveSpotList += "\(divespot.name!)"
                if i < diveSpots.count - 1 {
                    diveSpotList += ", "
                }
                i += 1
            }
            self.divespotLabel.text = diveSpotList
        } else {
            self.divespotLabel.text = "-"
        }
        self.ratingView.rating = diveService.rating
//        self.visitorCounterLabel.text = "\(diveService.ratingCount) / \(diveService.visited) visited"
        self.normalPriceLabel.text = diveService.normalPrice.toCurrencyFormatString(currency: "Rp.")
        self.specialPriceLabel.text = diveService.specialPrice.toCurrencyFormatString(currency:"Rp.")
        if diveService.normalPrice == diveService.specialPrice {
            self.normalPriceContainer.isHidden = true
            self.specialPriceTopSpacing.constant = 0
            self.normalPriceHeight.constant = 0
        } else {
            self.specialPriceTopSpacing.constant = 8
            self.normalPriceContainer.isHidden = false
            self.normalPriceHeight.constant = 17
        }
        if self.forDoCourse {
            self.aboutTitleLabel.text = "About Course"
            self.additionalLabel1.text = "Day Class"
            self.additionalLabel2.text = "Day On Site"
            self.additionalLabel3.text = "Open Water"
            self.additionalLabel4.text = ""
            self.additionalLabel4Colon.text = ""
            self.stockLabel.text = ""
            self.additionalLabel4Height.constant = 0
            self.totalDivesCounterLabel.text = "\(diveService.totalDays) Day" + (diveService.totalDays>1 ? "s" : "")
            self.divespotCounterLabel.text = "\(diveService.dayOnSite) Day" + (diveService.dayOnSite>1 ? "s" : "")
            self.tripDurationLabel.text = diveService.openWater ? "Yes" : "No"
            self.divespotLabel.text = ""
            self.divespotTopSpacing.constant = 0
            self.categoryContainer.isHidden = true
            self.licenseContainer.isHidden = true
            self.categoryHeightConstraint.constant = 0
            self.licenseTopSpacing.constant = 0
        } else {
            self.aboutTitleLabel.text = "About Trips"
            self.additionalLabel1.text = "Total Dives"
            self.additionalLabel2.text = "Divespot Options"
            self.additionalLabel3.text = "Trip Durations"
            self.additionalLabel4.text = "Available Slot"
            self.additionalLabel4Height.constant = 17
            self.additionalLabel4Colon.text = ":"
            self.stockLabel.text = String(diveService.availability)
            self.totalDivesCounterLabel.text = "\(diveService.totalDives)"
            self.divespotCounterLabel.text = diveService.diveSpots != nil ? "\(diveService.diveSpots!.count)" : "0"
            self.tripDurationLabel.text = "\(diveService.totalDays) Day" + (diveService.totalDays>1 ? "s" : "")
            self.divespotTopSpacing.constant = 16
            self.categoryContainer.isHidden = false
            self.licenseContainer.isHidden = false
            self.categoryHeightConstraint.constant = 32
            self.licenseTopSpacing.constant = 16
            if diveService.license {
                self.licenseContainer.backgroundColor = UIColor.nyOrange
                self.licenseLabel.textColor = UIColor.white
                self.licenseLabel.text = "License Needed"
                self.licenseImageView.image = UIImage(named: "ic_license_white")
            } else {
                self.licenseContainer.backgroundColor = UIColor.lightGray
                self.licenseLabel.textColor = UIColor.white
                self.licenseLabel.text = "No Need License"
                self.licenseImageView.image = UIImage(named: "ic_license_white")
            }
            if let nsset = diveService.categories, let categories = nsset.allObjects as? [NCategory], !categories.isEmpty {
                self.categoryLabel.text = categories[0].name
            }
        }
        if let facilities = diveService.facilities {
            if facilities.towel {
                self.towelImageView.image = UIImage(named: self.faciltyMapping["towel"]![0])
            } else {
                self.towelImageView.image = UIImage(named: self.faciltyMapping["towel"]![1])
            }
            if facilities.diveEquipment {
                self.equipmentImageView.image = UIImage(named: self.faciltyMapping["equipment"]![0])
            } else {
                self.equipmentImageView.image = UIImage(named: self.faciltyMapping["equipment"]![1])
            }
            if facilities.diveGuide {
                self.diveGuideImageView.image = UIImage(named: self.faciltyMapping["dive_guide"]![0])
            } else {
                self.diveGuideImageView.image = UIImage(named: self.faciltyMapping["dive_guide"]![1])
            }
            if facilities.food {
                self.foodAndDrinkImageView.image = UIImage(named: self.faciltyMapping["food"]![0])
            } else {
                self.foodAndDrinkImageView.image = UIImage(named: self.faciltyMapping["food"]![1])
            }
            if facilities.transportation {
                self.transportationImageView.image = UIImage(named: self.faciltyMapping["transport"]![0])
            } else {
                self.transportationImageView.image = UIImage(named: self.faciltyMapping["transport"]![1])
            }
            if facilities.accomodation {
                self.accomodationImageView.image = UIImage(named: self.faciltyMapping["accomodation"]![0])
            } else {
                self.accomodationImageView.image = UIImage(named: self.faciltyMapping["accomodation"]![1])
            }
        }
        if let descript = diveService.diveServiceDescription, !descript.isEmpty {
            self.descriptionLabel.attributedText = NSAttributedString.htmlAttriButedText(str: descript, fontName: "FiraSans-Regular", size: 14, color: UIColor.darkGray
            )
        } else {
            self.descriptionLabel.text = "-"
        }
    }
}


class DiveServiceRelatedCell: NTableViewCell {
    @IBOutlet weak var relatedServiceLabel: UILabel!
    @IBOutlet weak var scroller: UIScrollView!
    
    var isDoTrip: Bool = false
    var onRelatedServiceClicked: (NDiveService) -> () = {service in }
    var controller: UIViewController?
    
    @IBOutlet weak var scrollerHeightConstraint: NSLayoutConstraint!
    
    var relatedDiveServices: [NDiveService]? {
        didSet {
            for subview: UIView in self.scroller.subviews {
                subview.removeFromSuperview()
            }
            
            if self.relatedDiveServices != nil {

                
                var i: Int = 0
                var leftView: UIView? = nil
                for service: NDiveService in self.relatedDiveServices! {
                    let view: NServiceView = self.createView(for: service)
                    view.control.tag = i
                    view.isDoTrip = self.isDoTrip
                    view.initData(diveService: service)
                    view.addTarget(self, action: #selector(DiveServiceRelatedCell.onServiceClicked(at:)))
//                    DTMHelper.addShadow(view)
                    
                    self.scroller.addSubview(view)
                    self.scroller.addConstraints([
                        NSLayoutConstraint(item: self.scroller, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self.scroller, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
                        ])
                    
                    if leftView == nil {
                        self.scroller.addConstraint(NSLayoutConstraint(item: self.scroller, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
                    } else {
                        self.scroller.addConstraint(NSLayoutConstraint(item: leftView!, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: -8))
                    }
                    
                    if i == self.relatedDiveServices!.count - 1 {
                        self.scroller.addConstraint(NSLayoutConstraint(item: self.scroller, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0))
                    }
                    
                    i += 1
                    leftView = view
                }
                var height: CGFloat = 350
                if self.isDoTrip {
                    height = 360
                }
                if NDisplay.typeIsLike == .iphone5 || NDisplay.typeIsLike == .iphone4 {
                    if self.isDoTrip {
                        height = 340
                    } else {
                        height = 330
                    }
                }
                self.scrollerHeightConstraint.constant = height
            }
        }
    }
    
    @objc func onServiceClicked(at sender: UIControl) {
        let index = sender.tag
        let diveService = relatedDiveServices![index]
        self.onRelatedServiceClicked(diveService)
    }
    
    fileprivate func createView(for service: NDiveService) -> NServiceView {
        let view: NServiceView = NServiceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.controller!.view.frame.width * 75/100))
        var height: CGFloat = 350
        if self.isDoTrip {
            height = 360
        }
        if NDisplay.typeIsLike == .iphone5 || NDisplay.typeIsLike == .iphone4 {
            if self.isDoTrip {
                height = 340
            } else {
                height = 330
            }
        }
        view.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height))

        return view
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class AddOnCell: NTableViewCell {
    
    @IBOutlet weak var equipmentItemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

enum TableState {
    case detail
    case review
}


