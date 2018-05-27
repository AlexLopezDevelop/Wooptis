//
//  PostApi.swift
//  Wootis
//
//  Created by Alex Lopez on 27/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostApi {
    var REF_POSTS = Database.database().reference().child("posts")
    func observePosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let path = snapshot.value as? [String: Any] { //[String: Any] != nil
                let newPost = Post.customPhotoPost(path: path, key: snapshot.key)
                completion(newPost)
            }
        }
    }
}
