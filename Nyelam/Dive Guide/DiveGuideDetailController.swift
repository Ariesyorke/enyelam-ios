//
//  DiveGuideDetailController.swift
//  Nyelam
//
//  Created by Bobi on 7/10/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit

class DiveGuideDetailController: BaseViewController {
    static func present(on controller: UIViewController, diveGuideId: String) -> UIViewController {
        let vc: DiveGuideDetailController = DiveGuideDetailController(nibName: "DiveGuideDetailController", bundle: nil)
        vc.diveGuideId = diveGuideId
        controller.present(vc, animated: true, completion: nil)
        return vc
    }
    let images: [String] = ["icon_license_on", "ic_nationality", "ic_spoken_language", "ic_special_ability"]
    let titles: [String] = ["Certification Association", "Nationality", "Spoken Language", "Special Abilities"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var aboutLabel: UILabel!
    
    fileprivate var diveGuide: NUser?
    fileprivate var diveGuideId: String?
    fileprivate var strechyHeaderView: NStickyDiveGuideHeader?
    fileprivate var state: DiveGuideTableState = .bio
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.firstTime {
            self.firstTime = false
            self.initView()
            self.tryLoadDiveGuideDetail(diveGuideId: self.diveGuideId!)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tryLoadDiveGuideDetail(diveGuideId: String) {
        NHTTPHelper.httpGetDiveGuideDetail(diveGuideId: diveGuideId, complete: {response in
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryLoadDiveGuideDetail(diveGuideId: diveGuideId)
                    })
                }
                return
            }
            if let data = response.data {
                self.diveGuide = data
                if let about = data.about, !about.isEmpty {
                    self.aboutLabel.text = about
                } else {
                    self.aboutLabel.text = "No bio descripted"
                }
                self.strechyHeaderView!.initUser(user: data)
                self.loadingView.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        })
    }
    
    fileprivate func initView() {
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
        let nibViews = Bundle.main.loadNibNamed("NStickyDiveGuideHeader", owner: self, options: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "DiveGuideDetailCell", bundle: nil), forCellReuseIdentifier: "DiveGuideDetailCell")
        self.strechyHeaderView = nibViews!.first as! NStickyDiveGuideHeader
        self.strechyHeaderView!.delegate = self
        self.strechyHeaderView!.expansionMode = .topOnly
        self.strechyHeaderView!.tabLineBioView.isHidden = false
        self.tableView.addSubview(self.strechyHeaderView!)
        
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

extension DiveGuideDetailController: NStickyDiveGuideHeaderDelegate {
    func stickyHeaderView(_ headerView: NStickyDiveGuideHeader, didSelectTabAt index: Int) {
        if index == 0 {
            self.state = .bio
            self.aboutLabel.isHidden = true
        } else {
            self.state = .about
            self.aboutLabel.isHidden = false
        }
        self.tableView.reloadData()
    }
}
extension DiveGuideDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.state == .bio {
            if let diveGuide = self.diveGuide {
                return 4
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DiveGuideDetailCell") as! DiveGuideDetailCell
        cell.titleLabel.text = self.titles[indexPath.row]
        cell.contentImageView.image = UIImage(named: self.images[indexPath.row])
        if let diveGuide = self.diveGuide {
            switch indexPath.row {
            case 0:
                if let organization = diveGuide.organization, let certificateNumber = diveGuide.certificateNumber {
                    cell.subtitleLabel.text = "\(organization.name) #\(certificateNumber)"
                } else {
                    cell.subtitleLabel.text = "-"
                }
                break
            case 1:
                if let nationality = diveGuide.nationality {
                    cell.subtitleLabel.text = nationality.name
                } else {
                    cell.subtitleLabel.text = "-"
                }
                break
            case 2:
                if let languages = diveGuide.languages?.allObjects as? [NLanguage], !languages.isEmpty {
                    var language = ""
                    var i = 0
                    for l in languages {
                        language += l.name!
                        i += 1
                        if languages.count > i {
                            language += ", "
                        }
                    }
                    cell.subtitleLabel.text = language
                }
                break
            case 3:
                if let specialAbilites = diveGuide.specialAbilities, !specialAbilites.isEmpty {
                    var abiities = ""
                    var i = 0
                    for ability in specialAbilites {
                        abiities += ability
                        i += 1
                        if specialAbilites.count > i {
                            abiities += ", "
                        }
                    }
                    cell.subtitleLabel.text = abiities
                } else {
                    cell.subtitleLabel.text = "-"
                }
                break
            default:
                cell.subtitleLabel.text = "-"
            }
        }
        return cell
    }
}

enum DiveGuideTableState {
    case bio
    case about
}

