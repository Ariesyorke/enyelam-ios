//
//  DiveTripFilterController.swift
//  Nyelam
//
//  Created by Bobi on 4/24/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import DLRadioButton
import CoreData
import RangeSeekSlider
import TangramKit
import UINavigationControllerWithCompletionBlock

class DiveTripFilterController: BaseViewController {
    private let sectionTitles = ["Sort by", "Price Range", "Total Dive(s)", "Category", "Facilities"]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    var onUpdateFilter: (NFilter) -> () = {filter in}
    static func push(on controller: UINavigationController, filter: NFilter, onUpdateFilter: @escaping (NFilter)->()) -> DiveTripFilterController {
        let vc: DiveTripFilterController = DiveTripFilterController(nibName: "DiveTripFilterController", bundle: nil)
        vc.filter = filter
        vc.onUpdateFilter = onUpdateFilter
        controller.pushViewController(vc, animated: true)
        return vc
    }

    var filter: NFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearButton.layer.borderColor = UIColor.blueActive.cgColor
        self.clearButton.layer.borderWidth = 1
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_circle_close_white"), style: .plain, target: self, action: #selector(backButtonAction(_:)))

        self.title = "Filter"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SortByCell", bundle: nil), forCellReuseIdentifier: "SortByCell")
        self.tableView.register(UINib(nibName: "PriceRangeCell", bundle: nil), forCellReuseIdentifier: "PriceRangeCell")
        self.tableView.register(UINib(nibName: "TotalDivesCell", bundle: nil), forCellReuseIdentifier: "TotalDivesCell")
        self.tableView.register(UINib(nibName: "TripCategoryCell", bundle: nil), forCellReuseIdentifier: "TripCategoryCell")
        self.tableView.register(UINib(nibName: "FacilityCell", bundle: nil), forCellReuseIdentifier: "FacilityCell")
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        self.filter = NFilter()
        self.tableView.reloadData()
    }
    
    @IBAction func applyButtonAction(_ sender: Any) {
        if let navigation = self.navigationController {
            navigation.popViewController(animated: true, withCompletionBlock: {
                self.onUpdateFilter(self.filter!)
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
extension DiveTripFilterController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        header.backgroundColor = UIColor.lightGray
        let label: UILabel = UILabel(frame: CGRect(x: 16, y: 2, width: tableView.frame.width - 32, height: 40 - 16))
        label.text = sectionTitles[section]
        label.textColor = UIColor.black
        label.font = UIFont(name: "FiraSans-Regular", size: 14)
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell: SortByCell = tableView.dequeueReusableCell(withIdentifier: "SortByCell", for: indexPath) as! SortByCell
            cell.sortType = filter!.sortBy
            cell.onChangeSort = {sortType in
                self.filter!.sortBy = sortType
            }
            cell.initSort()
            return cell
        } else if section == 1 {
            let cell: PriceRangeCell = tableView.dequeueReusableCell(withIdentifier: "PriceRangeCell", for: indexPath) as! PriceRangeCell
            cell.priceMin = self.filter!.priceMin
            cell.priceMax = self.filter!.priceMax
            cell.onChangePrice = {priceMin, priceMax in
                self.filter!.priceMin = priceMin
                self.filter!.priceMax = priceMax
            }
            return cell
        } else if section == 2 {
            let cell: TotalDivesCell = tableView.dequeueReusableCell(withIdentifier: "TotalDivesCell", for: indexPath) as! TotalDivesCell
            cell.total = self.filter!.totalDives
            cell.initTotal()
            cell.onChangeTotalDives = {totalDives in
                self.filter!.totalDives = totalDives
            }
            return cell
        } else if section == 3 {
            let cell: TripCategoryCell = tableView.dequeueReusableCell(withIdentifier: "TripCategoryCell", for: indexPath) as! TripCategoryCell
            cell.selectedCategories = filter!.categories
            cell.initView()
            cell.reloadData = {categories in
                self.filter!.categories = categories
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            return cell
        } else if section == 4 {
            let cell: FacilityCell = tableView.dequeueReusableCell(withIdentifier: "FacilityCell", for: indexPath) as! FacilityCell
            cell.selectedFacilities = filter!.facilities
            cell.initView()
            cell.reloadData = {facilities in
                self.filter!.facilities = facilities
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
}

class SortByCell: NTableViewCell {

    @IBOutlet var priceSort: DLRadioButton!
    var sortType: Int = 2
    var onChangeSort: (Int) -> () = {sortType in }
    
    @IBAction func priceSortButtonAction(_ sender: DLRadioButton) {
        self.sortType = sender.selected()!.tag
        self.onChangeSort(self.sortType)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.priceSort.titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 15)
        for otherButton in self.priceSort.otherButtons {
            otherButton.titleLabel?.font =  UIFont(name: "FiraSans-Regular", size: 15)
        }
        // Initialization code
    }
    
    fileprivate func initSort() {
        if sortType == 2 {
            self.priceSort.isSelected = true
        } else {
            for otherButton in self.priceSort.otherButtons {
                otherButton.isSelected = true
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class PriceRangeCell: NTableViewCell, RangeSeekSliderDelegate {
    @IBOutlet weak var priceRangeSlider: RangeSeekSlider!
    var priceMin: Int?
    var priceMax: Int?
    var forDoTrip: Bool = false
    var onChangePrice: (Int, Int) -> () = {minPrice, maxPrice in }
    override func awakeFromNib() {
        super.awakeFromNib()
        if self.forDoTrip {
            let price = PriceRangeManager.shared.doTripPriceRange
            self.priceRangeSlider.maxValue = CGFloat(price.highestPrice)
            self.priceRangeSlider.minValue = CGFloat(price.lowestPrice)
            self.priceRangeSlider.selectedMaxValue = CGFloat(price.highestPrice)
            self.priceRangeSlider.selectedMinValue = CGFloat(price.lowestPrice)
        } else {
            let price = PriceRangeManager.shared.doDivePriceRange
            self.priceRangeSlider.maxValue = CGFloat(price.highestPrice)
            self.priceRangeSlider.minValue = CGFloat(price.lowestPrice)
            self.priceRangeSlider.selectedMaxValue = CGFloat(price.highestPrice)
            self.priceRangeSlider.selectedMinValue = CGFloat(price.lowestPrice)

        }
        self.priceRangeSlider.delegate = self
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initData() {
        if let priceMin = self.priceMin {
            self.priceRangeSlider.selectedMinValue =  CGFloat(priceMin)
        }
        if let priceMax = self.priceMax {
            self.priceRangeSlider.selectedMaxValue = CGFloat(priceMax)
        }
    }
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        self.priceMin = Int(minValue)
        self.priceMax = Int(maxValue)
        self.onChangePrice(self.priceMin!, self.priceMax!)
    }
    
}

class TotalDivesCell: NTableViewCell {
    private let totalDives: [String] = ["1","2","3",">4"]
    @IBOutlet var totalDiveSort: DLRadioButton!
    
    var onChangeTotalDives: ([String]?) -> () = {totalDives in}
    var total: [String]?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.totalDiveSort.isMultipleSelectionEnabled = true
        self.totalDiveSort.titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 15)
        
        for otherButton in self.totalDiveSort.otherButtons {
            otherButton.titleLabel?.font =  UIFont(name: "FiraSans-Regular", size: 15)
        }

        // Initialization code
    }
    fileprivate func initTotal() {
        if let total = self.total, !total.isEmpty {
            var i: Int = 0
            for totalDive in self.totalDives {
                for t in total {
                    if totalDive == t {
                        self.activateButtonBy(index: i)
                    }
                }
                i += 1
            }
        }
    }
    
    func activateButtonBy(index: Int) {
        if index == 0 {
            self.totalDiveSort.isSelected = true
        } else {
            for button in self.totalDiveSort.otherButtons {
                if button.tag == index {
                    button.isSelected = true
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func totalDivesButtonAction(_ sender: DLRadioButton) {
        self.total = nil
        for radioButton in self.totalDiveSort.selectedButtons() {
            if total == nil {
                total = []
            }
            let index = radioButton.tag
            total?.append(totalDives[index])
        }
        self.onChangeTotalDives(total)
    }

}

class TripCategoryCell: NTableViewCell {
    
    @IBOutlet weak var flowLayout: TGFlowLayout!
    @IBOutlet weak var flowLayoutHeight: NSLayoutConstraint!
    var selectedCategories: [String]?
    var reloadData: ([String]?)->() = {selectedCategories in
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


    @objc func tagButtonAction(_ sender: UIButton!) {
        let tag = sender.tag
        if tag == -1 {
            if !sender.isSelected {
                self.selectedCategories = []
                let categories = NCategory.getCategories()
                for category in categories! {
                    self.selectedCategories?.append(category.id!)
                }
            } else {
                self.selectedCategories = nil
            }
        } else {
            if !sender.isSelected {
                if self.selectedCategories == nil {
                    self.selectedCategories = []
                }
                let categories = NCategory.getCategories()
                self.selectedCategories!.append(categories![tag].id!)
            } else {
                if let selectedCategories = self.selectedCategories {
                    var i = 0
                    let categories = NCategory.getCategories()
                    let category = categories![tag]
                    for selectedCategory in selectedCategories {
                        if selectedCategory == category.id! {
                            self.selectedCategories!.remove(at: i)
                        }
                        i += 1
                    }
                }
            }
        }
        
        
        self.reloadData(self.selectedCategories)
    }
    
    func initView() {
        self.flowLayout.tg_leftPadding = 16
        self.flowLayout.tg_rightPadding = 16
        self.flowLayout.tg_topPadding = 16
        self.flowLayout.tg_bottomPadding = 16
        self.flowLayout.tg_space = 8
        self.flowLayout.tg_autoArrange = false

        self.flowLayout.tg_removeAllSubviews()
        let categories = NCategory.getCategories()
        if let categories = categories, !categories.isEmpty {
            var i = 0
            let button = UIButton()
            button.layer.cornerRadius = 5
            button.tag = -1
            button.titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 15)
            button.setTitle("All", for: .normal)
            if let selectedCategories = selectedCategories, selectedCategories.count >= categories.count {
                button.isSelected = true
                button.backgroundColor = UIColor.nyOrange
                button.setImage(UIImage(named:"ic_ferry"), for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
            } else {
                button.isSelected = false
                button.setImage(UIImage(named:"ic_ferry_inactive"), for: .normal)
                button.setTitleColor(UIColor.lightGray, for: .normal)
                button.layer.borderColor = UIColor.lightGray.cgColor
                button.layer.borderWidth = 1
                button.backgroundColor = UIColor.white
            }
            button.tg_width.equal(button.tg_width).add(10)
            button.tg_height.equal(button.tg_height).add(15)
            button.contentHorizontalAlignment = .left
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            button.sizeToFit()
            button.addTarget(self, action: #selector(tagButtonAction(_:)), for: .touchUpInside)
            self.flowLayout.addSubview(button)
            var additional: CGFloat = 0
            for category in categories {
                let button = UIButton()
                button.layer.cornerRadius = 5
                var selected: Bool = false
                
                if let selectedCategories = self.selectedCategories, !selectedCategories.isEmpty {
                    for selectedCategory in selectedCategories {
                        if selectedCategory == category.id! {
                            selected = true
                            break
                        }
                    }
                }
                
                if selected {
                    button.backgroundColor = UIColor.nyOrange
                    button.setImage(UIImage(named:"ic_ferry"), for: .normal)
                    button.setTitleColor(UIColor.white, for: .normal)
                    additional += 4
                } else {
                    button.layer.borderColor = UIColor.lightGray.cgColor
                    button.layer.borderWidth = 1
                    button.backgroundColor = UIColor.white
                    button.setImage(UIImage(named:"ic_ferry_inactive"), for: .normal)
                    button.setTitleColor(UIColor.lightGray, for: .normal)
                }
                button.isSelected = selected
                button.tag = i
                button.titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 15)
                button.setTitle(category.name, for: .normal)
                button.tg_width.equal(button.tg_width).add(10)
                button.tg_height.equal(button.tg_height).add(15)
                button.contentHorizontalAlignment = .left
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
                button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
                button.addTarget(self, action: #selector(tagButtonAction(_:)), for: .touchUpInside)
                button.sizeToFit()
                self.flowLayout.addSubview(button)
                i+=1
            }
            self.flowLayoutHeight.constant = 270 + additional
        }
    }
}

class FacilityCell: NTableViewCell {
    
    @IBOutlet weak var flowLayout: TGFlowLayout!
    @IBOutlet weak var flowLayoutHeight: NSLayoutConstraint!
    
    var reloadData: ([String]?)->() = {selectedFacilities in }
    var selectedFacilities:[String]?
    var facilities:[Int: [String]] = [
        0: ["Dive Guide", "dive_guide", "ic_dive_guide_unactive", "ic_dive_guide_white"],
        1: ["Food", "food", "ic_food_and_drink_unactive", "ic_food_and_drink_white"],
        2: ["Towel", "towel", "ic_towel_unactive", "ic_towel_white"],
        3: ["Dive Equipment", "dive_equipment", "ic_equipment_unactive", "ic_equipment_white"],
        4: ["Transportation", "transportation", "ic_transportation_unactive",
        "ic_transportation_white"],
        5: ["Accomodation", "accomodation", "ic_accomodation_unactive", "ic_accomodation_white"]
    ]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func facilityButtonAction(_ sender: UIButton!) {
        let tag = sender.tag
        if !sender.isSelected {
            if self.selectedFacilities == nil {
                self.selectedFacilities = []
            }
            self.selectedFacilities!.append(self.facilities[tag]![1])
        } else {
            if let selectedFacilities = self.selectedFacilities {
                var i = 0
                let facility = self.facilities[tag]![1]
                for selectedFacility in selectedFacilities {
                    if selectedFacility == facility {
                        self.selectedFacilities!.remove(at: i)
                    }
                    i += 1
                }
            }
        }

        self.reloadData(self.selectedFacilities)
    }
    
    func initView() {
        self.flowLayout.tg_leftPadding = 16
        self.flowLayout.tg_rightPadding = 16
        self.flowLayout.tg_topPadding = 16
        self.flowLayout.tg_bottomPadding = 16
        self.flowLayout.tg_space = 8
        self.flowLayout.tg_autoArrange = false
        self.flowLayout.tg_removeAllSubviews()
        var additional: CGFloat = 0
        for (key, value) in facilities {
            let button = UIButton()
            button.layer.cornerRadius = 5
            var selected: Bool = false
            if let selectedFacilities = self.selectedFacilities, !selectedFacilities.isEmpty {
                
                for selectedFacility in selectedFacilities {
                    if selectedFacility == value[1] {
                        selected = true
                        break
                    }
                }
            }
            
            if selected {
                additional += 4
                button.backgroundColor = UIColor.nyOrange
                button.setImage(UIImage(named: value[3]), for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
            } else {
                button.layer.borderColor = UIColor.lightGray.cgColor
                button.layer.borderWidth = 1
                button.backgroundColor = UIColor.white
                button.setImage(UIImage(named: value[2]), for: .normal)
                button.setTitleColor(UIColor.lightGray, for: .normal)
            }
            button.isSelected = selected
            button.tag = key
            button.titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 15)
            button.setTitle(value[0], for: .normal)
            button.tg_width.equal(button.tg_width).add(10)
            button.tg_height.equal(button.tg_height).add(15)
            button.contentHorizontalAlignment = .left
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            button.sizeToFit()
            button.addTarget(self, action: #selector(facilityButtonAction(_:)), for: .touchUpInside)
            self.flowLayout.addSubview(button)
        }
        self.flowLayoutHeight.constant = 180 + additional
    }
}





