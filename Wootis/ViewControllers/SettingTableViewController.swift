//
//  SettingTableViewController.swift
//  Wootis
//
//  Created by Alex Lopez on 31/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol SettingTableViewControllerDelegate {
    func updateUserData()
}

class SettingTableViewController: UITableViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var BirthdateField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var sexField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    var delegate: SettingTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Profile"
        usernameField.delegate = self
        EmailField.delegate = self
        BirthdateField.delegate = self
        phoneField.delegate = self
        sexField.delegate = self
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
            ProgressHUD.show("Saving...")
            AuthServices.updateUserInfo(username: usernameField.text!, email: EmailField.text!, birthdate: BirthdateField.text!, phone: phoneField.text!, sex: sexField.text!, imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("Saved")
                self.delegate?.updateUserData()
            }, onError: { (errorMessage) in
                ProgressHUD.showError(errorMessage)
            })
        }
    }
    
    @IBAction func changePassword(_ sender: Any) {
        
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logOutError{
            print(logOutError)
        }
        let storyboard =  UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
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

extension SettingTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
