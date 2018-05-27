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
}
