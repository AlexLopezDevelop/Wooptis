//
//  HastagApi.swift
//  Wootis
//
//  Created by Alex Lopez on 2/6/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import Foundation
import FirebaseDatabase

class HastagApi {
    var REF_HASTAG = Database.database().reference().child("hastag")
    
    func fetchPosts(sithTag tag: String, completion: @escaping (String) -> Void) {
        REF_HASTAG.child(tag.lowercased()).observe(.childAdded, with: { snapshot in
            completion(snapshot.key)
        })
    }
    
}
