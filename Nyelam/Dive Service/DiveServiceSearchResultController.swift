//
//  DiveServiceSearchResultController.swift
//  Nyelam
//
//  Created by Bobi on 4/23/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

class DiveServiceSearchResultController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var notFoundLabel: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    static func push(on controller: UINavigationController, forDoTrip: Bool, selectedKeyword: SearchResult, selectedLicense: Bool, selectedDiver: Int, selectedDate: Date, ecoTrip: Int?) -> DiveServiceSearchResultController {
        let vc: DiveServiceSearchResultController = DiveServiceSearchResultController(nibName: "DiveServiceSearchResultController", bundle: nil)
        vc.selectedLicense = selectedLicense
        vc.selectedDiver = selectedDiver
        vc.selectedDate = selectedDate
        vc.selectedKeyword = selectedKeyword
        vc.forDoTrip = forDoTrip
        vc.ecotrip = ecoTrip
        controller.setNavigationBarHidden(false, animated: true)
        controller.navigationBar.barTintColor = UIColor.primary
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    static func push(on controller: UINavigationController, forDoTrip: Bool, selectedDiver: Int, selectedDate: Date) -> DiveServiceSearchResultController {
        let vc: DiveServiceSearchResultController = DiveServiceSearchResultController(nibName: "DiveServiceSearchResultController", bundle: nil)
        vc.selectedDiver = selectedDiver
        vc.forDoTrip = forDoTrip
        vc.selectedDate = selectedDate
        controller.setNavigationBarHidden(false, animated: true)
        controller.navigationBar.barTintColor = UIColor.primary
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    static func push(on controller: UINavigationController, forDoCourse: Bool, selectedDiver: Int, selectedDate: Date, selectedKeyword: SearchResult?, selectedOrganization: NMasterOrganization, selectedLicenseType: NLicenseType) -> DiveServiceSearchResultController {
        let vc: DiveServiceSearchResultController = DiveServiceSearchResultController(nibName: "DiveServiceSearchResultController", bundle: nil)
        vc.selectedDiver = selectedDiver
        vc.forDoCourse = forDoCourse
        vc.selectedDate = selectedDate
        vc.selectedKeyword = selectedKeyword
        vc.selectedOrganization = selectedOrganization
        vc.selectedLicenseType = selectedLicenseType
        controller.setNavigationBarHidden(false, animated: true)
        controller.navigationBar.barTintColor = UIColor.primary
        controller.pushViewController(vc, animated: true)
        return vc
    }

    fileprivate var forDoTrip: Bool = false
    fileprivate var forDoCourse: Bool = false
    fileprivate var selectedLicense: Bool = false
    fileprivate var ecotrip: Int?
    fileprivate var diveServices: [NDiveService]?
    fileprivate var selectedKeyword: SearchResult?
    fileprivate var selectedDate: Date?
    fileprivate var selectedDiver: Int?
    fileprivate var selectedOrganization: NMasterOrganization?
    fileprivate var selectedLicenseType: NLicenseType?
    fileprivate var page: Int = 1
    fileprivate var filter: NFilter = NFilter()
    fileprivate var price: Price = Price(lowestPrice: 50000, highestPrice: 10000000)

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.addInfiniteScroll(handler: self.infiniteScroll)
        self.tableView.register(UINib(nibName: "DiveServiceCell", bundle: nil), forCellReuseIdentifier: "DiveServiceCell")
        self.loadPrice(keyword: self.selectedKeyword, forDoTrip: self.forDoTrip, selectedDiver: self.selectedDiver!, certificate: self.forDoCourse ? nil : self.selectedLicense, selectedDate: self.selectedDate, ecoTrip: self.ecotrip)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func filterButtonAction(_ sender: Any) {
        if self.forDoCourse {
            _ = DiveTripFilterController.push(on: self.navigationController!, price: self.price, forDoCourse: self.forDoCourse, filter: self.filter, onUpdateFilter: {filter in
                self.page = 1
                self.diveServices = nil
                self.tableView.reloadData()
                self.filter = filter
                self.loadDiveServices()
            })
        } else {
            _ = DiveTripFilterController.push(on: self.navigationController!, price: self.price,    filter: self.filter, onUpdateFilter: {filter in
                    self.page = 1
                    self.diveServices = nil
                    self.tableView.reloadData()
                    self.filter = filter
                    self.loadDiveServices()
                })
        }
    }
    
    fileprivate func loadPrice(keyword: SearchResult?, forDoTrip: Bool, selectedDiver: Int, certificate: Bool?, selectedDate: Date?, ecoTrip: Int?) {
        var provinceId: String? = nil
        var cityId: String? = nil
        var diveSpotId: String? = nil
        var diveCenterId: String? = nil
        var categories: [String]? = nil
        if let keyword = keyword as? SearchResultProvince {
            provinceId = keyword.id
        } else if let keyword = keyword as? SearchResultCity {
            cityId = keyword.id
        } else if let keyword = keyword as? SearchResultSpot {
            diveSpotId = keyword.id
        } else if let keyword = keyword as? SearchResultDiveCenter {
            diveCenterId = keyword.id
        }
        if let keyword = keyword as? SearchResultCategory {
            categories = []
            categories!.append(keyword.id!)
        }
        NHTTPHelper.httpGetMinMaxPrice(type: forDoTrip ? "2" : (self.forDoCourse ? "3" : "1"), diver: selectedDiver, certificate: certificate != nil ? (certificate! ? 1 : 0) : nil, date: selectedDate, categories: categories, diveSpotId: diveSpotId, provinceId: provinceId, cityId: cityId, diveCenterId: diveCenterId, ecoTrip: ecoTrip, totalDives: nil, facilites: nil, complete: {response in
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.loadPrice(keyword: keyword, forDoTrip: forDoTrip, selectedDiver: selectedDiver, certificate: certificate, selectedDate: selectedDate, ecoTrip: ecoTrip)
                    })
                    return
                } else {
                    
                }
            }
            if let data = response.data {
                self.price = data
                self.loadDiveServices()
            }
        })
    }
    
    fileprivate func loadDiveServices() {
        if self.forDoTrip {
            self.title = "Do Trip"
            self.getAllDoTrip(page: page, selectedDiver: selectedDiver!, filter: filter)
        } else if self.forDoCourse {
            let title = self.selectedDate!.formatDate(dateFormat: "MMM yyyy") + " " + String(self.selectedDiver!) + " pax(s)"
            self.title = title
            self.searchDoCourse(selectedKeyword: self.selectedKeyword!, selectedDate: self.selectedDate!, selectedDiver: self.selectedDiver!, selectedOrganization: self.selectedOrganization!, selectedLicenseType: self.selectedLicenseType!, selectedfilter: self.filter)
        } else {
            let title = self.selectedDate!.formatDate(dateFormat: "dd MMM yyyy") + " " + String(self.selectedDiver!) + " pax(s)"
            self.title = title
            self.searchDiveService(selectedKeyword: self.selectedKeyword!, selectedDate: self.selectedDate!, selectedDiver: self.selectedDiver!, selectedLicense: self.selectedLicense, forDoTrip: self.forDoTrip, filter: self.filter, ecotrip: self.ecotrip)
        }
    }
    
    fileprivate func searchDoCourse(selectedKeyword: SearchResult, selectedDate: Date, selectedDiver: Int, selectedOrganization: NMasterOrganization, selectedLicenseType: NLicenseType, selectedfilter: NFilter) {
        let sortBy = filter.sortBy
        let facilities = filter.facilities
        let priceMin = filter.priceMin
        let priceMax = filter.priceMax
        let openwater = filter.openWater
        if let keyword = selectedKeyword as? SearchResultCity {
            NHTTPHelper.httpDoCourseSearchBy(cityId: keyword.id!, page: String(self.page), date: selectedDate.timeIntervalSince1970, selectedDiver: selectedDiver, sortBy: sortBy, organizationId: selectedOrganization.id!, licenseTypeId: selectedLicenseType.id!, openWater: openwater, priceMin: priceMin, priceMax: priceMax, facilities: facilities, complete: {response in
                if let error = response.error {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                        if error.isKind(of: NotConnectedInternetError.self) {
                            NHelper.handleConnectionError(completion: {
                                self.searchDoCourse(selectedKeyword: selectedKeyword, selectedDate: selectedDate, selectedDiver: selectedDiver, selectedOrganization: selectedOrganization, selectedLicenseType: selectedLicenseType, selectedfilter: selectedfilter)
                            })
                        }
                    })
                    return
                }
                self.initServices(diveServices: response.data)
            })
        } else if let keyword = selectedKeyword as? SearchResultProvince {
            NHTTPHelper.httpDoCourseSearchBy(provinceId: keyword.id!, page: String(self.page), date: selectedDate.timeIntervalSince1970, selectedDiver: selectedDiver, sortBy: sortBy, organizationId: selectedOrganization.id!, licenseTypeId: selectedLicenseType.id!, openWater: openwater, priceMin: priceMin, priceMax: priceMax, facilities: facilities, complete: {response in
                if let error = response.error {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                        if error.isKind(of: NotConnectedInternetError.self) {
                            NHelper.handleConnectionError(completion: {
                                self.searchDoCourse(selectedKeyword: selectedKeyword, selectedDate: selectedDate, selectedDiver: selectedDiver, selectedOrganization: selectedOrganization, selectedLicenseType: selectedLicenseType, selectedfilter: selectedfilter)
                            })
                        }
                    })
                    return
                }
                self.initServices(diveServices: response.data)
            })
        } else if let keyword = selectedKeyword as? SearchResultDiveCenter {
            NHTTPHelper.httpDoCourseSearchBy(diveCenterId: keyword.id!, page: String(self.page), date: selectedDate.timeIntervalSince1970, selectedDiver: selectedDiver, sortBy: sortBy, organizationId: selectedOrganization.id!, licenseTypeId: selectedLicenseType.id!, openWater: openwater, priceMin: priceMin, priceMax: priceMax, facilities: facilities, complete: {response in
                if let error = response.error {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                        if error.isKind(of: NotConnectedInternetError.self) {
                            NHelper.handleConnectionError(completion: {
                                self.searchDoCourse(selectedKeyword: selectedKeyword, selectedDate: selectedDate, selectedDiver: selectedDiver, selectedOrganization: selectedOrganization, selectedLicenseType: selectedLicenseType, selectedfilter: selectedfilter)
                            })
                        }
                    })
                    return
                }
                self.initServices(diveServices: response.data)
            })
        }
    }
    fileprivate func searchDiveService(selectedKeyword: SearchResult, selectedDate: Date, selectedDiver: Int, selectedLicense: Bool, forDoTrip: Bool, filter: NFilter, ecotrip: Int?) {
        self.loadingView.isHidden = false
        
        let sortBy = filter.sortBy
        var categories = filter.categories
        let facilities = filter.facilities
        let priceMin = filter.priceMin
        let priceMax = filter.priceMax
        let totalDives = filter.totalDives
        
        if let keyword = selectedKeyword as? SearchResultCity {
            if forDoTrip {
                NHTTPHelper.httpDoTripSearchBy(cityId: keyword.id!, page: String(self.page), diver: selectedDiver, certificate: selectedLicense.number, date: selectedDate.timeIntervalSince1970, sortBy: sortBy, ecoTrip: ecotrip, totalDives: totalDives, categories: categories, facilities: facilities, priceMin: priceMin, priceMax: priceMax, complete: {response in
                    if let error = response.error {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                            if error.isKind(of: NotConnectedInternetError.self) {
                                NHelper.handleConnectionError(completion: {
                                    self.searchDiveService(selectedKeyword: selectedKeyword, selectedDate: selectedDate, selectedDiver: selectedDiver, selectedLicense: selectedLicense, forDoTrip: forDoTrip, filter: filter, ecotrip: ecotrip)
                                })
                            }
                        })
                        return
                    }
                    self.initServices(diveServices: response.data)
                })
            } else {
                NHTTPHelper.httpDoDiveSearchBy(cityId: keyword.id!, page: String(page), diver: selectedDiver, certificate: selectedLicense.number, date: selectedDate.timeIntervalSince1970, sortBy: sortBy, ecoTrip: ecotrip, totalDives: totalDives, categories: categories, facilities: facilities, priceMin: priceMin, priceMax: priceMax, complete: {response in
                    if let error = response.error {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                            if error.isKind(of: NotConnectedInternetError.self) {
                                NHelper.handleConnectionError(completion: {
                                    self.searchDiveService(selectedKeyword: selectedKeyword, selectedDate: selectedDate, selectedDiver: selectedDiver, selectedLicense: selectedLicense, forDoTrip: forDoTrip, filter: filter, ecotrip: ecotrip)
                                })
                            }
                        })
                        return
                    }
                    self.initServices(diveServices: response.data)
                })
            }
        } else if let keyword = selectedKeyword as? SearchResultSpot {
            if forDoTrip {
                NHTTPHelper.httpDoTripSearchBy(diveSpotId: keyword.id!, page: String(page), diver: selectedDiver, certificate: selectedLicense.number, date: selectedDate.timeIntervalSince1970, sortBy: sortBy, ecoTrip: ecotrip, totalDives: totalDives, categories: categories, facilities: facilities, priceMin: priceMin, priceMax: priceMax, complete: {response in
                    if let error = response.error {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                            if error.isKind(of: NotConnectedInternetError.self) {
                                NHelper.handleConnectionError(completion: {
                                    self.searchDiveService(selectedKeyword: selectedKeyword, selectedDate: selectedDate, selectedDiver: selectedDiver, selectedLicense: selectedLicense, forDoTrip: forDoTrip, filter: filter, ecotrip: ecotrip)
                                })
                            }
                        })
                        return
                    }
                    self.initServices(diveServices: response.data)
                })
            } else {
                NHTTPHelper.httpDoDiveSearchBy(diveSpotId: keyword.id!, page: String(page), diver: selectedDiver, certificate: selectedLicense.number, date: selectedDate.timeIntervalSince1970, sortBy: sortBy, ecoTrip: ecotrip, totalDives: totalDives, categories: categories, facilities: facilities, priceMin: priceMin, priceMax: priceMax, complete: {response in
                    if let error = response.error {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                            if error.isKind(of: NotConnectedInternetError.self) {
                                NHelper.handleConnectionError(completion: {
                                    self.searchDiveService(selectedKeyword: selectedKeyword, selectedDate: selectedDate, selectedDiver: selectedDiver, selectedLicense: selectedLicense, forDoTrip: forDoTrip, filter: filter, ecotrip: ecotrip)
                                })
                            }
                        })
                        return
                    }
                    self.initServices(diveServices: response.data)
                })
            }
        } else if let keyword = selectedKeyword as? SearchResultCategory {
            if categories == nil {
                categories = []
            }
            categories!.append(keyword.id!)
            if forDoTrip {
                //DEPRECATED
                NHTTPHelper.httpDoTripSearchBy(categories: categories!, page: String(page), diver: selectedDiver, certificate: selectedLicense.number, date: selectedDate.timeIntervalSince1970, sortBy: sortBy, totalDives: totalDives, facilities: facilities, priceMin: priceMin, priceMax: priceMin, complete: {response in
                    if let error = response.error {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                            if error.isKind(of: NotConnectedInternetError.self) {
                                NHelper.handleConnectionError(completion: {
                                    self.searchDiveService(selectedKeyword: selectedKeyword, selectedDate: selectedDate, selectedDiver: selectedDiver, selectedLicense: selectedLicense, forDoTrip: forDoTrip, filter: filter, ecotrip: ecotrip)
                                })
                            }
                        })
                        return
                    }
                    self.initServices(diveServices: response.data)
                })
            } else {
                NHTTPHelper.httpDoDiveSearchBy(categories: categories!, page: String(page), diver: selectedDiver, certificate: selectedLicense.number, date: selectedDate.timeIntervalSince1970, sortBy: sortBy, ecoTrip: ecotrip, totalDives: totalDives, facilities: facilities, priceMin: priceMin, priceMax: priceMax, complete: {response in
                    if let error = response.error {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                            if error.isKind(of: NotConnectedInternetError.self) {
                                NHelper.handleConnectionError(completion: {
                                    self.searchDiveService(selectedKeyword: selectedKeyword, selectedDate: selectedDate, selectedDiver: selectedDiver, selectedLicense: selectedLicense, forDoTrip: forDoTrip, filter: filter, ecotrip: ecotrip)
                                })
                            }
                        })
                        return
                    }
                    self.initServices(diveServices: response.data)
                })
            }
        } else if let keyword = selectedKeyword as? SearchResultProvince {
            if forDoTrip {
                //DEPRECATED
                NHTTPHelper.httpDoTripSearchBy(provinceId: keyword.id!, page: String(page), diver: selectedDiver, certificate: selectedLicense.number, date: selectedDate.timeIntervalSince1970, sortBy: sortBy, ecoTrip: ecotrip, totalDives: totalDives, categories: categories, facilities: facilities, priceMin: priceMin, priceMax: priceMax, complete: {response in
                    if let error = response.error {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                            if error.isKind(of: NotConnectedInternetError.self) {
                                NHelper.handleConnectionError(completion: {
                                    self.searchDiveService(selectedKeyword: selectedKeyword, selectedDate: selectedDate, selectedDiver: selectedDiver, selectedLicense: selectedLicense, forDoTrip: forDoTrip, filter: filter, ecotrip: ecotrip)
                                })
                            }
                        })
                        return
                    }
                    self.initServices(diveServices: response.data)
                })
            } else {
                NHTTPHelper.httpDoDiveSearchBy(provinceId: selectedKeyword.id!, page: String(page), diver: selectedDiver, certificate: selectedLicense.number, date: selectedDate.timeIntervalSince1970, sortBy: sortBy, ecoTrip: ecotrip, totalDives: totalDives, categories: categories, facilities: facilities, priceMin: priceMin, priceMax: priceMax, complete: {response in
                    if let error = response.error {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                            if error.isKind(of: NotConnectedInternetError.self) {
                                NHelper.handleConnectionError(completion: {
                                    self.searchDiveService(selectedKeyword: selectedKeyword, selectedDate: selectedDate, selectedDiver: selectedDiver, selectedLicense: selectedLicense, forDoTrip: forDoTrip, filter: filter, ecotrip: ecotrip)
                                })
                            }
                        })
                        return
                    }
                    self.initServices(diveServices: response.data)
                })
            }
        } else if let keyword = selectedKeyword as? SearchResultDiveCenter {
            if forDoTrip {
                //DEPRECATED
                NHTTPHelper.httpDoTripSearchBy(diveCenterId: keyword.id!, page: String(page), diver: selectedDiver, certificate: selectedLicense.number, date: selectedDate.timeIntervalSince1970, sortBy: sortBy, ecoTrip: ecotrip, totalDives: totalDives, categories: categories, facilities: facilities, priceMin: priceMin, priceMax: priceMax, complete: {response in
                    if let error = response.error {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                            if error.isKind(of: NotConnectedInternetError.self) {
                                NHelper.handleConnectionError(completion: {
                                    self.searchDiveService(selectedKeyword: selectedKeyword, selectedDate: selectedDate, selectedDiver: selectedDiver, selectedLicense: selectedLicense, forDoTrip: forDoTrip, filter: filter, ecotrip: ecotrip)
                                })
                            }
                        })
                        return
                    }
                    self.initServices(diveServices: response.data)
                })
            } else {
                NHTTPHelper.httpDoDiveSearchBy(diveCenterId: keyword.id!, page: String(page), diver: selectedDiver, certificate: selectedLicense.number, date: selectedDate.timeIntervalSince1970, sortBy: sortBy, ecoTrip: ecotrip, totalDives: totalDives, categories: categories, facilities: facilities, priceMin: priceMin, priceMax: priceMax, complete: {response in
                    if let error = response.error {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                            if error.isKind(of: NotConnectedInternetError.self) {
                                NHelper.handleConnectionError(completion: {
                                    self.searchDiveService(selectedKeyword: selectedKeyword, selectedDate: selectedDate, selectedDiver: selectedDiver, selectedLicense: selectedLicense, forDoTrip: forDoTrip, filter: filter, ecotrip: ecotrip)
                                })
                            }
                        })
                        return
                    }
                    self.initServices(diveServices: response.data)
                })
            }
        }
    }
    
    fileprivate func initServices(diveServices: [NDiveService]?) {
        self.loadingView.isHidden = true
        if let diveServices = diveServices, !diveServices.isEmpty {
            if self.diveServices == nil {
                self.diveServices = []
            }
            self.diveServices!.append(contentsOf: diveServices)
            self.page += 1
        }
        if self.diveServices == nil || self.diveServices!.isEmpty {
            self.notFoundLabel.isHidden = false
        } else {
            self.notFoundLabel.isHidden = true
        }
        self.tableView.reloadData()
    }
    
    fileprivate func getAllDoTrip(page: Int, selectedDiver: Int, filter: NFilter) {
        let sortBy = filter.sortBy
        var categories = filter.categories
        let facilities = filter.facilities
        let priceMin = filter.priceMin
        let priceMax = filter.priceMax
        let totalDives = filter.totalDives
        self.loadingView.isHidden = false
        NHTTPHelper.httpGetAllDoTrip(page: String(page), diver: selectedDiver, sortBy: sortBy, totalDives: totalDives, categories: categories, facilities: facilities, priceMin: priceMin, priceMax: priceMax, complete: {response in
            if let error = response.error {
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.getAllDoTrip(page: page, selectedDiver: selectedDiver, filter: filter)
                        })
                    }
                })
                return
            }
            self.initServices(diveServices: response.data)
        })
    }
    
    func infiniteScroll(tableview: UITableView) -> () {
        if self.forDoTrip {
            self.getAllDoTrip(page: page, selectedDiver: selectedDiver!, filter: filter)
        } else if self.forDoCourse {
            self.searchDoCourse(selectedKeyword: self.selectedKeyword!, selectedDate: self.selectedDate!, selectedDiver: self.selectedDiver!, selectedOrganization: self.selectedOrganization!, selectedLicenseType: self.selectedLicenseType!, selectedfilter: self.filter)
        } else {
            self.searchDiveService(selectedKeyword: self.selectedKeyword!, selectedDate: self.selectedDate!, selectedDiver: self.selectedDiver!, selectedLicense: self.selectedLicense, forDoTrip: self.forDoTrip, filter: self.filter, ecotrip: self.ecotrip)
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

extension DiveServiceSearchResultController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.diveServices != nil ? self.diveServices!.count : 0
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell: DiveServiceCell = tableView.dequeueReusableCell(withIdentifier: "DiveServiceCell", for: indexPath) as! DiveServiceCell
        cell.serviceView.isDoCourse = self.forDoCourse
        cell.serviceView.isDoTrip = self.forDoTrip
        cell.serviceView.tag = row
        cell.serviceView.addTarget(self, action: #selector(DiveServiceSearchResultController.onDoTripClicked(at:)))
        cell.serviceView.initData(diveService: self.diveServices![row])
        return cell
    }
    
    @objc func onDoTripClicked(at sender: UIControl) {
        let index = sender.tag
        let diveService = self.diveServices![index]
        if self.forDoTrip {
            self.selectedDate = Date(timeIntervalSince1970: diveService.schedule!.startDate)
        }
        _ = DiveServiceController.push(on: self.navigationController!, forDoTrip: self.forDoTrip, selectedKeyword: self.selectedKeyword, selectedLicense: diveService.license, selectedDiver: self.selectedDiver!, selectedDate: self.selectedDate!, ecoTrip: self.ecotrip, diveService: diveService)

    }
    
}

class NFilter  {
    var priceMin: Int?
    var priceMax: Int?
    var categories: [String]?
    var facilities: [String]?
    var totalDives: [String]?
    var sortBy: Int = 2
    var openWater: Int?
    
}
