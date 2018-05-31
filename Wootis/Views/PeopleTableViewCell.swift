//
//  PeopleTableViewCell.swift
//  Wootis
//
//  Created by Alex Lopez on 30/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit

protocol PeopleTableViewCellDelegate {
    func goToProfileUserViewController(userId: String)
}

class PeopleTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var delegate: PeopleTableViewCellDelegate?
    var peopleViewController: PeopleViewController?
    var user: Users? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        username.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "default-img-profile"))
        }
        
        /*Api.Follow.isFollowing(userId: user!.id!) { (value) in
            if value {
                self.configureUnfollowButton()
            } else {
                self.configureFollowButton()
            }
        }*/
        
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
        }
        
    }
    
    @objc func unfollowAction() {
        if user!.isFollowing == true {
            Api.Follow.unfollowAction(withUser: user!.id!)
            configureFollowButton()
            user!.isFollowing! = false
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let TapGesture = UITapGestureRecognizer(target: self, action: #selector(self.username_Touch))
        username.addGestureRecognizer(TapGesture)
        username.isUserInteractionEnabled = true
    }
    
    @objc func username_Touch() {
        if let id = user?.id{
            delegate?.goToProfileUserViewController(userId: id)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
