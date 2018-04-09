//
//  DTMDatePickerController.swift
//  Metro TV News
//
//  Created by Ramdhany Dwi Nugroho on 10/28/16.
//
//

import UIKit

enum DTMDatePickerStyle {
    case Date
    case Year
}

class DTMDatePickerController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }

    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var yearPicker: UIPickerView!
    
    var onDatePickedHandler: (DTMDatePickerController, Date) -> Void = {controller, date in}
    var onDatePickerCancel: (DTMDatePickerController) -> Void = {controller in}
    var gyDatePickerStyle: DTMDatePickerStyle! = DTMDatePickerStyle.Date
    var defaultDate: Date = Date()
    private var years: [String]!
    private let formatter: DateFormatter = DateFormatter()
    private var selectedYear: Date!
    private var firstRun: Bool = true
    private var selectedRowForYear: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugPrint("view did load defaultDate = \(self.defaultDate)")
        
        formatter.dateFormat = "yyyy"
        var dateComp: DateComponents = Calendar.current.dateComponents([Calendar.Component.year], from: Date())
        
        let defaultDateComp: DateComponents = Calendar.current.dateComponents([Calendar.Component.year], from: defaultDate)

        let thisYear: Int = dateComp.year!
        
        self.selectedYear = defaultDate as Date!
        
        self.years = []
        dateComp.year = 1970
        var index: Int = 0
        
        for _ in 1970..<thisYear {
            if dateComp.year == defaultDateComp.year {
                selectedRowForYear = index
            }
            self.years.append(formatter.string(from: Calendar.current.date(from: dateComp)!))
            dateComp.year = dateComp.year! + 1
            index = index + 1
        }
        debugPrint("view did load selectedRowForYear = \(selectedRowForYear)")
        if self.gyDatePickerStyle == DTMDatePickerStyle.Year {
            self.datePicker.isHidden = true
            self.yearPicker.isHidden = false
        } else {
            self.datePicker.isHidden = false
            self.yearPicker.isHidden = true
        }
        
        self.datePicker.date = self.defaultDate as Date
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.firstRun == true {
            debugPrint("view did appear selectedRowForYear = \(selectedRowForYear)")
            self.firstRun = false
     //       self.yearPicker.selectRow(self.selectedRowForYear, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {
            self.onDatePickerCancel(self)
        })
    }
    
    @IBAction func onDone(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {
            self.onDatePickedHandler(self, self.gyDatePickerStyle == DTMDatePickerStyle.Year ? self.selectedYear : self.datePicker.date)
        })
    }
    
    // MARK: UIPickerViewDataSource, UIPickerViewDelegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.years[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        debugPrint("select row = \(row)")
        let yearString: String = self.years[row]
        self.selectedYear = (formatter.date(from: yearString)!)
    }
}
