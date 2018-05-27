//
//  CommentApi.swift
//  Wootis
//
//  Created by Alex Lopez on 27/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentApi {
    var REF_COMMENTS = Database.database().reference().child("comments")
    
    func observeComments(withPostId id: String, completion: @escaping (Comment) -> Void) {
        REF_COMMENTS.child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let path = snapshot.value as? [String: Any] { //[String: Any] != nil
                let newComment = Comment.customPhotoComment(path: path)
                completion(newComment)
            }
        })
    }
}
