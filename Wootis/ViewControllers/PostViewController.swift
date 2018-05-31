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
import FirebaseAuth
import ImagePicker
import Lightbox

class PostViewController: UIViewController, ImagePickerDelegate {
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postOnePhoto: UIImageView!
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
        if let profileImg = self.postOnePhoto.image, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            let photoIdString = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: "gs://wooptis-database.appspot.com").child("posts").child(photoIdString)
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                
                let postId = Database.database().reference().child("posts")
                Api.Feed.REF_FEED.child(Api.User.CURRENT_USER!.uid).child(postId.childByAutoId().key).setValue(true)
                //Database.database().reference().child("feed").child(Api.User.CURRENT_USER!.uid).child(postId.childByAutoId().key).setValue(true)
                
                let postOneUrl = metadata?.downloadURL()?.absoluteString
                if let profileImg = self.postTwoPhoto.image, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
                    let photoIdString = NSUUID().uuidString
                    let storageRef = Storage.storage().reference(forURL: "gs://wooptis-database.appspot.com").child("posts").child(photoIdString)
                    storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            ProgressHUD.showError(error!.localizedDescription)
                            return
                        }
                        let postTwoUrl = metadata?.downloadURL()?.absoluteString
                        
                        self.sendDataToDatabase(photoOneUrl: postOneUrl!, photoTwoUrl: postTwoUrl!)
                    })
                } else {
                    //ProgressHUD.showError("Images section can't be empty") NO WORKS
                }
            })
        } else {
            //ProgressHUD.showError("Images section can't be empty") NO WORKS
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
        guard let currentUser = Auth.auth().currentUser?.uid else {
            return
        }
        let userId = currentUser
        newPostReference.setValue(["userID": userId, "Title": postTitle.text!, "photoOneUrl": photoOneUrl, "photoTwoUrl": photoTwoUrl, "comment": postComment.text!, "totalVotes": 0], withCompletionBlock: { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            let myPostRef = Api.MyPost.REF_MY_POSTS.child(userId).child(newPostId)
            myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                }
            })
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
        postOnePhoto.resignFirstResponder()
        postTwoPhoto.resignFirstResponder()
        return(true)
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 1, height: collectionView.frame.size.width / 3 - 1)
    }
}
