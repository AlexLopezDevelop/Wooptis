//
//  PostViewController.swift
//  Wootis
//
//  Created by Alex Lopez on 15/4/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import ImagePicker
import Lightbox

class PostViewController: UIViewController, ImagePickerDelegate {
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postOneTitle: UITextField!
    @IBOutlet weak var postOnePhoto: UIImageView!
    @IBOutlet weak var postTwoTitle: UITextField!
    @IBOutlet weak var postTwoPhoto: UIImageView!
    @IBOutlet weak var postComment: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    
    //var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addImages(_ sender: Any) {
        var config = Configuration()
        config.doneButtonTitle = "Finish"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        config.allowVideoSelection = true
        
        let imagePicker = ImagePickerController(configuration: config)
        imagePicker.imageLimit = 2
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Functions image picker
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        self.postOnePhoto.image = images[0]
        self.postTwoPhoto.image = images[1]
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        if let profileImg = self.postTwoPhoto.image, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            let photoIdString = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: "gs://wooptis-database.appspot.com").child("posts").child(photoIdString)
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                let postOneUrl = metadata?.downloadURL()?.absoluteString
                let postTwoUrl = metadata?.downloadURL()?.absoluteString
                self.sendDataToDatabase(photoOneUrl: postOneUrl!, photoTwoUrl: postTwoUrl!)
            })
        } else {
            ProgressHUD.showError("Images section can't be empty")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //handlePost()
    }
    
    func handlePost() {
        if postTwoPhoto.image == nil {
            self.shareButton.isEnabled = true
            self.shareButton.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            self.shareButton.isEnabled = false
            self.shareButton.backgroundColor = .lightGray
        }
    }
    
    func sendDataToDatabase(photoOneUrl: String, photoTwoUrl: String) {
        let ref = Database.database().reference()
        let postsReference = ref.child("posts")
        let newPostId = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostId)
        newPostReference.setValue(["Title": postTitle.text!, "photoOneTitle": postOneTitle.text!, "photoOneUrl": photoOneUrl, "photoTwoTitle": postTwoTitle.text!, "photoTwoUrl": photoTwoUrl, "comment": postComment.text!], withCompletionBlock: { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Success")
            self.postComment.text = ""
            self.postOnePhoto.image = UIImage(named: "img-default")
            self.postTwoPhoto.image = UIImage(named: "img-default")
            self.tabBarController?.selectedIndex = 1
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postTitle.resignFirstResponder()
        postOneTitle.resignFirstResponder()
        postTwoTitle.resignFirstResponder()
        postOnePhoto.resignFirstResponder()
        postTwoPhoto.resignFirstResponder()
        return(true)
    }
    
}
