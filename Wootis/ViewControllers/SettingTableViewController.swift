//
//  SettingTableViewController.swift
//  Wootis
//
//  Created by Alex Lopez on 31/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var BirthdateField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var sexField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Profile"
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        Api.User.observCurrentUser { (user) in
            if let profileUrl = URL(string: user.profileImageUrl!){
                self.profileImage.sd_setImage(with: profileUrl)
            }
            self.usernameField.text = user.username
            self.EmailField.text = user.email
            self.BirthdateField.text = user.birthdate
            self.phoneField.text = user.phone
            self.sexField.text = user.sex
        }
    }
    @IBAction func changeImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if let profileImg = self.profileImage.image, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            AuthServices.updateUserInfo(username: usernameField.text!, email: EmailField.text!, birthdate: BirthdateField.text!, phone: phoneField.text!, sex: sexField.text!, imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("Saved")
            }, onError: { (errorMessage) in
                ProgressHUD.showError(errorMessage)
            })
        }
    }
    
    @IBAction func changePassword(_ sender: Any) {
        
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
    }
}

extension SettingTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
