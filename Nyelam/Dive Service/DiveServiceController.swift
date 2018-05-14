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

class DiveServiceController: BaseViewController {
    
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
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reviewNotFoundLabel: UILabel!
    @IBOutlet weak var stockTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        let id = self.diveService != nil ? self.diveService!.id!:self.selectedKeyword!.id!
        self.tryLoadServiceDetail(serviceId: id, selectedLicense: selectedLicense.number, selectedDate: selectedDate!, selectedDiver: selectedDiver, forDoTrip: self.forDoTrip, forDoCourse: self.forDoCourse)
        // Do any additional setup after loading the view.
    }
    
    fileprivate func initView() {
        if self.forDoTrip {
            let title = self.selectedDate!.formatDate(dateFormat: "MMM yyyy") + " " + String(self.selectedDiver) + " pax(s)"
            self.title = title
        } else {
            let title = self.selectedDate!.formatDate(dateFormat: "dd MMM yyyy") + " " + String(self.selectedDiver) + " pax(s)"
            self.title = title
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nibViews = Bundle.main.loadNibNamed("NStickyHeaderView", owner: self, options: nil)
        self.strechyHeaderView = nibViews!.first as! NStickyHeaderView
        self.strechyHeaderView!.delegate = self
        self.strechyHeaderView!.expansionMode = .immediate
        self.strechyHeaderView!.tabDetailLineView.isHidden = false
        self.tableView.addSubview(self.strechyHeaderView!)
        self.stockTextField.text = String(describing: self.selectedDiver)
        
        self.tableView.register(UINib(nibName: "DiveServiceDetailCell", bundle: nil), forCellReuseIdentifier: "DiveServiceDetailCell")
        self.tableView.register(UINib(nibName: "DiveServiceRelatedCell", bundle: nil), forCellReuseIdentifier: "DiveServiceRelatedCell")
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
                    var images: [String] = [self.diveService!.featuredImage!]
                    if let imgs = self.diveService!.images, !imgs.isEmpty {
                        images.append(contentsOf: imgs)
                    }
                    self.strechyHeaderView!.initBanner(images: images)
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
                    var images: [String] = [self.diveService!.featuredImage!]
                    if let imgs = self.diveService!.images, !imgs.isEmpty {
                        images.append(contentsOf: imgs)
                    }
                    self.strechyHeaderView!.initBanner(images: images)
                    let diveCenter = self.diveService!.divecenter!
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
                    var images: [String] = [self.diveService!.featuredImage!]
                    if let imgs = self.diveService!.images, !imgs.isEmpty {
                        images.append(contentsOf: imgs)
                    }
                    self.strechyHeaderView!.initBanner(images: images)
                    let diveCenter = self.diveService!.divecenter!
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
                self.goToAuth()
            }
        }
    }
    
    override func goToAuth() {
        let _ = AuthNavigationController.present(on: self, dismissCompletion: {
            if let authUser = NAuthReturn.authUser() {
                self.book(user: authUser.user!)
            }
        })
    }
    
    fileprivate func book(user: NUser) {
        let diveCenter = self.diveService!.divecenter!
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if self.forDoCourse {
            NHTTPHelper.httpBookService(diveCenterId: diveCenter.id!, diveServiceId: self.diveService!.id!, diver: self.selectedDiver, schedule: self.selectedDate!, type: 1, licenseTypeId: self.selectedLicenseType!.id!, organizationId: self.selectedOrganization!.id!, complete: {response in
                MBProgressHUD.hide(for: self.view, animated: true)
                if let error = response.error {
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.book(user: user)
                        })
                    } else if error.isKind(of: StatusFailedError.self) {
                        //TODO
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
            NHTTPHelper.httpBookService(diveCenterId: diveCenter.id!, diveServiceId: self.diveService!.id!, diver: self.selectedDiver, schedule: self.selectedDate!, type: 1, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
                if let error = response.error {
                    if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.book(user: user)
                        })
                    } else if error.isKind(of: StatusFailedError.self) {
                    //TODO
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
            self.reviewNotFoundLabel.isHidden = false
            self.strechyHeaderView!.tabDetailLineView.isHidden = true
            self.strechyHeaderView!.tabReviewLineView.isHidden = false
            self.state = .review
        }
        self.tableView.reloadData()
    }
}
extension DiveServiceController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiveServiceDetailCell", for: indexPath) as! DiveServiceDetailCell
            cell.forDoCourse = self.forDoCourse
            cell.initData(diveService: self.diveService!)
            cell.onDiveCenterClicked = {diveCenter in
                if self.forDoCourse {
                    _ = DiveCenterController.push(on: self.navigationController!, forDoCourse: self.forDoCourse, selectedKeyword: self.selectedKeyword, selectedDiver: 1, selectedDate: self.selectedDate!, selectedOrganization: self.selectedOrganization!, selectedLicenseType: self.selectedLicenseType!, diveCenter: diveCenter)
                } else {
                    _ = DiveCenterController.push(on: self.navigationController!, forDoTrip: self.forDoTrip, selectedKeyword: self.selectedKeyword, selectedLicense: self.selectedLicense, selectedDiver: 1, selectedDate: self.selectedDate!, ecoTrip: self.ecotrip, diveCenter: diveCenter)
                }
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiveServiceRelatedCell", for: indexPath) as! DiveServiceRelatedCell
            cell.isDoTrip = self.forDoTrip
            cell.controller = self
            cell.relatedDiveServices = self.relatedDiveServices
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if state == .detail {
            if let _ = self.diveService {
                count += 1
            }
            if let diveServices = self.relatedDiveServices, !diveServices.isEmpty {
                count += 1
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
    @IBOutlet weak var categoryHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var licenseTopSpacing: NSLayoutConstraint!
    
    fileprivate var forDoCourse: Bool = false
    fileprivate var diveService: NDiveService?
    var onDiveCenterClicked: (NDiveCenter) -> () = {divecenter in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
        self.visitorCounterLabel.text = "\(diveService.ratingCount) / \(diveService.visited) visited"
        self.normalPriceLabel.text = diveService.normalPrice.toCurrencyFormatString(currency: "Rp.")
        self.specialPriceLabel.text = diveService.specialPrice.toCurrencyFormatString(currency:"Rp.")
        if diveService.normalPrice == diveService.specialPrice {
            self.normalPriceContainer.isHidden = true
        } else {
            self.normalPriceContainer.isHidden = false
        }
        if self.forDoCourse {
            self.additionalLabel1.text = "Day Class"
            self.additionalLabel2.text = "Day On Site"
            self.additionalLabel3.text = "Open Water"
            self.totalDivesCounterLabel.text = "\(diveService.totalDives) Day" + (diveService.totalDays>1 ? "s" : "")
            self.divespotCounterLabel.text = "\(diveService.dayOnSite) Day" + (diveService.dayOnSite>1 ? "s" : "")
            self.tripDurationLabel.text = diveService.openWater ? "Yes" : "No"
            self.divespotLabel.text = ""
            self.divespotTopSpacing.constant = 0
            self.categoryContainer.isHidden = true
            self.licenseContainer.isHidden = true
            self.categoryHeightConstraint.constant = 0
            self.licenseTopSpacing.constant = 0
        } else {
            self.additionalLabel1.text = "Total Dives"
            self.additionalLabel2.text = "Divespot Options"
            self.additionalLabel3.text = "Trip Durations"
            self.totalDivesCounterLabel.text = "\(diveService.totalDives)"
            self.divespotCounterLabel.text = "\(diveService.diveSpots!.count)"
            self.tripDurationLabel.text = "\(diveService.totalDives) Day" + (diveService.totalDays>1 ? "s" : "")
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
            if let descript = diveService.diveServiceDescription {
                self.descriptionLabel.attributedText = NSAttributedString.htmlAttriButedText(str: descript, fontName: "FiraSans-Regular", size: 14, color: UIColor.darkGray
                )
            } else {
                self.descriptionLabel.text = "-"
            }
        }
    }
}


class DiveServiceRelatedCell: NTableViewCell {
    @IBOutlet weak var scroller: UIScrollView!
    var isDoTrip: Bool = false
    var onRelatedServiceClicked: (NDiveService) -> () = {service in }
    var controller: UIViewController?
    
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
                    view.isDoTrip = self.isDoTrip
                    view.initData(diveService: service)
                    view.addTarget(self, action: #selector(DiveServiceRelatedCell.onServiceClicked(at:)))
                    DTMHelper.addShadow(view)
                    
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

enum TableState {
    case detail
    case review
}


