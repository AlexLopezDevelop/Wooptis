//
//  SignUpViewController.swift
//  Wootis
//
//  Created by Alex Lopez on 28/12/17.
//  Copyright © 2017 Wootis.inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {

    //Interfaz ----------------------------------------->
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var birthdate: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var singUp: UIButton!
    // ------------------------------------------------->
    
    // Variables --------------------------------------->
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableButton()
        createDatePicker()
        handleTextField()
    }
    //------------------------------------------------>
    
    //Buttons Action --------------------------------->
    @IBAction func logIn(_ sender: Any) {
        //Back page
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func singUp(_ sender: Any) {
        self.view.endEditing(true)
        ProgressHUD.show("Watting...", interaction: false)
        AuthServices.signUp(username: username.text!, email: email.text!, password: password1.text!, birthdate: birthdate.text!, sex: sex.text!, onSuccess: {
            ProgressHUD.showSuccess("Success")
            self.dismiss(animated: true, completion: nil)
        }, onError: { error in
            ProgressHUD.showError(error!)
        })
    }
    
    //------------------------------------------------>
    
    // Custom functions ------------------------------>
    
    //Target inputs
    func handleTextField(){
        username.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        email.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        birthdate.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        sex.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        password1.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    //No nil inputs
    @objc func textFieldDidChange(){
        guard let username = username.text, !username.isEmpty, let email = email.text, !email.isEmpty, let birthdate = birthdate.text, !birthdate.isEmpty, let sex = sex.text, !sex.isEmpty, let password1 = password1.text, !password1.isEmpty, let password2 = password2.text, !password2.isEmpty else {
            disableButton()
            return
        }
        enableButton()
    }
    
    //Custom picker for date
    func createDatePicker(){
        
        //Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //Done buttom for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        birthdate.inputAccessoryView = toolbar
        birthdate.inputView = picker
        
        //Format picker for date
        picker.datePickerMode = .date
        
    }
    
    @objc func donePressed(){
        
        //Format date ------------------->
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        //------------------------------->
        
        birthdate.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    //Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        username.resignFirstResponder()
        email.resignFirstResponder()
        birthdate.resignFirstResponder()
        sex.resignFirstResponder()
        password1.resignFirstResponder()
        password2.resignFirstResponder()
        return(true)
    }
    
    //Enable button
    func enableButton() {
        singUp.setTitleColor(UIColor.black, for: UIControlState.normal)
        singUp.isEnabled = true
    }
    
    func disableButton() {
        singUp.setTitleColor(UIColor.gray, for: UIControlState.normal)
        singUp.isEnabled = false
    }
    // ------------------------------------------------->
    
    /*override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }*/
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
