//
//  Post_CommentApi.swift
//  Wootis
//
//  Created by Alex Lopez on 27/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Post_CommentApi {
    var REF_POSTS_COMMENTS = Database.database().reference().child("post-comment")
    
//        func observeComments(withPostId id: String, completion: @escaping (Comment) -> Void) {
//            REF_COMMENTS.child(id).observeSingleEvent(of: .value, with: {
//                snapshot in
//                if let dict = snapshot.value as? [String: Any] {
//                    let newComment = Comment.transformComment(dict: dict)
//                    completion(newComment)
//                }
//            })
//        }
}
