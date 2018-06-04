//
//  UserpApi.swift
//  Wootis
//
//  Created by Alex Lopez on 27/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserApi {
    var REF_USERS = Database.database().reference().child("users")
    
    func observUserByUsername(username: String, completion: @escaping (Users) -> Void) {
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryEqual(toValue: username).observeSingleEvent(of: .childAdded, with: { snapshot in
            if let path = snapshot.value as? [String: Any] {
                let user = Users.transformUser(path: path, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeUsers(withId userId: String, completion: @escaping (Users) -> Void) {
        REF_USERS.child(userId).observeSingleEvent(of: .value, with: { snapshot in
            if let path = snapshot.value as? [String: Any] {
                let user = Users.transformUser(path: path, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observCurrentUser (completion: @escaping (Users) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value, with: { snapshot in
            if let path = snapshot.value as? [String: Any] {
                let user = Users.transformUser(path: path, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeUsersFollow(completion: @escaping (Users) -> Void) {
        REF_USERS.observe(.childAdded, with: { snapshot in
            if let path = snapshot.value as? [String: Any] {
                let user = Users.transformUser(path: path, key: snapshot.key)
                if user.id! != Api.User.CURRENT_USER?.uid {
                    completion(user)
                }
            }
        })
    }
    
    func queryUsers(withText text: String, completion: @escaping (Users) -> Void) {
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { snapshot in
            snapshot.children.forEach({ (search) in
                let child = search as! DataSnapshot
                if let path = child.value as? [String: Any] {
                    let user = Users.transformUser(path: path, key: child.key)
                    if user.id! != Api.User.CURRENT_USER?.uid {
                        completion(user)
                    }
                }
            })
        })
    }
    
    var CURRENT_USER: User? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }
        return nil
    }
    
    var REF_CURRENT_USER: DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        
        return REF_USERS.child(currentUser.uid)
    }
}
