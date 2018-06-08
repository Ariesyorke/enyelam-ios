//
//  DiveCenterController.swift
//  Nyelam
//
//  Created by Bobi on 4/27/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import Cosmos
import GoogleMaps
import MapKit

class DiveCenterController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var reviewNotFoundLabel: UILabel!
    
    static func push(on controller: UINavigationController, forDoTrip: Bool, selectedKeyword: SearchResult?, selectedLicense: Bool, selectedDiver: Int, selectedDate: Date, ecoTrip: Int?,
                     diveCenter: NDiveCenter?) -> DiveCenterController {
        let vc: DiveCenterController = DiveCenterController(nibName: "DiveCenterController", bundle: nil)
        vc.selectedLicense = selectedLicense
        vc.selectedDiver = selectedDiver
        vc.selectedDate = selectedDate
        vc.selectedKeyword = selectedKeyword
        vc.ecotrip = ecoTrip
        vc.forDoTrip = forDoTrip
        vc.diveCenter = diveCenter
        controller.setNavigationBarHidden(false, animated: true)
        controller.navigationBar.barTintColor = UIColor.primary
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    static func push(on controller: UINavigationController, forDoCourse: Bool, selectedKeyword: SearchResult?, selectedDiver: Int, selectedDate: Date, selectedOrganization: NMasterOrganization, selectedLicenseType: NLicenseType, diveCenter: NDiveCenter?) -> DiveCenterController {
        let vc: DiveCenterController = DiveCenterController(nibName: "DiveCenterController", bundle: nil)
        vc.selectedDiver = selectedDiver
        vc.selectedDate = selectedDate
        vc.selectedKeyword = selectedKeyword
        vc.forDoCourse = forDoCourse
        vc.selectedOrganization = selectedOrganization
        vc.selectedLicenseType = selectedLicenseType
        vc.diveCenter = diveCenter
        controller.setNavigationBarHidden(false, animated: true)
        controller.navigationBar.barTintColor = UIColor.primary
        controller.pushViewController(vc, animated: true)
        return vc
    }

    fileprivate var forDoTrip: Bool = false
    fileprivate var forDoCourse: Bool = false
    fileprivate var ecotrip: Int?
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
    fileprivate var diveCenter: NDiveCenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.firstTime {
            self.firstTime = false
            self.tryLoadDiveCenterDetail(diveCenterId: self.diveCenter!.id!)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func initView() {
        self.title = "Dive Center"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nibViews = Bundle.main.loadNibNamed("NStickyHeaderView", owner: self, options: nil)
        self.strechyHeaderView = nibViews!.first as! NStickyHeaderView
        self.strechyHeaderView!.delegate = self
        self.strechyHeaderView!.expansionMode = .topOnly
        self.strechyHeaderView!.tabDetailLineView.isHidden = false
        self.tableView.addSubview(self.strechyHeaderView!)
        
        self.tableView.register(UINib(nibName: "DiveCenterDetailCell", bundle: nil), forCellReuseIdentifier: "DiveCenterDetailCell")
        self.tableView.register(UINib(nibName: "DiveServiceRelatedCell", bundle: nil), forCellReuseIdentifier: "DiveServiceRelatedCell")
    }

    fileprivate func tryLoadDiveCenterDetail(diveCenterId: String) {
        self.loadingView.isHidden = false
        self.tableView.isHidden = true
        NHTTPHelper.httpDetail(diveCenterId: diveCenterId, complete: {response in
            if let error = response.error {
                self.loadingView.isHidden = true
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.tryLoadDiveCenterDetail(diveCenterId: diveCenterId)
                        })
                    }
                })
                return
            }
            if let data = response.data {
                self.diveCenter = data
                var images: [String] = [self.diveCenter!.featuredImage!]
                if let imgs = self.diveCenter!.images, !imgs.isEmpty {
                    images.append(contentsOf: imgs)
                }
                self.strechyHeaderView!.initBanner(images: images)
                self.tryLoadRelatedServices(diveCenterId: diveCenterId, selectedLicense: self.selectedLicense ? 1: 0, selectedDate: self.selectedDate!, selectedDiver: self.selectedDiver, ecoTrip: self.ecotrip, forDoTrip: self.forDoTrip, forDoCourse: self.forDoCourse, organizationId: self.selectedOrganization != nil ? self.selectedOrganization!.id! : nil, licenseTypeId: self.selectedLicenseType != nil ? self.selectedLicenseType!.id! : nil)
            }
        })
    }
    
    fileprivate func tryLoadRelatedServices(diveCenterId: String, selectedLicense: Int, selectedDate: Date, selectedDiver: Int, ecoTrip: Int?, forDoTrip: Bool, forDoCourse: Bool, organizationId: String?, licenseTypeId: String?) {
        if forDoTrip {
            NHTTPHelper.httpDoTripSearchBy(diveCenterId: diveCenterId, page: "1", diver: selectedDiver, certificate: nil, date: Date().timeIntervalSince1970, sortBy: 1, ecoTrip: self.ecotrip, totalDives: nil, categories: nil, facilities: nil, priceMin: nil, priceMax: nil, complete: {response in
                self.loadingView.isHidden = true
                if let data = response.data, !data.isEmpty {
                    self.relatedDiveServices = data
                }
                self.tableView.isHidden = false
                self.tableView.reloadData()
            })
        } else if forDoCourse {
            NHTTPHelper.httpDoCourseSearchBy(diveCenterId: diveCenterId, page: "1", date: selectedDate.timeIntervalSince1970, selectedDiver: selectedDiver, sortBy: 1, organizationId: organizationId!, licenseTypeId: licenseTypeId!, openWater: nil, priceMin: nil, priceMax: nil, facilities: nil, complete: {response in
                self.loadingView.isHidden = true
                if let data = response.data, !data.isEmpty {
                    self.relatedDiveServices = data
                }
                self.tableView.isHidden = false
                self.tableView.reloadData()
            })
        } else {
            NHTTPHelper.httpDoDiveSearchBy(diveCenterId: diveCenterId, page: "1", diver: selectedDiver, certificate: selectedLicense, date: selectedDate.timeIntervalSince1970, sortBy: 1, ecoTrip: self.ecotrip, totalDives: nil, categories: nil, facilities: nil, priceMin: nil, priceMax: nil, complete: {response in
                self.loadingView.isHidden = true
                if let data = response.data, !data.isEmpty {
                    self.relatedDiveServices = data
                }
                self.tableView.isHidden = false
                self.tableView.reloadData()
            })
        }
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

extension DiveCenterController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiveCenterDetailCell", for: indexPath) as! DiveCenterDetailCell
            cell.onOpenMap = {coordinate in
                if #available(iOS 10.0, *) {
                    let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)))
                    source.name = self.diveCenter!.name
                    MKMapItem.openMaps(with: [source], launchOptions: nil)
                } else {
                    let query = "?ll=\(String(coordinate.latitude)),\(String(coordinate.longitude))"
                    let urlString = "https://maps.apple.com/".appending(query)
                    if let url = URL(string: urlString) {
                        let success = UIApplication.shared.openURL(url)
                    }
                    // Fallback on earlier versions
                }
            }
            cell.initData(diveCenter: self.diveCenter!)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiveServiceRelatedCell", for: indexPath) as! DiveServiceRelatedCell
            cell.isDoTrip = self.forDoTrip
            cell.controller = self
            if cell.relatedDiveServices == nil || cell.relatedDiveServices!.isEmpty {
                cell.relatedDiveServices = self.relatedDiveServices
            }
            if self.forDoCourse {
                cell.relatedServiceLabel.text = "Our service courses"
            } else {
                cell.relatedServiceLabel.text = "Our service trips"
            }
            cell.onRelatedServiceClicked = {diveService in
                if self.forDoTrip {
                    let date = Date(timeIntervalSince1970: diveService.schedule!.startDate)
                    _ = DiveServiceController.push(on: self.navigationController!, forDoTrip: self.forDoTrip, selectedKeyword: self.selectedKeyword, selectedLicense: diveService.license, selectedDiver: 1, selectedDate: date, ecoTrip: self.ecotrip, diveService: diveService)
                } else if self.forDoCourse {
                    let date = Date(timeIntervalSince1970: diveService.schedule!.startDate)
                    _ = DiveServiceController.push(on: self.navigationController!, forDoCourse: self.forDoCourse, selectedKeyword: self.selectedKeyword, selectedDiver: 1, selectedDate: date, diveService: diveService, selectedOrganization: self.selectedOrganization!, selectedLicenseType: self.selectedLicenseType!)
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
            if let _ = self.diveCenter {
                count += 1
            }
            if let diveServices = self.relatedDiveServices, !diveServices.isEmpty {
                count += 1
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }

}

extension DiveCenterController: NStickyHeaderViewDelegate {
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

class DiveCenterDetailCell: NTableViewCell {
    private let METER_PER_MILE = 1609.344

    @IBOutlet weak var diveCenterNameLabel: UILabel!
//    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate var coordinate: Coordinate?
    
    var onOpenMap: (Coordinate)->() = {coordinate in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func mapButtonAction(_ sender: Any) {
        if let coordinate = self.coordinate {
            self.onOpenMap(coordinate)
        }
    }
    
    fileprivate func initData(diveCenter: NDiveCenter) {
        self.diveCenterNameLabel.text = diveCenter.name
//        self.rateView.rating = diveCenter.rating
//        self.counterLabel.text = "0 / 0 visited"
        self.mapView.showsUserLocation = false
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.standard
        self.mapView.isScrollEnabled = false
        if let contact = diveCenter.contact {
            self.phoneNumberLabel.text = contact.phoneNumber
            if let location = contact.location {
                if let coordinate = location.coordinate {
                    self.coordinate = coordinate
                    let centerCoord = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
                    self.mapView.setCenter(centerCoord, animated: true)
                    let span = MKCoordinateSpanMake(0.075, 0.075)
                    let region = MKCoordinateRegion(center: centerCoord, span: span)
                    self.mapView.setRegion(region, animated: true)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
                    annotation.title = diveCenter.name
                    self.mapView.addAnnotation(annotation)
                }
          
                var locationText = ""
                if let city = location.city {
                    locationText = "\(city.name!), "
                }
                if let province = location.province {
                    locationText += "\(province.name!)"
                }
                if let country = location.country {
                    locationText += " - \(country)"
                }
                self.locationLabel.text = locationText
            }
            
        }
        if let desc = diveCenter.diveDescription {
            self.descriptionLabel.attributedText = NSAttributedString.htmlAttriButedText(str: desc, fontName: "FiraSans-Regular", size: 14, color: UIColor.darkGray
            )
        } else {
            self.descriptionLabel.text = "-"
        }
    }
    
}

extension DiveCenterDetailCell: MKMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView: MKPinAnnotationView? = nil
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "PinAnnotation") as? MKPinAnnotationView {
            dequeuedView.annotation = annotation;
            pinView = dequeuedView;
        } else{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PinAnnotation");
        }
        pinView!.canShowCallout = true
        pinView!.rightCalloutAccessoryView = nil
        
        return pinView
    }
}
