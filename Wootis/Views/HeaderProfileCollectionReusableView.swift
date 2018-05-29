//
//  HeaderProfileCollectionReusableView.swift
//  Wootis
//
//  Created by qwerty on 29/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var myPostsCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    
    var user: Users? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
            self.username.text = user!.username
            if let profileImage = user!.profileImageUrl {
                let profileImageUrl = URL(string: profileImage)
                self.profileImage.sd_setImage(with: profileImageUrl)
            }
    }
}
