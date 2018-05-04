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
    
    static func push(on controller: UINavigationController, forDoTrip: Bool, selectedDiver: Int) -> DiveServiceSearchResultController {
        let vc: DiveServiceSearchResultController = DiveServiceSearchResultController(nibName: "DiveServiceSearchResultController", bundle: nil)
        vc.selectedDiver = selectedDiver
        vc.forDoTrip = forDoTrip
        controller.setNavigationBarHidden(false, animated: true)
        controller.navigationBar.barTintColor = UIColor.primary
        controller.pushViewController(vc, animated: true)
        return vc
    }

    fileprivate var forDoTrip: Bool = false
    fileprivate var ecotrip: Int?
    
    fileprivate var diveServices: [NDiveService]?
    fileprivate var selectedKeyword: SearchResult?
    fileprivate var selectedDate: Date?
    fileprivate var selectedDiver: Int?
    fileprivate var selectedLicense: Bool = false
    fileprivate var page: Int = 1
    fileprivate var filter: NFilter = NFilter()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.addInfiniteScroll(handler: self.infiniteScroll)
        self.tableView.register(UINib(nibName: "DiveServiceCell", bundle: nil), forCellReuseIdentifier: "DiveServiceCell")
        self.loadDiveServices()
                        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func filterButtonAction(_ sender: Any) {
        _ = DiveTripFilterController.push(on: self.navigationController!, filter: self.filter, onUpdateFilter: {filter in
                self.page = 1
                self.diveServices = nil
                self.tableView.reloadData()
                self.filter = filter
                self.loadDiveServices()
            })
    }
    
    fileprivate func loadDiveServices() {
        if forDoTrip {
            self.title = "Do Trip"
            self.getAllDoTrip(page: page, selectedDiver: selectedDiver!, filter: filter)
        } else {
            let title = self.selectedDate!.formatDate(dateFormat: "dd MMMM yyyy") + " " + String(self.selectedDiver!) + " pax(s)"
            self.title = title
            self.searchDiveService(selectedKeyword: self.selectedKeyword!, selectedDate: self.selectedDate!, selectedDiver: self.selectedDiver!, selectedLicense: self.selectedLicense, forDoTrip: self.forDoTrip, filter: self.filter, ecotrip: self.ecotrip)
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
                //DEPRECATED
                NHTTPHelper.httpDoTripSearchBy(cityId: keyword.id!, page: String(page), diver: selectedDiver, certificate: selectedLicense.number, date: selectedDate.timeIntervalSince1970, sortBy: sortBy, ecoTrip: ecotrip, totalDives: totalDives, categories: categories, facilities: facilities, priceMin: priceMin, priceMax: priceMax, complete: {response in
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
                //DEPRECATED
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
        if forDoTrip {
            self.getAllDoTrip(page: page, selectedDiver: selectedDiver!, filter: filter)
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
        cell.serviceView.isDoTrip = self.forDoTrip
        cell.serviceView.tag = row
        cell.serviceView.addTarget(self, action: #selector(DiveServiceSearchResultController.onDoTripClicked(at:)))
        cell.serviceView.initData(diveService: self.diveServices![row])
        return cell
    }
    
    @objc func onDoTripClicked(at sender: UIControl) {
        let index = sender.tag
        let diveService = self.diveServices![index]
        self.selectedDate = Date(timeIntervalSince1970: diveService.schedule!.startDate)
        _ = DiveServiceController.push(on: self.navigationController!, forDoTrip: self.forDoTrip, selectedKeyword: self.selectedKeyword!, selectedLicense: diveService.license, selectedDiver: self.selectedDiver!, selectedDate: self.selectedDate!, ecoTrip: self.ecotrip, diveService: diveService)

    }
    
}

class NFilter  {
    var priceMin: Int?
    var priceMax: Int?
    var categories: [String]?
    var facilities: [String]?
    var totalDives: [String]?
    var sortBy: Int = 2
}
