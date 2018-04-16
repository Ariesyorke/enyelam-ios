//
//  SearchFormController.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class SearchFormController: BaseViewController {
    
    static func push(on controller: UINavigationController, forDoTrip: Bool) -> SearchFormController {
        let vc: SearchFormController = SearchFormController(nibName: "SearchFormController", bundle: nil)
        vc.forDoTrip = forDoTrip
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    var forDoTrip: Bool = false
    fileprivate var selectedKeyword: SearchResult?
    fileprivate var selectedDate: Date?
    fileprivate var selectedDiver: Int?
    fileprivate var selectedLicense: Bool! = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "SearchFormCell", bundle: nil), forCellReuseIdentifier: "SearchFormCell")
        self.tableView.register(UINib(nibName: "DiveServiceCell", bundle: nil), forCellReuseIdentifier: "DiveServiceCell")
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
    
    fileprivate func showDatePicker(forDoTrip: Bool) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250, height: 300)
        let pickerView: UIView
        if forDoTrip {
            pickerView = MonthYearPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        } else {
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
            datePicker.datePickerMode = UIDatePickerMode.date
            datePicker.minimumDate = Date()
            
            pickerView = datePicker
        }
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Please choose", message: "", preferredStyle: UIAlertControllerStyle.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
            if let temp: MonthYearPickerView = pickerView as? MonthYearPickerView {
                let month: Int = temp.month
                let year: Int = temp.year
                
                var comp: DateComponents = DateComponents()
                comp.setValue(month, for: Calendar.Component.month)
                comp.setValue(year, for: Calendar.Component.year)
                comp.setValue(1, for: Calendar.Component.day)
                self.selectedDate = comp.date
            } else if let temp: UIDatePicker = pickerView as? UIDatePicker {
                self.selectedDate = temp.date
            } else {
                self.selectedDate = nil
            }
            self.tableView.reloadData()
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
}

extension SearchFormController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: SearchFormCell = tableView.dequeueReusableCell(withIdentifier: "SearchFormCell", for: indexPath) as! SearchFormCell
            cell.onKeywordHandler = { keyword in
                let _ = SearchKeywordController.push(on: self.navigationController!, with: self.onKeywordSelectedHandler())
            }
            cell.onDateHandler = { string in
                self.showDatePicker(forDoTrip: self.forDoTrip)
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
                    self.tableView.reloadData()
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
            let cell: DiveServiceCell = tableView.dequeueReusableCell(withIdentifier: "DiveServiceCell", for: indexPath) as! DiveServiceCell
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
}

extension SearchFormController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
    
    static func string(from date: Date, forDoTrip: Bool) -> String {
        let format: DateFormatter = DateFormatter()
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
    
    var onKeywordHandler: (String?) -> Void = { keyword in }
    var onDateHandler: (String?) -> Void = { date in }
    var onDiverHandler: () -> Void = { }
    var onNeedLicenseHandler: (Bool) -> Void = { isOn in }
    var onDiveNowHandler: (SearchFormCell) -> Void = { cell in }
}
