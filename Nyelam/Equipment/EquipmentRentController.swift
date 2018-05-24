//
//  EquipmentRentController.swift
//  Nyelam
//
//  Created by Bobi on 5/21/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import UINavigationControllerWithCompletionBlock

class EquipmentRentController: BaseViewController {
    static func push(on controller: UINavigationController, diveCenterId: String, selectedDate: Date, equipments: [Equipment]?, onUpdateEquipment: @escaping ([Equipment]?)->()) -> EquipmentRentController {
        let vc: EquipmentRentController = EquipmentRentController(nibName: "EquipmentRentController", bundle: nil)
        vc.chosenEquipments = equipments
        vc.selectedDate = selectedDate
        vc.diveCenterId = diveCenterId
        vc.onUpdateEquipment = onUpdateEquipment
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var notFoundLabel: UILabel!
    
    fileprivate var diveCenterId: String?
    fileprivate var selectedDate: Date?
    fileprivate var chosenEquipments: [Equipment]?
    fileprivate var equipments: [Equipment]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    fileprivate var onUpdateEquipment: ([Equipment]?) -> () = {equipment in}

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func initView() {
        self.title = "Add-on"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "EquipmentCell", bundle: nil), forCellReuseIdentifier: "EquipmentCell")
        self.tryLoadEquipmentList(diveCenterId: self.diveCenterId!, selectedDate: self.selectedDate!)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_circle_close_white"), style: .plain, target: self, action: #selector(backButtonAction(_:)))
    }
    
    fileprivate func tryLoadEquipmentList(diveCenterId: String, selectedDate: Date) {
        self.loadingView.isHidden = false
        NHTTPHelper.httpGetEquipmentList(date: selectedDate, diveCenterId: diveCenterId, complete: {response in
            self.loadingView.isHidden = true
            if let error = response.error {
                UIAlertController.handleErrorMessage(viewController: self, error: error, completion: {error in
                    if error.isKind(of: NotConnectedInternetError.self) {
                        NHelper.handleConnectionError(completion: {
                            self.tryLoadEquipmentList(diveCenterId: diveCenterId, selectedDate: selectedDate)
                        })
                    }
                })
                return
            }
            if let equipments = response.data, !equipments.isEmpty {
                self.equipments = equipments
            } else {
                self.notFoundLabel.isHidden = false
            }
        })
    }

    @IBAction func applyButtonAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true, withCompletionBlock: {
            self.onUpdateEquipment(self.chosenEquipments)
        })
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        self.chosenEquipments = nil
        self.tableView.reloadData()
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

extension EquipmentRentController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentCell", for: indexPath) as! EquipmentCell
        let equipment = self.equipments![indexPath.row]
        equipment.quantity = 0
        if let chosenEquipments = self.chosenEquipments, !chosenEquipments.isEmpty {
            for chosenEquipment in chosenEquipments {
                if chosenEquipment.id! == equipment.id! {
                    equipment.quantity = chosenEquipment.quantity
                }
            }
        }
        cell.equipment = equipment
        cell.initData()
        cell.onQuantityChanged = {eq in
            if let chosenEquipments = self.chosenEquipments, !chosenEquipments.isEmpty {
                var i = 0
                var isExist = false
                for chosenEquipment in chosenEquipments {
                    if chosenEquipment.id == eq.id {
                        isExist = true
                        if eq.quantity <= 0 {
                            self.chosenEquipments!.remove(at: i)
                            break
                        } else {
                            chosenEquipment.quantity = eq.quantity
                        }
                    }
                    i += 1
                }
                if !isExist {
                    let e = Equipment(json: eq.serialized())
                    self.chosenEquipments!.append(e)
                }
            } else {
                if eq.quantity > 0 {
                    let e = Equipment(json: eq.serialized())
                    self.chosenEquipments = []
                    self.chosenEquipments!.append(e)
                }
            }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.equipments != nil ? self.equipments!.count : 0
    }
    
}
class EquipmentCell: NTableViewCell {
    @IBOutlet weak var equipmentNameLabel: UILabel!
    @IBOutlet weak var equipmentPriceLabel: UILabel!
    @IBOutlet weak var equipmentStockLabel: UILabel!
    @IBOutlet weak var equipmentQuantityTextField: UITextField!
    var equipment: Equipment?
    var onQuantityChanged: (Equipment) -> () = {equipment in }
    @IBAction func minusButtonAction(_ sender: Any) {
        if self.equipment!.quantity > 0 {
            self.equipment!.quantity -= 1
        }
        self.onQuantityChanged(self.equipment!)
    }
    
    @IBAction func plusButtonAction(_ sender: Any) {
        if self.equipment!.quantity < self.equipment!.availabilityStock {
            self.equipment!.quantity += 1
        }
        self.onQuantityChanged(self.equipment!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func initData() {
        if let equipment = self.equipment {
            self.equipmentNameLabel.text = equipment.name
            self.equipmentPriceLabel.text = "@ \(equipment.specialPrice.toCurrencyFormatString(currency: "Rp"))"
            self.equipmentStockLabel.text = "Stock : \(String(equipment.availabilityStock))"
            self.equipmentQuantityTextField.text = String(equipment.quantity)
        }
    }
    
    
}
