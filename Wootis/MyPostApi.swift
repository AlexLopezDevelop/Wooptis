//
//  MyPostApi.swift
//  Wootis
//
//  Created by qwerty on 29/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MyPostsApi {
    var REF_MY_POSTS = Database.database().reference().child("myPosts")
}
