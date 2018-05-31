//
//  MyPostApi.swift
//  Wootis
//
//  Created by qwerty on 29/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MyPostsApi {
    var REF_MY_POSTS = Database.database().reference().child("myPosts")
    
    func fetchMyPosts(userId: String, completion: @escaping (String) -> Void) {
        REF_MY_POSTS.child(userId).observe(.childAdded, with: { snapshot in
            completion(snapshot.key)
        })
    }
    
    func fetchCountMyPosts(userId: String, completion: @escaping (Int) -> Void) {
        REF_MY_POSTS.child(userId).observe(.value, with: {snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
}
