//
//  UserpApi.swift
//  Wootis
//
//  Created by Alex Lopez on 27/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserApi {
    var REF_USERS = Database.database().reference().child("users")
    func observeUsers(withId userId: String, completion: @escaping (Users) -> Void) {
        REF_USERS.child(userId).observeSingleEvent(of: .value, with: { snapshot in
            if let path = snapshot.value as? [String: Any] {
                let user = Users.transformUser(path: path)
                completion(user)
            }
        })
    }
}
