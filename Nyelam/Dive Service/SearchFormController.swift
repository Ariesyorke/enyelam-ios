//
//  SearchFormController.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import SwiftDate

class SearchFormController: BaseViewController {

    static func push(on controller: UINavigationController, forDoTrip: Bool) -> SearchFormController {
        let vc: SearchFormController = SearchFormController(nibName: "SearchFormController", bundle: nil)
        vc.forDoTrip = forDoTrip
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    static func push(on controller: UINavigationController, forDoTrip: Bool, isEcotrip: Bool) -> SearchFormController {
        let vc: SearchFormController = SearchFormController(nibName: "SearchFormController", bundle: nil)
        vc.isEcoTrip = isEcotrip
        vc.forDoTrip = forDoTrip
        vc.selectedKeyword = SearchResult(json:NConstant.ecotripStatic)
        vc.selectedLicense = true
        controller.navigationBar.barTintColor = UIColor.nyGreen
        controller.pushViewController(vc, animated: true)
        return vc
    }

    @IBOutlet weak var tableView: UITableView!
    var isEcoTrip: Bool = false
    var forDoTrip: Bool = false
    fileprivate var diveServices: [NDiveService]?
    fileprivate var selectedKeyword: SearchResult?
    fileprivate var selectedDate: Date?
    fileprivate var selectedDiver: Int?
    fileprivate var selectedLicense: Bool! = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "SearchFormCell", bundle: nil), forCellReuseIdentifier: "SearchFormCell")
        self.tableView.register(UINib(nibName: "DiveServiceCell", bundle: nil), forCellReuseIdentifier: "DiveServiceCell")
        self.getRecommendation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func onKeywordSelectedHandler() -> (SearchKeywordController, SearchResult?) -> Void {
        return { controller, keyword in
            self.selectedKeyword = keyword
            self.tableView.reloadData()
        }
    }
    
    fileprivate func showDatePicker(forDoTrip: Bool, isEcoTrip: Bool, indexPath: IndexPath) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250, height: 300)
        let pickerView: UIView
        if !isEcoTrip {
            if forDoTrip {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: SearchFormCell = tableView.dequeueReusableCell(withIdentifier: "SearchFormCell", for: indexPath) as! SearchFormCell
            if self.isEcoTrip {
                cell.setEcoTripData()
                cell.diveNowButton.backgroundColor = UIColor.nyGreen
            } else {
                cell.diveNowButton.backgroundColor = UIColor.orange
            }
            cell.onKeywordHandler = { keyword in
                let _ = SearchKeywordController.push(on: self.navigationController!, with: self.onKeywordSelectedHandler())
            }
            cell.onDateHandler = { string in
                self.showDatePicker(forDoTrip: self.forDoTrip, isEcoTrip: self.isEcoTrip, indexPath: indexPath)
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
            cell.onNeedLicenseHandler = { isOn in
                self.selectedLicense = isOn
            }
            cell.onDiveNowHandler = { cell in
//                self.selectedKeyword
//                self.selectedDates
//                self.selectedDiver
//                self.selectedLicense
            }
            cell.keywordLabel.text = self.selectedKeyword != nil ? self.selectedKeyword!.name : "Province, Area, Spot, Dive Center"
            cell.selectedDateLabel.text = self.selectedDate != nil ? SearchFormCell.string(from: self.selectedDate!, forDoTrip: self.forDoTrip) : "Day, Month, Year"
            cell.selectedDiverLabel.text = self.selectedDiver != nil ? String(format: "%d Diver(s)", arguments: [self.selectedDiver!]) : "0 Diver(s)"
            cell.needLicense.isOn = self.selectedLicense
            return cell
        } else {
            let row = indexPath.row
            let cell: DiveServiceCell = tableView.dequeueReusableCell(withIdentifier: "DiveServiceCell", for: indexPath) as! DiveServiceCell
            cell.serviceView.isDoTrip = self.forDoTrip
            cell.serviceView.initData(diveService: self.diveServices![row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            header.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
            
            let label: UILabel = UILabel(frame: CGRect(x: 16, y: 8, width: tableView.frame.width - 32, height: 40 - 16))
            label.text = "Our Recommended Services"
            label.textColor = UIColor(white: 0.3, alpha: 1)
            label.font = UIFont.systemFont(ofSize: 20)
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
        if forDoTrip {
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
        } else {
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
            })
        }
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
    
}

class SearchFormCell: UITableViewCell {
    @IBOutlet weak var keywordBt: UIControl!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var dateBt: UIControl!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var diverBt: UIControl!
    @IBOutlet weak var selectedDiverLabel: UILabel!
    @IBOutlet weak var needLicense: UISwitch!
    @IBOutlet weak var diveNowButton: UIButton!
    
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
        self.onNeedLicenseHandler(self.needLicense.isOn)
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
    var onNeedLicenseHandler: (Bool) -> Void = { isOn in }
    var onDiveNowHandler: (SearchFormCell) -> Void = { cell in }
}
