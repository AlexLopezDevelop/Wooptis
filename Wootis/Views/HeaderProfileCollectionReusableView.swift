//
//  HeaderProfileCollectionReusableView.swift
//  Wootis
//
//  Created by qwerty on 29/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit
protocol HeaderProfileCollectionReusableViewDelegate {
    func updateFollowButton(forUser user: Users)
}

protocol HeaderProfileCollectionReusableViewDelegateSwitchViewController {
    func goToSettingViewController()
}

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var myPostsCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var followButton: UIBotones!
    
    var delegate: HeaderProfileCollectionReusableViewDelegate?
    var delegate2: HeaderProfileCollectionReusableViewDelegateSwitchViewController?
    
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
        
        Api.MyPost.fetchCountMyPosts(userId: user!.id!) { (count) in
            self.myPostsCount.text = "\(count)"
        }
        
        Api.Follow.fetchCountFollowing(userId: user!.id!) { (count) in
            self.followingCount.text = "\(count)"
        }
        
        Api.Follow.fetchCountFollowers(userId: user!.id!) { (count) in
            self.followerCount.text = "\(count)"
        }
        
        if user?.id == Api.User.CURRENT_USER?.uid {
            followButton.setTitle("Edit Profile", for: UIControlState.normal)
            followButton.addTarget(self, action: #selector(self.goToSettingViewController), for: UIControlEvents.touchUpInside)
        } else {
            updateStateFollowButton()
        }
    }
    
    @objc func goToSettingViewController() {
        delegate2?.goToSettingViewController()
    }
    
    func updateStateFollowButton() {
        if user!.isFollowing! {
            configureUnfollowButton()
        } else {
            configureFollowButton()
        }
    }
    
    func configureFollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        followButton.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        followButton.setTitle("Follow", for: UIControlState.normal)
        followButton.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
    }
    
    func configureUnfollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        followButton.backgroundColor = UIColor.clear
        self.followButton.setTitle("Following", for: UIControlState.normal)
        followButton.addTarget(self, action: #selector(self.unfollowAction), for: UIControlEvents.touchUpInside)
    }
    
    @objc func followAction() {
        if user!.isFollowing == false {
            Api.Follow.followAction(withUser: user!.id!)
            configureUnfollowButton()
            user!.isFollowing! = true
            delegate?.updateFollowButton(forUser: user!)
        }
    }
    
    @objc func unfollowAction() {
        if user!.isFollowing == true {
            Api.Follow.unfollowAction(withUser: user!.id!)
            configureFollowButton()
            user!.isFollowing! = false
            delegate?.updateFollowButton(forUser: user!)
        }
    }
}
