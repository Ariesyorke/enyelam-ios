//
//  SideMenuController.swift
//  Nyelam
//
//  Created by Bobi on 4/17/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import CoreData

class SideMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var cellsIfLogins = ["Account", "Terms & Condition", "Contact Us", "Logout"]
    var cellsIfNotLogins = ["Login", "Terms & Condition", "Contact Us"]
    
    @IBOutlet weak var tableView: UITableView!
    var handleMenuItem: (SideMenuItemType)->() = {menu in
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName:"ContentViewCell", bundle: nil), forCellReuseIdentifier: "ContentViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 66

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = NAuthReturn.authUser() {
            return cellsIfLogins.count
        } else {
            return cellsIfNotLogins.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: {
            switch indexPath.row {
            case 0:
                if let _ = NAuthReturn.authUser() {
                    self.handleMenuItem(SideMenuItemType.account)
                } else {
                    self.handleMenuItem(SideMenuItemType.login)
                }
                break
            case 1:
                self.handleMenuItem(SideMenuItemType.terms)
                break
            case 2:
                self.handleMenuItem(SideMenuItemType.contactus)
                break
            case 3:
                self.handleMenuItem(SideMenuItemType.logout)
                break
            default:
                return
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contents: [String] = (NAuthReturn.authUser() != nil) ? cellsIfLogins : cellsIfNotLogins
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentViewCell", for: indexPath) as! ContentViewCell
        cell.nameLabel.text = contents[indexPath.row]
        cell.arrowView.isHidden = true
//        cell.circleView.circledView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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

enum SideMenuItemType {
    case login
    case account
    case terms
    case contactus
    case logout
}

