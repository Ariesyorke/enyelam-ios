//
//  DoShopFilterController.swift
//  Nyelam
//
//  Created by Bobi on 06/12/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class DoShopFilterController: BaseViewController {
    private let titles = ["Sort by", "Price Range", "Brands"]
    var filter: DoShopFilter?
    var price: Price?
    var brands: [Brand]?

    var onUpdateFilter: (DoShopFilter) -> () = {filter in}
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearButton.layer.borderColor = UIColor.blueActive.cgColor
        self.clearButton.layer.borderWidth = 1
        self.navigationItem.leftBarButtonItem = nil
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "DoShopSortByCell", bundle: nil), forCellReuseIdentifier: "DoShopSortByCell")
        self.tableView.register(UINib(nibName: "PriceRangeCell", bundle: nil), forCellReuseIdentifier: "PriceRangeCell")
        self.tableView.register(UINib(nibName: "DoShopBrandFilterCell", bundle: nil), forCellReuseIdentifier: "DoShopBrandFilterCell")

        self.tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    static func present(on controller: UINavigationController, price: Price, filter: DoShopFilter,
                        brands: [Brand]?, onUpdateFilter: @escaping (DoShopFilter)->()) -> DoShopFilterController {
        let vc: DoShopFilterController = DoShopFilterController(nibName: "DoShopFilterController", bundle: nil)
        vc.filter = filter
        vc.price = price
        vc.brands = brands
        vc.onUpdateFilter = onUpdateFilter
        controller.present(vc, animated: true, completion: {})
        return vc
    }


    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cleaarButotnAction(_ sender: Any) {
        self.filter = DoShopFilter()
        self.tableView.reloadData()
    }
    
    @IBAction func applyButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.onUpdateFilter(self.filter!)
        })
    }
}

extension DoShopFilterController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(108)
        } 
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
        label.text = self.titles[section]
        label.textColor = UIColor.black
        label.font = UIFont(name: "FiraSans-Regular", size: 14)
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell: DoShopSortByCell = tableView.dequeueReusableCell(withIdentifier: "DoShopSortByCell", for: indexPath) as! DoShopSortByCell
            cell.sortType = filter!.sortBy
            cell.onChangeSort = {sortType in
                print("SORT BY \(sortType)")
                self.filter!.sortBy = sortType
            }
            cell.initSort()
            return cell
        } else if section == 1 {
            let cell: PriceRangeCell = tableView.dequeueReusableCell(withIdentifier: "PriceRangeCell", for: indexPath) as! PriceRangeCell
            cell.price = self.price
            if let selectedPriceMin = self.filter!.selectedPriceMin {
                cell.priceMin = Int(selectedPriceMin)
            } else {
                cell.priceMin = nil
            }
            if let selectedPriceMax = self.filter!.selectedPriceMax {
                cell.priceMax = Int(selectedPriceMax)
            } else {
                cell.priceMax = nil
            }
            cell.initData()
            cell.onChangePrice = {priceMin, priceMax in
                self.filter!.selectedPriceMax = CGFloat(priceMin)
                self.filter!.selectedPriceMax = CGFloat(priceMax)
            }
            return cell
        } else if section == 2 {
            let cell: DoShopBrandFilterCell = tableView.dequeueReusableCell(withIdentifier: "DoShopBrandFilterCell", for: indexPath) as! DoShopBrandFilterCell
            cell.selectedBrands = filter!.selectedBrands
            cell.brands = self.brands
            cell.initView()
            cell.reloadData = {selectedBrands in
                self.filter!.selectedBrands = selectedBrands
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 2
        if let _ = self.brands {
            count += 1
        }
        return count
    }
}
