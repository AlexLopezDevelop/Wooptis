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
    var id: String?
    var isFollowing: Bool?
}

extension Users {
    static func transformUser(path: [String: Any], key: String) -> Users {
        let user = Users()
        user.email = path["email"] as? String
        user.profileImageUrl = path["profileImage"] as? String
        user.username = path["username"] as? String
        user.id = key
        return user
    }
}
