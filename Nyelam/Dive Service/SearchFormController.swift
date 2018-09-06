//
//  SearchFormController.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import SwiftDate
import CoreData
import ActionSheetPicker_3_0
import MBProgressHUD

class SearchFormController: BaseViewController {

    static func push(on controller: UINavigationController, forDoTrip: Bool) -> SearchFormController {
        let vc: SearchFormController = SearchFormController(nibName: "SearchFormController", bundle: nil)
        vc.forDoTrip = forDoTrip
        vc.selectedDate = Date()
        controller.setNavigationBarHidden(false, animated: true)
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    static func push(on controller: UINavigationController, forDoTrip: Bool, serviceId: String, serviceName: String, license: Bool) -> SearchFormController {
        let vc: SearchFormController = SearchFormController(nibName: "SearchFormController", bundle: nil)
        let result = SearchResultService()
        result.id = serviceId
        result.name = serviceName
        result.license = license
        vc.forDoTrip = forDoTrip
        vc.selectedKeyword = result
        vc.selectedDate = Date()
        vc.selectedLicense = license
        controller.setNavigationBarHidden(false, animated: true)
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    static func push(on controller: UINavigationController, forDoTrip: Bool, isEcotrip: Bool) -> SearchFormController {
        let vc: SearchFormController = SearchFormController(nibName: "SearchFormController", bundle: nil)
        vc.isEcoTrip = isEcotrip
        vc.forDoTrip = forDoTrip
        vc.selectedKeyword = SearchResultDiveCenter(json:NConstant.ecotripStatic)
        vc.selectedLicense = true
        controller.setNavigationBarHidden(false, animated: true)
        controller.navigationBar.barTintColor = UIColor.nyGreen
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    static func push(on controller: UINavigationController, forDoCourse: Bool) -> SearchFormController {
        let vc: SearchFormController = SearchFormController(nibName: "SearchFormController", bundle: nil)
        vc.forDoCourse = forDoCourse
        vc.selectedDate = Date()
        controller.setNavigationBarHidden(false, animated: true)
        controller.pushViewController(vc, animated: true)
        return vc
    }

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var isEcoTrip: Bool = false
    var forDoTrip: Bool = false
    var forDoCourse: Bool = false
    var formIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    fileprivate var diveServices: [NDiveService]?
    fileprivate var selectedKeyword: SearchResult?
    fileprivate var selectedDate: Date?
    fileprivate var selectedDiver: Int = 1
    fileprivate var selectedLicense: Bool! = false
    fileprivate var selectedOrganization: NMasterOrganization?
    fileprivate var selectedLicenseType: NLicenseType?
    
    
    override func backButtonAction(_ sender: UIBarButtonItem) {
        if self.isEcoTrip {
            if let navigation = self.navigationController as? BaseNavigationController {
                self.moveSafeAreaInsets()
                navigation.setNavigationBarHidden(true, animated: true)
                navigation.navigationBar.barTintColor = UIColor.primary
            }
        }
        super.backButtonAction(sender)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isEcoTrip {
            self.navigationController?.navigationBar.barTintColor = UIColor.nyGreen
        } else {
            self.navigationController?.navigationBar.barTintColor = UIColor.primary
        }
        self.title = "Search"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "SearchFormCell", bundle: nil), forCellReuseIdentifier: "SearchFormCell")
        self.tableView.register(UINib(nibName: "DiveServiceCell", bundle: nil), forCellReuseIdentifier: "DiveServiceCell")
        self.tableView.register(UINib(nibName: "CourseFormCell", bundle: nil), forCellReuseIdentifier: "CourseFormCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.firstTime {
            self.firstTime = false
            if self.isEcoTrip {
                self.loadingView.isHidden = false
                self.getEcoTripCalendar()
            } else {
                self.getRecommendation()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func onKeywordSelectedHandler() -> (SearchKeywordController, SearchResult?) -> Void {
        return { controller, keyword in
            controller.view.endEditing(true)
            if let navigation = controller.navigationController {
                navigation.popViewController(animated: true, withCompletionBlock: {
                    if let keyword = keyword as? SearchResultService {
                        let searchResultService = keyword as! SearchResultService
                        self.selectedLicense = searchResultService.license
                        self.selectedOrganization = searchResultService.organization
                        self.selectedLicenseType = searchResultService.licenseType
                    }
                    self.selectedKeyword = keyword
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    fileprivate func showDatePicker(forDoCourse: Bool, isEcoTrip: Bool, indexPath: IndexPath) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250, height: 300)
        let pickerView: UIView
        if !isEcoTrip {
            if forDoCourse {
                pickerView = MonthYearPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
            } else {
                let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
                datePicker.datePickerMode = UIDatePickerMode.date
                datePicker.minimumDate = Date()
                pickerView = datePicker
            }
        } else {
            let ecotripPickerView = EcoTripPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
            ecotripPickerView.delegate = self
            ecotripPickerView.dataSource = self
            ecotripPickerView.reloadAllComponents()
            pickerView = ecotripPickerView
        }
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Please choose", message: "", preferredStyle: UIAlertControllerStyle.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
            if let temp: MonthYearPickerView = pickerView as? MonthYearPickerView {
                let month: Int = temp.month
                let year: Int = temp.year
                let cal =  CalendarName.gregorian.calendar
                let pickedDate = cal.date(byAdding: .month, value: month-1, to: Date())!
                let pickedMonth = cal.component(.month, from: pickedDate)
                var comp: DateComponents = DateComponents()
                comp.timeZone = TimeZoneName.asiaJakarta.timeZone
                comp.calendar = CalendarName.gregorian.calendar
                comp.day = 1
                if year == cal.component(.year, from: Date().inLocalRegion().absoluteDate) {
                    comp.month = pickedMonth
                } else {
                    comp.month = month
                }
                comp.year = year
                if pickedMonth == cal.component(.month, from: Date().inLocalRegion().absoluteDate) {
                    comp.day = cal.component(.day, from: Date())
                    comp.minute = cal.component(.minute, from: Date())
                    comp.hour = cal.component(.hour, from: Date())
                    comp.second = cal.component(.second, from: Date())
                } else {
                    comp.minute = 0
                    comp.hour = 0
                    comp.second = 0
                }
                let date = DateInRegion(components: comp)!
                self.selectedDate = date.absoluteDate
            } else if let temp: UIDatePicker = pickerView as? UIDatePicker {
                let cal = CalendarName.gregorian.calendar
                var comp: DateComponents = DateComponents()
                comp.timeZone = TimeZoneName.asiaJakarta.timeZone
                comp.calendar = CalendarName.gregorian.calendar
                comp.day = cal.component(.day, from: temp.date)
                comp.month = cal.component(.month, from: temp.date)
                comp.year = cal.component(.year, from: temp.date)
                if temp.date.isToday {
                    comp.minute = cal.component(.minute, from: temp.date)
                    comp.hour = cal.component(.hour, from: temp.date)
                    comp.second = cal.component(.second, from: temp.date)
                } else {
                    comp.minute = 0
                    comp.hour = 0
                    comp.second = 0
                }
                let date = DateInRegion(components: comp)!
                self.selectedDate = date.absoluteDate
            } else if let temp = pickerView as? EcoTripPickerView {
                let row = temp.selectedRow(inComponent: 0)
                let selectedDate = temp.dates![row]
                let cal = CalendarName.gregorian.calendar
                var comp: DateComponents = DateComponents()
                comp.timeZone = TimeZoneName.asiaJakarta.timeZone
                comp.calendar = CalendarName.gregorian.calendar
                comp.day = cal.component(.day, from: selectedDate)
                comp.month = cal.component(.month, from: selectedDate)
                comp.year = cal.component(.year, from: selectedDate)
                if selectedDate.isToday {
                    comp.minute = cal.component(.minute, from: selectedDate)
                    comp.hour = cal.component(.hour, from: selectedDate)
                    comp.second = cal.component(.second, from: selectedDate)
                } else {
                    comp.minute = 0
                    comp.hour = 0
                    comp.second = 0
                }
                let date = DateInRegion(components: comp)!
                self.selectedDate = date.absoluteDate
            } else {
                self.selectedDate = nil
            }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    
    func getEcoTripCalendar() {
        NHTTPHelper.httpGetEcoTripCalendar(complete: {response in
            self.loadingView.isHidden = true
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.getEcoTripCalendar()
                    })
                } else if error.isKind(of: StatusFailedError.self) {
                    //TODO
                }
            }
            if let data = response.data, !data.isEmpty {
                var dates: [Date] = []
                var i = 0
                for timestamp in data {
                    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
                    if i == 0 {
                        self.selectedDate = date
                    }
                    dates.append(date)
                    i+=1
                }
                NHelper.ecoTripDates = dates
                self.tableView.reloadData()
                self.getRecommendation()
            }
        })
    }
}

extension SearchFormController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let diveServices = self.diveServices, !diveServices.isEmpty {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isEcoTrip {
            if NHelper.ecoTripDates == nil || NHelper.ecoTripDates!.isEmpty {
                return 0
            }
        }
        if section == 0 {
            return 1
        } else {
            if let diveServices = self.diveServices, !diveServices.isEmpty {
                return diveServices.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if self.forDoCourse {
                let cell: CourseFormCell = tableView.dequeueReusableCell(withIdentifier: "CourseFormCell", for: indexPath) as! CourseFormCell
                cell.onKeywordHandler = { keyword in
                    if !self.isEcoTrip {
                        let _ = SearchKeywordController.push(on: self.navigationController!, type: 3, with: self.onKeywordSelectedHandler())
                    }
                }
//                if let _ = self.selectedKeyword as? SearchResultService {
//                    cell.organizationButton.isUserInteractionEnabled = false
//                    cell.licenseTypeButton.isUserInteractionEnabled = false
//                } else {
//                    cell.organizationButton.isUserInteractionEnabled = true
//                    cell.licenseTypeButton.isUserInteractionEnabled = true
//                }

                cell.onDateHandler = { string in
                    self.showDatePicker(forDoCourse: self.forDoCourse, isEcoTrip: self.isEcoTrip, indexPath: indexPath)
                }
                cell.onOrganizationHandler = { string in
                    self.onShowMasterOrganization()
                }
                cell.onLicenseTypeHandler = { string in
                    if let selectedOrganization = self.selectedOrganization {
                        let organizaitonId = selectedOrganization.id!
                        self.onShowLicenseType(organizaitonId: organizaitonId)
                    }
                }
                cell.initData(selectedKeyword: self.selectedKeyword, organization: self.selectedOrganization, licenseType: self.selectedLicenseType, selectedDate: self.selectedDate)
                cell.onGetCertifiedHandler = {cell in

                    if let error = self.validateError(forDoCourse: self.forDoCourse) {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {})
                        return
                    }
                    
                    if let keyword = self.selectedKeyword as? SearchResultService {
                        _ = DiveServiceController.push(on: self.navigationController!, forDoCourse: self.forDoCourse, selectedKeyword: keyword, selectedDiver: self.selectedDiver, selectedDate: self.selectedDate!, diveService: nil, selectedOrganization: self.selectedOrganization!, selectedLicenseType: self.selectedLicenseType!)
                    } else {
                        _ = DiveServiceSearchResultController.push(on: self.navigationController!, forDoCourse: self.forDoCourse, selectedDiver: self.selectedDiver, selectedDate: self.selectedDate!, selectedKeyword: self.selectedKeyword!, selectedOrganization: self.selectedOrganization!, selectedLicenseType: self.selectedLicenseType!)
                    }
                }
                return cell
            } else {
                let cell: SearchFormCell = tableView.dequeueReusableCell(withIdentifier: "SearchFormCell", for: indexPath) as! SearchFormCell
                if self.isEcoTrip {
                    cell.setEcoTripData()
                    cell.diveNowButton.backgroundColor = UIColor.nyGreen
                } else {
                    cell.diveNowButton.backgroundColor = UIColor.orange
                }
                cell.onKeywordHandler = { keyword in
                    if !self.isEcoTrip {
                        let _ = SearchKeywordController.push(on: self.navigationController!, with: self.onKeywordSelectedHandler())
                    }
                }
                cell.onDateHandler = { string in
                    self.showDatePicker(forDoCourse: self.forDoCourse, isEcoTrip: self.isEcoTrip, indexPath: indexPath)
                }
                cell.onDiverHandler = {
                    let vc = UIViewController()
                    vc.preferredContentSize = CGSize(width: 250, height: 300)
                    let pickerView: UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
                    pickerView.delegate = self
                    pickerView.dataSource = self
                    pickerView.reloadAllComponents()
                    vc.view.addSubview(pickerView)
                    let editRadiusAlert = UIAlertController(title: "Please choose", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    editRadiusAlert.setValue(vc, forKey: "contentViewController")
                    editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
                        self.selectedDiver = pickerView.selectedRow(inComponent: 0) + 1
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }))
                    editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(editRadiusAlert, animated: true)
                }
                cell.onNeedLicenseHandler = { isOn, c in
                    self.selectedLicense = isOn
                    if isOn {
                        cell.needLicenseLabel.text = "Yes"
                    } else {
                        c.needLicenseLabel.text = "No"
                    }
                }
                cell.onDiveNowHandler = { cell in
                    if let error = self.validateError() {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {})
                        return
                    }
                    var ecoTrip: Int? = nil
                    if self.isEcoTrip {
                        ecoTrip = 1
                    }
                    
                    if let keyword = self.selectedKeyword as? SearchResultService {
                        _ = DiveServiceController.push(on: self.navigationController!, forDoTrip: self.forDoTrip, selectedKeyword: keyword, selectedLicense: self.selectedLicense!, selectedDiver: self.selectedDiver, selectedDate: self.selectedDate!, ecoTrip: ecoTrip)
                    } else {
                        _ = DiveServiceSearchResultController.push(on: self.navigationController!, forDoTrip: self.forDoTrip, selectedKeyword: self.selectedKeyword!, selectedLicense: self.selectedLicense, selectedDiver: self.selectedDiver, selectedDate: self.selectedDate!, ecoTrip: ecoTrip)
                    }
                }
                cell.keywordLabel.text = self.selectedKeyword != nil ? self.selectedKeyword!.name : "Province, Area, Spot, Dive Center"
                cell.selectedDateLabel.text = self.selectedDate != nil ? SearchFormCell.string(from: self.selectedDate!, forDoTrip: self.forDoTrip) : "Day, Month, Year"
                cell.needLicense.isOn = self.selectedLicense
                if let _ = self.selectedKeyword as? SearchResultService {
                    cell.needLicense.isUserInteractionEnabled = false
                } else {
                    cell.needLicense.isUserInteractionEnabled = true
                }
                if cell.needLicense.isOn {
                    cell.needLicenseLabel.text = "Yes"
                } else {
                    cell.needLicenseLabel.text = "No"
                }
                return cell
            }
        } else {
            let row = indexPath.row
            let cell: DiveServiceCell = tableView.dequeueReusableCell(withIdentifier: "DiveServiceCell", for: indexPath) as! DiveServiceCell
            cell.serviceView.control.tag = row
            cell.serviceView.addTarget(self, action: #selector(SearchFormController.onDiveServiceClicked(at:)))
            cell.serviceView.isDoTrip = self.forDoTrip
            cell.serviceView.isDoCourse = self.forDoCourse
            cell.serviceView.initData(diveService: self.diveServices![row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
//            header.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
            header.backgroundColor = UIColor.nyGray
            let label: UILabel = UILabel(frame: CGRect(x: 16, y: 16, width: tableView.frame.width - 32, height: 40 - 16))
            if self.forDoCourse {
                label.text = "Our Recommended Course(s)"
            } else {
                label.text = "Our Recommended Service(s)"
            }
            label.textColor = UIColor(white: 0.3, alpha: 1)
            label.font = UIFont(name: "FiraSans-Regular", size: 15)
            header.addSubview(label)
            return header
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40.0
        } else {
            return 0
        }
    }
    
    internal func getRecommendation() {
        if self.forDoTrip {
//            NHTTPHelper.httpDoTripSuggestion(complete: {response in
//                if let error = response.error {
//                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
//                        if error.isKind(of: NotConnectedInternetError.self) {
//                            NHelper.handleConnectionError(completion: {
//                                self.getRecommendation()
//                            })
//                        }
//                    })
//                    return
//                }
//                if let data = response.data, !data.isEmpty {
//                    self.diveServices = data
//                    self.tableView.reloadData()
//                }
//            })
        } else if self.forDoCourse {
            NHTTPHelper.httpDoCourseSuggestion(complete: {response in
                if let error = response.error {
                    UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                        if error.isKind(of: NotConnectedInternetError.self) {
                            NHelper.handleConnectionError(completion: {
                                self.getRecommendation()
                            })
                        }
                    })
                    return
                }
                if let data = response.data, !data.isEmpty {
                    self.diveServices = data
                    self.tableView.reloadData()
                }
                NSManagedObjectContext.saveData()
            })
        } else {
            if !self.isEcoTrip {
                NHTTPHelper.httpDoDiveSuggestion(complete: {response in
                    if let error = response.error {
                        UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                            if error.isKind(of: NotConnectedInternetError.self) {
                                NHelper.handleConnectionError(completion: {
                                    self.getRecommendation()
                                })
                            }
                        })
                        return
                    }
                    if let data = response.data, !data.isEmpty {
                        self.diveServices = data
                        self.tableView.reloadData()
                    }
                    NSManagedObjectContext.saveData()
                })
            }
        }
    }
    internal func onShowMasterOrganization() {
        if let organizations = NMasterOrganization.getOrganizations(), !organizations.isEmpty {
            var c: [String] = []
            for organization in organizations {
                c.append(organization.name!)
            }
            let actionSheet = ActionSheetStringPicker.init(title: "Association", rows: c, initialSelection: self.selectedOrganization != nil ? NMasterOrganization.getPosition(by: self.selectedOrganization!.id!) : 0, doneBlock: {picker, index, value in
                self.selectedOrganization = organizations[index]
                self.selectedLicenseType = nil
                self.tableView.reloadData()
            }, cancel: {_ in return
            }, origin: self.view)
            actionSheet!.show()
        }
    }
    
    internal func onShowLicenseType(organizaitonId: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpGetLicenseType(organizationId: organizaitonId, complete: {response in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.onShowLicenseType(organizaitonId: organizaitonId)
                    })
                }
                return
            }
            if let licenseTypes = response.data, !licenseTypes.isEmpty {
                var c: [String] = []
                for licenseType in licenseTypes {
                    c.append(licenseType.name!)
                }
                let actionSheet = ActionSheetStringPicker.init(title: "License Type", rows: c, initialSelection: 0, doneBlock: {picker, index, value in
                    self.selectedLicenseType = licenseTypes[index]
                    self.tableView.reloadData()
                }, cancel: {_ in return
                }, origin: self.view)
                actionSheet!.show()
            } else {
                UIAlertController.handleErrorMessage(viewController: self, error: "License not found!", completion: {})
            }
        })
    }
    
    internal func validateError(forDoCourse: Bool = false) -> String? {
        if self.selectedKeyword == nil {
            return "Please search keyword first!"
        }
        if self.selectedDate == nil {
            return "Please pick date!"
        }
        if self.selectedDiver == nil {
            return "Please pick diver!"
        }
        if forDoCourse {
            if self.selectedOrganization == nil {
                return "Please pick association!"
            }
            if self.selectedLicenseType == nil {
                return "Please pick license type!"
            }
        }
        return nil
    }
}

extension SearchFormController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isKind(of: EcoTripPickerView.self) {
            let ecotripPickerView = pickerView as! EcoTripPickerView
            return (ecotripPickerView.dates?.count)!
        }
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isKind(of: EcoTripPickerView.self) {
            let ecotripPickerView = pickerView as! EcoTripPickerView
            return ecotripPickerView.convertToString(in: row)
        }
        return "\((row + 1))"
    }

    @objc func onDiveServiceClicked(at sender: UIControl) {
        let index: Int = sender.tag
        let diveservice = self.diveServices![index]
        let keyword = SearchResultService()
        
        keyword.type = 4
        keyword.id = diveservice.id
        keyword.name = diveservice.name
        keyword.rating = diveservice.rating
        
        self.selectedKeyword = keyword
        if self.forDoCourse {
            self.selectedDate = Date(timeIntervalSince1970: diveservice.schedule!.startDate)
            self.selectedLicenseType = diveservice.licenseType
            self.selectedOrganization = diveservice.organization
            var ecoTrip: Int? = nil
            if self.isEcoTrip {
                ecoTrip = 1
            }
            _ = DiveServiceController.push(on: self.navigationController!, forDoCourse: self.forDoCourse, selectedKeyword: keyword, selectedDiver: self.selectedDiver, selectedDate: self.selectedDate!, diveService: nil, selectedOrganization: self.selectedOrganization!, selectedLicenseType: self.selectedLicenseType!)
            return
        } else {
            self.selectedLicense = diveservice.license
        }
        
        if let indexPaths = self.tableView.indexPathsForVisibleRows {
            var visible = false
            for indexPath in indexPaths {
                if indexPath.row == 0 && indexPath.section == 0 {
                    visible = true
                    break
                }
            }
            if visible {
                self.tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
            } else {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
            }
        }
//        if index == 0 {
//            self.tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
//        } else {
//            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
//        }
    }

    
}

class SearchFormCell: NTableViewCell {
    @IBOutlet weak var keywordBt: UIControl!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var dateBt: UIControl!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var diverBt: UIControl!
    @IBOutlet weak var selectedDiverLabel: UILabel!
    @IBOutlet weak var needLicense: UISwitch!
    @IBOutlet weak var diveNowButton: UIButton!
    
    @IBOutlet weak var needLicenseLabel: UILabel!
    static func string(from date: Date, forDoTrip: Bool) -> String {
        let format: DateFormatter = DateFormatter()
        format.timeZone = TimeZoneName.asiaJakarta.timeZone
        if forDoTrip {
            format.dateFormat = "MMM yyyy"
        } else {
            format.dateFormat = "dd MMM yyyy"
        }
        format.locale = Locale(identifier: "us")
        return format.string(from: date)
    }
    
    static func date(from string: String?, forDoTrip: Bool) -> Date? {
        if string == nil {
            return nil
        }
        
        let format: DateFormatter = DateFormatter()
        format.timeZone = TimeZoneName.asiaJakarta.timeZone
        if forDoTrip {
            format.dateFormat = "MMM yyyy"
        } else {
            format.dateFormat = "dd MMM yyyy"
        }
        format.locale = Locale(identifier: "us")
        return format.date(from: string!)
    }
    
    @IBAction func onDiveNowClicked(_ sender: UIControl) {
        self.onDiveNowHandler(self)
    }
    
    @IBAction func onClicked(_ sender: UIControl) {
        if sender == self.keywordBt {
            self.onKeywordHandler(self.keywordLabel.text)
        } else if sender == self.dateBt {
            self.onDateHandler(self.selectedDateLabel.text)
        } else if sender == self.diverBt {
            self.onDiverHandler()
        }
    }
    
    @IBAction func onSwitch(_ sender: UISwitch) {
        self.onNeedLicenseHandler(self.needLicense.isOn, self)
    }
    
    func setEcoTripData() {
        self.keywordLabel.text = "Save Our Small Island"
        self.keywordBt.isUserInteractionEnabled = false
        self.needLicense.isOn = true
        self.needLicense.isUserInteractionEnabled = false
    }
    var onKeywordHandler: (String?) -> Void = { keyword in }
    var onDateHandler: (String?) -> Void = { date in }
    var onDiverHandler: () -> Void = { }
    var onNeedLicenseHandler: (Bool, SearchFormCell) -> Void = { isOn, cell in }
    var onDiveNowHandler: (SearchFormCell) -> Void = { cell in }
}

class CourseFormCell: NTableViewCell {
    
    @IBOutlet weak var associationLabel: UILabel!
    @IBOutlet weak var licenseTypeLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var organizationButton: UIControl!
    @IBOutlet weak var licenseTypeButton: UIControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func onClicked(_ sender: Any) {
        if let sender = sender as? UIView {
            if sender.tag == 0 {
                self.onKeywordHandler(self.keywordLabel.text)
            } else if sender.tag == 1 {
                self.onOrganizationHandler(self.associationLabel.text)
            } else if sender.tag == 2 {
                self.onLicenseTypeHandler(self.licenseTypeLabel.text)
            } else if sender.tag == 3 {
                self.onDateHandler(self.scheduleLabel.text)
            } else if sender.tag == 4 {
                self.onGetCertifiedHandler(self)
            }
        }
    }
 
    func initData(selectedKeyword: SearchResult?, organization: NMasterOrganization?, licenseType: NLicenseType?, selectedDate: Date?) {
        if let keyword = selectedKeyword {
            self.keywordLabel.text = keyword.name
        }
        if let organization = organization {
            self.associationLabel.text = organization.name
        } else {
            self.associationLabel.text = "CMAS, NAUI, PADI, RAID, SSI"
        }
        if let licenseType = licenseType {
            self.licenseTypeLabel.text = licenseType.name
        } else {
            self.licenseTypeLabel.text = "OW, AOW, Rescue, etc"
        }
        if let selectedDate = selectedDate {
            self.scheduleLabel.text = selectedDate.formatDate(dateFormat: "MMM yyyy")
        }
    }
    var onKeywordHandler: (String?) -> Void = { keyword in }
    var onDateHandler: (String?) -> Void = { date in }
    var onOrganizationHandler: (String?) -> Void = {organization in }
    var onLicenseTypeHandler: (String?) -> Void = {licenseType in }
    var onGetCertifiedHandler: (CourseFormCell) -> Void = { cell in }

}

