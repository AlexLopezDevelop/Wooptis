//
//  User.swift
//  Wootis
//
//  Created by Alex Lopez on 24/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
class Users {
    var email: String?
    var profileImageUrl: String?
    var username: String?
}

extension Users {
    static func transformUser(path: [String: Any]) -> Users {
        let user = Users()
        user.email = path["email"] as? String
        user.profileImageUrl = path["profileImage"] as? String
        user.username = path["username"] as? String
        return user
    }
}
