//
//  Post.swift
//  Wootis
//
//  Created by Alex Lopez on 17/4/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
import FirebaseAuth

class Post {
    var userId: String?
    var postId: String?
    var comment: String?
    var photoOneUrl: String?
    var photoTwoUrl: String?
    var postTitle: String?
    var voteFirstCount: Int?
    var voteSecondCount: Int?
    var totalVotes: Int?
    var votes: Dictionary<String, Any>?
    var isVoted: Bool?
}

extension Post {
    static func customPhotoPost(path: [String: Any], key: String) -> Post {
        let post = Post()
        post.postId = key
        post.userId = path["userID"] as? String
        post.comment = path["comment"] as? String
        post.photoOneUrl = path["photoOneUrl"] as? String
        post.photoTwoUrl = path["photoTwoUrl"] as? String
        post.postTitle = path["Title"] as? String
        post.voteFirstCount = path["votesCountFirst"] as? Int
        post.voteSecondCount = path["votesCountSecond"] as? Int
        post.totalVotes = path["totalVotes"] as? Int
        post.votes = path["votes"] as? Dictionary<String, Any>
        if let currentUserId = Auth.auth().currentUser?.uid {
            if post.votes != nil {
                post.isVoted = post.votes![currentUserId] != nil
            }
        }
        return post
    }
    
    //static func customVideoPost(path: [String: Any]) -> Post {
        
    //}
}
