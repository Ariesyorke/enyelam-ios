//
//  SearchFormController.swift
//  Nyelam
//
//  Created by Ramdhany Dwi Nugroho on 4/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class SearchFormController: BaseViewController {
    
    static func push(on controller: UINavigationController) -> SearchFormController {
        let vc: SearchFormController = SearchFormController(nibName: "SearchFormController", bundle: nil)
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "SearchFormCell", bundle: nil), forCellReuseIdentifier: "SearchFormCell")
        self.tableView.register(UINib(nibName: "DiveServiceCell", bundle: nil), forCellReuseIdentifier: "DiveServiceCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                
            }
            cell.onDateHandler = { date in
                
            }
            cell.onDiverHandler = {
                
            }
            cell.onDiveNowHandler = { cell in
                
            }
            return cell
        } else {
            let cell: DiveServiceCell = tableView.dequeueReusableCell(withIdentifier: "DiveServiceCell", for: indexPath) as! DiveServiceCell
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 1 {
//            return "Our Recommended Services"
//        } else {
//            return nil
//        }
//    }
    
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

class SearchFormCell: UITableViewCell {
    @IBOutlet weak var keywordBt: UIControl!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var dateBt: UIControl!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var diverBt: UIControl!
    @IBOutlet weak var selectedDiverLabel: UILabel!
    @IBOutlet weak var needLicense: UISwitch!
    
    static func string(from date: Date) -> String {
        let format: DateFormatter = DateFormatter()
        format.dateFormat = "dd MMM yyyy"
        format.locale = Locale(identifier: "us")
        return format.string(from: date)
    }
    
    static func date(from string: String?) -> Date? {
        if string == nil {
            return nil
        }
        
        let format: DateFormatter = DateFormatter()
        format.dateFormat = "dd MMM yyyy"
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
            self.onDateHandler(SearchFormCell.date(from: self.selectedDateLabel.text))
        } else if sender == self.diverBt {
            self.onDiverHandler()
        }
    }
    
    var onKeywordHandler: (String?) -> Void = { keyword in }
    var onDateHandler: (Date?) -> Void = { date in }
    var onDiverHandler: () -> Void = { }
    var onDiveNowHandler: (SearchFormCell) -> Void = { cell in }
}
