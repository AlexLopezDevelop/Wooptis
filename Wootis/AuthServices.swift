//
//  AuthServices.swift
//  Wootis
//
//  Created by Alex Lopez on 18/3/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
class AuthServices {
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessge: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
    }
    
    static func signUp(username: String, email: String, password: String, birthdate: String, phone: String, sex: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessge: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error: Error?) in
            if error != nil{
                onError(error!.localizedDescription)
                return
            }
            //Transform image profile to firebase friendly
            let uid = user?.uid
            let storageRef = Storage.storage().reference(forURL: "gs://wooptis-database.appspot.com").child("profile_image").child(uid!)
            let imageData = UIImageJPEGRepresentation(#imageLiteral(resourceName: "default-img-profile"), 0.1)
            storageRef.putData(imageData!, metadata: nil, completion: {(metadata, error) in
                if (error != nil){
                    return
                }
                
                //Default Image Profile
                let profileImageURL = metadata?.downloadURL()?.absoluteString
                
                let ref = Database.database().reference()
                print(ref.description())
                let usersReference = ref.child("users")
                //print(usersReference.description()) : https://wooptis-database.firebaseio.com/users
                let newUserReference = usersReference.child(uid!)
                newUserReference.setValue(["username": username, "username_lowercase": username.lowercased(), "email": email, "birthdate": birthdate, "phone": phone, "sex": sex, "password": password, "profileImage": profileImageURL])
                print("description: \(newUserReference.description())")
                onSuccess()
            })
        }
    }
    
    static func updateUserInfo(username: String, email: String, birthdate: String, phone: String, sex: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        Api.User.CURRENT_USER?.updateEmail(to: email, completion: { (error) in
            if (error != nil){
                onError(error!.localizedDescription)
            } else {
                let uid = Api.User.CURRENT_USER?.uid
                let storageRef = Storage.storage().reference(forURL: "gs://wooptis-database.appspot.com").child("profile_image").child(uid!)
                
                storageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
                    if (error != nil){
                        return
                    }
                    
                    let profileImageURL = metadata?.downloadURL()?.absoluteString
                    
                    self.updateUserData(username: username, email: email, birthdate: birthdate, phone: phone, sex: sex, profileImage: profileImageURL!, onSuccess: onSuccess, onError: onError)
                    
                })
            }
        })
    }
    
    static func updateUserData(username: String, email: String, birthdate: String, phone: String, sex: String, profileImage: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        let path = ["username": username, "username_lowercase": username.lowercased(), "email": email, "birthdate": birthdate, "phone": phone, "sex": sex, "profileImage": profileImage]
        Api.User.REF_CURRENT_USER?.updateChildValues(path, withCompletionBlock: { (error, ref) in
            if (error != nil){
                onError(error!.localizedDescription)
            } else {
                onSuccess()
            }
        })
    }
}
