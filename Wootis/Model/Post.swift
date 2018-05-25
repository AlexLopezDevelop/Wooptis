//
//  Post.swift
//  Wootis
//
//  Created by Alex Lopez on 17/4/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
class Post {
    var comment: String?
    var userId: String?
    var photoOneUrl: String?
    var photoTwoUrl: String?
    var photoOneTitle: String?
    var photoTwoTtitle: String?
}

extension Post {
    static func customPhotoPost(path: [String: Any]) -> Post {
        let post = Post()
        post.comment = path["comment"] as? String
        post.userId = path["userID"] as? String
        post.photoOneUrl = path["photoOneUrl"] as? String
        post.photoTwoUrl = path["photoTwoUrl"] as? String
        post.photoOneTitle = path["photoOneTitle"] as? String
        post.photoTwoTtitle = path["photoTwoTitle"] as? String
        return post
    }
    
    //static func customVideoPost(path: [String: Any]) -> Post {
        
    //}
}
