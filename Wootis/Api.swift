//
//  Api.swift
//  Wootis
//
//  Created by Alex Lopez on 27/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation

struct Api {
    static var User = UserApi()
    static var Post = PostApi()
    static var Comment = CommentApi()
    static var Post_Comment = Post_CommentApi()
    static var MyPost = MyPostsApi()
    static var Follow = FollowApi()
    static var Feed = FeedApi()
}
