//
//  Comment.swift
//  Wootis
//
//  Created by Alex Lopez on 27/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
class Comment {
    var commentText: String?
    var userId: String?
}

extension Comment {
    static func customPhotoComment(path: [String: Any]) -> Comment {
        let comment = Comment()
        comment.commentText = path["comment"] as? String
        comment.userId = path["userID"] as? String
        return comment
    }
}
