//
//  FollowApi.swift
//  Wootis
//
//  Created by Alex Lopez on 30/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
import  FirebaseDatabase

class FollowApi {
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    var REF_FOLLOWING = Database.database().reference().child("following")
    
    func followAction(withUser id: String) {
        Api.MyPost.REF_MY_POSTS.child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let path = snapshot.value as? [String: Any] {
                for key in path.keys {
                    Database.database().reference().child("feed").child(Api.User.CURRENT_USER!.uid).child(key).setValue(true)
                }
            }
        })
        REF_FOLLOWERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(true)
        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    func unfollowAction(withUser id: String) {
        
        Api.MyPost.REF_MY_POSTS.child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let path = snapshot.value as? [String: Any] {
                for key in path.keys {
                    Database.database().reference().child("feed").child(Api.User.CURRENT_USER!.uid).child(key).removeValue()
                }
            }
        })
        
        REF_FOLLOWERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(NSNull())
        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        REF_FOLLOWERS.child(userId).child(Api.User.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: { snapshot in
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else {
                completed(true)
            }
        })
    }
    
    func fetchCountFollowing(userId: String, completed: @escaping (Int) -> Void) {
        REF_FOLLOWING.child(userId).observe(.value, with: { snapshot in
            let count = Int(snapshot.childrenCount)
            completed(count)
        })
    }
    
    func fetchCountFollowers(userId: String, completed: @escaping (Int) -> Void) {
        REF_FOLLOWERS.child(userId).observe(.value, with: { snapshot in
            let count = Int(snapshot.childrenCount)
            completed(count)
        })
    }
}
