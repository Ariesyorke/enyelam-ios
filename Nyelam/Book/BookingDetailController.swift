//
//  BookingDetailController.swift
//  Nyelam
//
//  Created by Bobi on 5/6/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import MBProgressHUD

class BookingDetailController: BaseViewController {
    private let sections = ["Your Booking ID:", "Contact Details", "Participant Details","Payment"]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var writeReviewButton: UIButton!
    
    fileprivate var orderReturn: OrderReturn?
    fileprivate var type: String = "1"
    fileprivate var bookingId: String?
    fileprivate var isComeFromOrder: Bool = false
    let picker = UIImagePickerController()
    
    static func push(on controller: UINavigationController, bookingId: String, type: String) -> BookingDetailController {
        let vc: BookingDetailController = BookingDetailController(nibName: "BookingDetailController", bundle: nil)
        vc.bookingId = bookingId
        vc.type = type
        controller.setNavigationBarHidden(false, animated: true)
        controller.navigationBar.barTintColor = UIColor.primary
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    static func push(on controller: UINavigationController, bookingId: String, type: String, isComeFromOrder: Bool) -> BookingDetailController {
        let vc: BookingDetailController = BookingDetailController(nibName: "BookingDetailController", bundle: nil)
        vc.bookingId = bookingId
        vc.type = type
        vc.isComeFromOrder = isComeFromOrder
        controller.setNavigationBarHidden(false, animated: true)
        controller.navigationBar.barTintColor = UIColor.primary
        controller.pushViewController(vc, animated: true)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.firstTime {
            self.firstTime = false
            self.loadBookingDetail(bookingId: self.bookingId!)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func initView() {
        self.title = "Booking Detail"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "BookingDetailCell", bundle: nil), forCellReuseIdentifier: "BookingDetailCell")
        self.tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        self.tableView.register(UINib(nibName: "ParticipantCell", bundle: nil), forCellReuseIdentifier: "ParticipantCell")
        self.tableView.register(UINib(nibName: "PaymentProofCell", bundle: nil), forCellReuseIdentifier: "PaymentProofCell")
//        if self.type == "1" {
            self.writeReviewButton.isHidden = true
//        } else {
//            self.writeReviewButton.isHidden = false
//        }
    }
    
    fileprivate func loadBookingDetail(bookingId: String) {
        NHTTPHelper.httpDetail(bookingId: bookingId, complete: {response in
            self.loadingView.isHidden = true
            self.tableView.isHidden = false
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.loadBookingDetail(bookingId: bookingId)
                    })
                }
                return
            }
            if let data = response.data {
                self.orderReturn = data
                self.tableView.reloadData()
            }
        })
    }
    
    override func backButtonAction(_ sender: UIBarButtonItem) {
        if isComeFromOrder {
            if let navigation = self.navigationController {
                self.moveSafeAreaInsets()
                navigation.setNavigationBarHidden(true, animated: true)
                navigation.popToRootViewController(animated: true)
            }
        } else {
            super.backButtonAction(sender)
        }
    }

    @IBAction func reviewButtonAction(_ sender: Any) {
        ReviewController.present(on: self.navigationController!, bookingId: self.bookingId!)
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

extension BookingDetailController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if orderReturn == nil {
            return 0
        }
        
        if self.type == "1" {
            return self.orderReturn!.veritransToken != nil || self.orderReturn!.paypalCurrency != nil || self.orderReturn!.summary!.order!.status != "unpaid" ? 3 : 4
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var participants = orderReturn!.summary!.participant
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return participants != nil ? participants!.count: 0
        case 3:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingDetailCell", for: indexPath) as! BookingDetailCell
            
            if let orderReturn = self.orderReturn, let summary = orderReturn.summary, let order = summary.order, let diveService = summary.diveService {
                cell.initData(diveService: diveService, subTotal: order.cart!.subtotal, total: order.cart!.total, selectedDate: Date(timeIntervalSince1970: order.schedule), selectedDiver: summary.participant!.count, additionals: order.additionals, equipments: order.equipments)
            }
            return cell
        } else if indexPath.section == 1 {
            let row = indexPath.row
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
            cell.changeButton.isHidden = true
            if let orderReturn = self.orderReturn, let summary = orderReturn.summary, let contact = summary.contact {
                cell.initData(contact: contact)
            }
            return cell
        } else if indexPath.section == 2 {
            let row = indexPath.row
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantCell", for: indexPath) as! ParticipantCell
            cell.changeButton.isHidden = true
            if let orderReturn = self.orderReturn, let summary = orderReturn.summary, let participants = summary.participant, !participants.isEmpty {
                let participant = participants[row]
                cell.initData(participant: participant)
            }
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentProofCell", for: indexPath) as! PaymentProofCell
            cell.onChangePhoto = {
                UIAlertController.showAlertWithMultipleChoices(title: "Change Profile Photo", message: nil, viewController: self, buttons: [
                    UIAlertAction(title: "Gallery", style: .default, handler: {alert in
                        self.picker.sourceType = .photoLibrary
                        self.picker.delegate = self
                        self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                        self.present(self.picker, animated: true, completion: nil)
                    }),
                    UIAlertAction(title: "Take Photo", style: .default, handler: {alert in
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            self.picker.sourceType = UIImagePickerControllerSourceType.camera
                            self.picker.cameraCaptureMode = .photo
                            self.picker.delegate = self
                            self.picker.modalPresentationStyle = .fullScreen
                            self.present(self.picker,animated: true,completion: nil)
                        } else {
                            UIAlertController.handleErrorMessage(viewController: self, error: "Sorry this device has no camera", completion: {})
                        }
                    }),
                    UIAlertAction(title: "Cancel", style: .default, handler: {alert in
                        
                    })
                ])
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionTitle = NBookingTitleSection(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        if section == 0 {
            sectionTitle.subtitleLabel.isHidden = false
        } else {
            sectionTitle.subtitleLabel.isHidden = true
        }
        sectionTitle.titleLabel.text = self.sections[section]
        if section == 0 {
            sectionTitle.titleLabel.text = "\(sectionTitle.titleLabel.text!) #\(orderReturn!.summary!.order!.orderId!)"
            sectionTitle.subtitleLabel.text = "\(orderReturn!.summary!.order!.status!)"
        }
        return sectionTitle
    }
    
    fileprivate func uploadProof(data: Data, bookingId: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NHTTPHelper.httpUploadPaymentProof(data: data, bookingDetailId: bookingId, complete: {response in    
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.loadBookingDetail(bookingId: bookingId)
                    })
                }
                return
            }
            UIAlertController.handlePopupMessage(viewController: self, title: "Upload Success!", actionButtonTitle: "OK", completion: {
                self.loadBookingDetail(bookingId: bookingId)
            })
        })
    }
    
}

extension BookingDetailController: UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let data = UIImageJPEGRepresentation(chosenImage, 0.75)
            self.dismiss(animated: true, completion: {
                self.uploadProof(data: data!, bookingId: self.bookingId!)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
class PaymentProofCell: NTableViewCell {
    var onChangePhoto: ()->() = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func chooseFileButtonAction(_ sender: Any) {
        self.onChangePhoto()
    }
    
}

