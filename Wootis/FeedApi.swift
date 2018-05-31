//
//  FeedApi.swift
//  Wootis
//
//  Created by Alex Lopez on 30/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FeedApi {
    var REF_FEED = Database.database().reference().child("feed")
    
    func observeFeed(withId id: String, completion: @escaping (Post) -> Void) {
        REF_FEED.child(id).observe(.childAdded, with: { snapshot in
            let key = snapshot.key
            Api.Post.observePost(with: key, completion: { (post) in
                completion(post)
            })
        })
    }
    
    func observeFeedRemove(withId id: String, completion: @escaping (Post) -> Void) {
        REF_FEED.child(id).observe(.childRemoved, with: { snapshot in
            let key = snapshot.key
            Api.Post.observePost(with: key, completion: { (post) in
                completion(post)
            })
        })
    }
    
}
