//
//  AccountTableViewController.swift
//  Nyelam
//
//  Created by Bobi on 4/16/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//

import UIKit
import MBProgressHUD

class AccountTableViewController: BaseTableViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, PECropViewControllerDelegate {
    var viewContents: [Int: [String]] = [
        0: ["header", ""],
        1: ["section", "e-Nyelam Profile", "active"],
        2: ["content", "Edit Profile", "active"],
        3: ["content", "Change Password", "active"],
        4: ["content", "Logout", "active"],
        5: ["section", "e-Nyelam Features"],
        6: ["content", "Help Center", "inactive"],
        7: ["content", "My Refund", "inactive"],
        8: ["content", "Price Alerts", "inactive"],
        9: ["content", "Newsletter & Promo Info", "inactive"],
        10:["content", "Push Notification", "inactive"]
    ]
    
    let picker = UIImagePickerController()
    var pickedData: Data?
    var changePhotoProfile: Bool = false
    var changeCoverProfile: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Account Profile"
        self.tableView.register(UINib(nibName: "HeaderViewCell", bundle: nil), forCellReuseIdentifier: "HeaderViewCell")
        self.tableView.register(UINib(nibName: "SectionViewCell", bundle: nil), forCellReuseIdentifier: "SectionViewCell")
        self.tableView.register(UINib(nibName: "ContentViewCell", bundle: nil), forCellReuseIdentifier: "ContentViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 66
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewContents.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        case 2:
            let vc = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
            var controller: UIViewController? = nil
            if let parent = self.parent as? MainRootController {
                controller = parent
            } else {
                controller = self
            }
            if let navigation = controller!.navigationController {
                navigation.pushViewController(vc, animated: true)
            } else {
                self.present(vc, animated: true, completion: nil)
            }
            break
        case 3:
            let vc = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil)
            print("VC \(vc)")
            var controller: UIViewController? = nil
            if let parent = self.parent as? MainRootController {
                controller = parent
            } else {
                controller = self
            }
            if let navigation = controller!.navigationController {
                navigation.pushViewController(vc, animated: true)
            } else {
                self.present(vc, animated: true, completion: nil)
            }
            break
        case 4:
            //todo logout
            break
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var contents = self.viewContents[indexPath.row]!
        if contents[0] == "header" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderViewCell", for: indexPath) as! HeaderViewCell
            cell.onChangeCoverProfile = {
                UIAlertController.showAlertWithMultipleChoices(title: "Change Cover Photo", message: nil, viewController: self, buttons: [
                    UIAlertAction(title: "Gallery", style: .default, handler: {alert in
                        self.changeCoverProfile = true
                        self.picker.delegate = self
                        self.picker.sourceType = .photoLibrary
                        self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                        self.present(self.picker, animated: true, completion: nil)
                    }),
                    UIAlertAction(title: "Take Photo", style: .default, handler: {alert in
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            self.changeCoverProfile = true
                            self.picker.delegate = self
                            self.picker.sourceType = UIImagePickerControllerSourceType.camera
                            self.picker.cameraCaptureMode = .photo
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
            cell.onChangePhotoProfile = {
                UIAlertController.showAlertWithMultipleChoices(title: "Change Profile Photo", message: nil, viewController: self, buttons: [
                    UIAlertAction(title: "Gallery", style: .default, handler: {alert in
                        self.changePhotoProfile = true
                        self.picker.sourceType = .photoLibrary
                        self.picker.delegate = self
                        self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                        self.present(self.picker, animated: true, completion: nil)
                    }),
                    UIAlertAction(title: "Take Photo", style: .default, handler: {alert in
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            self.changePhotoProfile = true
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
            if self.changeCoverProfile, let data = self.pickedData {
                self.changeCoverProfile = false
                cell.coverImageView.image = UIImage(data: data)
                cell.coverPhoto = self.pickedData
            } else if self.changePhotoProfile, let data = self.pickedData {
                self.changePhotoProfile = false
                cell.photoImageView.image = UIImage(data: data)
            }
            return cell
        } else if contents[0] == "section" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionViewCell", for: indexPath) as! SectionViewCell
            cell.sectionNameLabel.text = contents[1]
            return cell
        } else if contents[0] == "content" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentViewCell", for: indexPath) as! ContentViewCell
            cell.nameLabel.text = contents[1]
            cell.circleView.circledView()
            if contents[2] == "active" {
                cell.nameLabel.textColor = UIColor.black
                cell.circleView.backgroundColor = UIColor.blueActive
            } else {
                cell.nameLabel.textColor = UIColor.gray
                cell.circleView.backgroundColor = UIColor.gray
            }
            return cell
        }
        // Configure the cell...

        return UITableViewCell()
    }
 
    //MARK UIIMAGEPICKER
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.dismiss(animated: true, completion: {
                let controller = PECropViewController()
                controller.delegate = self
                controller.image = chosenImage
                
                let width = chosenImage.size.width
                let height = chosenImage.size.height
                controller.isRotationEnabled = false
                controller.keepingCropAspectRatio = true
                controller.toolbarHidden = true
                if self.changePhotoProfile {
                    let length = width/2
                    controller.imageCropRect = CGRect(x: width/2,
                                                      y: height/2,
                                                      width: length/2,
                                                      height: length/2)
                } else {
                    let length = width/2
                    controller.imageCropRect = CGRect(x: width / 2,
                                                      y: height / 2,
                                                      width: (length/2),
                                                      height: (length/2)/3)
                }

                let navController = BaseNavigationController(rootViewController: controller)
                self.present(navController, animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        self.changeCoverProfile = false
        self.changePhotoProfile = false
    }
    
    func cropViewControllerDidCancel(_ controller: PECropViewController!) {
        self.changeCoverProfile = false
        self.changePhotoProfile = false
        if let navigation = controller.navigationController {
            navigation.dismiss(animated: true, completion: nil)
        } else {
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    func cropViewController(_ controller: PECropViewController!, didFinishCroppingImage croppedImage: UIImage!) {
        self.pickedData = UIImageJPEGRepresentation(croppedImage, 0.75)
        if let navigation = controller.navigationController {
            navigation.dismiss(animated: true, completion: nil)
        } else {
            controller.dismiss(animated: true, completion: nil)
        }
        //TODO UPLOAD PHOTO
        if let data = self.pickedData {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            if self.changeCoverProfile {
                self.tryUploadCover(data: data)
            } else {
                self.tryUploadProfile(data: data)
            }
        }
    }
    
    internal func tryUploadCover(data: Data) {
        NHTTPHelper.httpUploadCover(data: data, complete: {response in
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryUploadCover(data: data)
                    })
                }
                return
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            UIAlertController.handlePopupMessage(viewController: self, title: "Upload Successfull", actionButtonTitle: "OK", completion: {
                self.tableView.reloadData()
            })
        })
    }
    
    internal func tryUploadProfile(data: Data) {
        NHTTPHelper.httpUploadPhotoProfile(data: data, complete: {response in
            if let error = response.error {
                if error.isKind(of: NotConnectedInternetError.self) {
                    NHelper.handleConnectionError(completion: {
                        self.tryUploadProfile(data: data)
                    })
                }
                return
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            UIAlertController.handlePopupMessage(viewController: self, title: "Upload Successfull", actionButtonTitle: "OK", completion: {
                self.tableView.reloadData()
            })
        })

    }
    
    
    //MARK IGR PHOTO TWEAK
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

class ContentViewCell: NTableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var arrowView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

class SectionViewCell: NTableViewCell {
    @IBOutlet weak var sectionNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
class HeaderViewCell: NTableViewCell {
    var onChangePhotoProfile: ()->() = {}
    var onChangeCoverProfile: ()->() = {}
    var coverPhoto: Data?
    var profilePhoto: Data?
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func changeCoverPictureAction(_ sender: Any) {
        self.onChangeCoverProfile()
    }
    
    @IBAction func changeProfilePictureAction(_ sender: Any) {
        self.onChangePhotoProfile()
    }
}

enum AccountMenuItemType {
    case editprofile
    case changepassword
    case logout
}
