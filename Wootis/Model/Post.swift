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
    var photoOneUrl: String?
    var photoTwoUrl: String?
}

extension Post {
    static func customPhotoPost(path: [String: Any]) -> Post {
        let post = Post()
        post.comment = path["comment"] as? String
        post.photoOneUrl = path["photoOneUrl"] as? String
        post.photoTwoUrl = path["photoTwoUrl"] as? String
        return post
    }
    
    //static func customVideoPost(path: [String: Any]) -> Post {
        
    //}
}
