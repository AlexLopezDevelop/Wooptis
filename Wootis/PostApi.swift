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
    
    func observeTopPosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "totalVotes").observeSingleEvent(of: .value, with: { snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (child) in
                if let path = child.value as? [String: Any] {
                    let newPost = Post.customPhotoPost(path: path, key: snapshot.key)
                    completion(newPost)
                }
            })
        })
    }
    
    func observePost(with id: String, completion: @escaping (Post) -> Void) {
        REF_POSTS.child(id).observeSingleEvent(of: DataEventType.value, with: { snapshot in
            if let path = snapshot.value as? [String: Any] {
                let post = Post.customPhotoPost(path: path, key: snapshot.key)
                completion(post)
            }
        })
    }
}
