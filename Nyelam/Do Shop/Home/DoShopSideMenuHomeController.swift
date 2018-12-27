//
//  DoShopSideMenuHomeController.swift
//  Nyelam
//
//  Created by Bobi on 11/21/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import ExpyTableView

class DoShopSideMenuHomeController: BaseViewController {
    let contents: [String] = ["Back To e-Nyelam", "Payment History","Categories"]
    @IBOutlet weak var tableView: ExpyTableView!
    var categories: [NProductCategory]? = nil {
        didSet {
            if let categories = self.categories {
                self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstTime {
            self.firstTime = false
            self.tryLoadCategories()
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            let _ = DoShopSideMenuController.push(on: self.navigationController as! DoShopSideMenuNavigationController)
//            break
//        case 1:
//            if let navigationController = self.navigationController as? DoShopSideMenuNavigationController {
//                navigationController.onSideMenuClicked(DoShopSideMenuType.order)
//            }
//            break
//        default:
//            if let navigationController = self.navigationController as? DoShopSideMenuNavigationController {
//                navigationController.onSideMenuClicked(DoShopSideMenuType.exit)
//            }
//            break
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    fileprivate func tryLoadCategories() {
        NHTTPHelper.httpGetMasterDoShopCategory(complete: {response in
            if let error = response.error {
                self.tryLoadCategories()
            }
            if let data = response.data, !data.isEmpty {
                self.categories = data
            }
        })
    }

}

extension DoShopSideMenuHomeController: ExpyTableViewDataSource, ExpyTableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let navigationController = self.navigationController as? DoShopSideMenuNavigationController {
                navigationController.onSideMenuClicked(DoShopSideMenuType.exit, nil)
            }
            break
        case 1:
            if let navigationController = self.navigationController as? DoShopSideMenuNavigationController {
                navigationController.onSideMenuClicked(DoShopSideMenuType.order, nil)
            }
            break
        default:
            if indexPath.row >= 1 {
                if let navigationController = self.navigationController as? DoShopSideMenuNavigationController {
                    let index = indexPath.row - 2
                    let category = self.categories![index]
                    navigationController.onSideMenuClicked(DoShopSideMenuType.category, category)
                }
            }
            break
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 2:
            if let categories = self.categories, !categories.isEmpty {
                return categories.count + 1
            } else {
                return 1
            }
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel!.text = self.contents[section]
        if section == 0 {
            cell.imageView?.image = UIImage(named: "ic_back_button_white")
           cell.contentView.backgroundColor = UIColor.primary
            cell.textLabel?.textColor = UIColor.white
        } else {
            cell.imageView?.image = nil
            cell.contentView.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        let category = self.categories![indexPath.row - 1]
        cell.textLabel!.text = category.categoryName
//        if let imageUrl = category.categoryImage, let url = URL(string: imageUrl) {
//            cell.imageView!.af_setImage(withURL: url, placeholderImage: UIImage(named: "image_default"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: true, completion: nil)
//        }
        return cell
    }
    
    
}
