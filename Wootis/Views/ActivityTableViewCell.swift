//
//  ActivityTableViewCell.swift
//  Wootis
//
//  Created by Alex Lopez on 3/6/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit

protocol ActivityTableViewCellDelegate {
    func goToDetailViewController(postId: String)
    //func goToProfileViewController(userId: String)
}

class ActivityTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var photo2: UIImageView!
    
    var delegate: ActivityTableViewCellDelegate?
    
    var notification: Notification? {
        didSet {
            refreshData()
        }
    }
    
    var user: Users? {
        didSet {
            userInfo()
        }
    }
    
    func refreshData() {
        switch notification!.type! {
        case "feed":
            descriptionLabel.text = "added a new post"
            let postId = notification!.objectId!
            Api.Post.observePost(with: postId) { (post) in
                if let profileImageString = post.photoOneUrl {
                    let profileImageUrl = URL(string: profileImageString)
                    self.photo.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "default-img-profile"))
                }
                if let profileImageString = post.photoTwoUrl {
                    let profileImageUrl = URL(string: profileImageString)
                    self.photo2.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "default-img-profile"))
                }
            }
        default:
            print("")
        }
        if let timestamp = notification?.timestamp {
            let timestampDate = Date(timeIntervalSince1970: Double(timestamp))
            let now = Date()
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
            let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
            var timeText = ""
            if diff.second! <= 0 {
                timeText = "Now"
            }
            if diff.second! > 0 && diff.minute! == 0 {
                timeText = "\(diff.second!)s"
            }
            if diff.minute! > 0 && diff.hour! == 0 {
                timeText = "\(diff.minute!)m"
            }
            if diff.hour! > 0 && diff.day! == 0 {
                timeText = "\(diff.hour!)h"
            }
            if diff.day! > 0 && diff.weekOfMonth! == 0 {
                timeText = "\(diff.day!)d"
            }
            if diff.weekOfMonth! > 0 {
                timeText = "\(diff.weekOfMonth!)2"
            }
            
            timeLabel.text = timeText
        }
        
        let TapGestureForPost = UITapGestureRecognizer(target: self, action: #selector(self.cell_Touch))
        addGestureRecognizer(TapGestureForPost)
        isUserInteractionEnabled = true
    }
    
    @objc func cell_Touch() {
        if let id = notification?.objectId {
            delegate?.goToDetailViewController(postId: id)
        }
    }
    
    func userInfo() {
        usernameLabel.text = user?.username
        if let profileImageString = user?.profileImageUrl {
            let profileImageUrl = URL(string: profileImageString)
            profileImage.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "default-img-profile"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
