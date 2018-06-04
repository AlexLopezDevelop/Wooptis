//
//  Notification.swift
//  Wootis
//
//  Created by Alex Lopez on 3/6/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation

class Notification {
    var form: String?
    var objectId: String?
    var type: String?
    var timestamp: Int?
    var id: String?
}

extension Notification {
    static func transform(path: [String: Any], key: String) -> Notification {
        let notification = Notification()
        notification.id = key
        notification.objectId = path["objectUd"] as? String
        notification.type = path["type"] as? String
        notification.timestamp = path["timestamp"] as? Int
        notification.form = path["from"] as? String
        
        return notification
    }
}
