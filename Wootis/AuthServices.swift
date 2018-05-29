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
    
    static func signUp(username: String, email: String, password: String, birthdate: String, sex: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessge: String?) -> Void) {
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
                newUserReference.setValue(["username": username, "email": email, "birthdate": birthdate, "sex": sex, "password": password, "profileImage": profileImageURL])
                print("description: \(newUserReference.description())")
                onSuccess()
            })
        }
    }
    
    static func logout(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessge: String?) -> Void) {
        do {
            try Auth.auth().signOut()
            onSuccess()
            
        } catch let logOutError{
            onError(logOutError.localizedDescription)
        }
    }
    
}
