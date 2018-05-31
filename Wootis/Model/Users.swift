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
    var birthdate: String?
    var phone: String?
    var sex: String?
    var id: String?
    var isFollowing: Bool?
}

extension Users {
    static func transformUser(path: [String: Any], key: String) -> Users {
        let user = Users()
        user.email = path["email"] as? String
        user.profileImageUrl = path["profileImage"] as? String
        user.username = path["username"] as? String
        user.birthdate = path["birthdate"] as? String
        user.phone = path["phone"] as? String
        user.sex = path["sex"] as? String
        user.id = key
        return user
    }
}
