//
//  DoShopSideMenuHomeController.swift
//  Nyelam
//
//  Created by Bobi on 11/21/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class DoShopSideMenuHomeController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    let contents: [String] = ["Categories", "Payment History", "Exit"]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = contents[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let _ = DoShopSideMenuController.push(on: self.navigationController as! DoShopSideMenuNavigationController)
            break
        case 1:
            if let navigationController = self.navigationController as? DoShopSideMenuNavigationController {
                navigationController.onSideMenuClicked(DoShopSideMenuType.order)
            }
            break
        default:
            if let navigationController = self.navigationController as? DoShopSideMenuNavigationController {
                navigationController.onSideMenuClicked(DoShopSideMenuType.exit)
            }
            break
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
