//
//  NotificationApi.swift
//  Wootis
//
//  Created by Alex Lopez on 3/6/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
import FirebaseDatabase

class NotificationApi {
    var REF_NOTIFICATION = Database.database().reference().child("notification")
    
    func observeNotification(withId id: String, completion: @escaping (Notification) -> Void) {
        REF_NOTIFICATION.child(id).observe(.childAdded, with: { snapshot in
            if let path = snapshot.value as? [String: Any] {
                let newNotification = Notification.transform(path: path, key: snapshot.key)
                completion(newNotification)
            }
        })
    }
}
