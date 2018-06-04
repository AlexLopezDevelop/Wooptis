//
//  CommentTableViewCell.swift
//  Wootis
//
//  Created by Alex Lopez on 25/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit
import KILabel

protocol CommentTableViewCellDelegate {
    func goToProfileUserViewController(userId: String)
    func goToHastag(tag: String)
}

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var commentText: KILabel!
    
    var delegate: CommentTableViewCellDelegate?
    
    var comment: Comment? {
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
        commentText.text = comment?.commentText
        commentText.hashtagLinkTapHandler = { label, string, range in //Hastag
            let tag = String(string.dropFirst())
            self.delegate?.goToHastag(tag: tag)
        }
        commentText.userHandleLinkTapHandler = { label, string, range in // User mention
            let mention = String(string.dropFirst())
            Api.User.observUserByUsername(username: mention.lowercased(), completion: { (user) in
                self.delegate?.goToProfileUserViewController(userId: user.id!)
            })
        }
    }
    
    func userInfo() {
        profileUsername.text = user?.username
        if let profileImageString = user?.profileImageUrl {
            let profileImageUrl = URL(string: profileImageString)
            profileImage.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "default-img-profile"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileUsername.text = ""
        commentText.text = ""
        
        let TapGestureUsername = UITapGestureRecognizer(target: self, action: #selector(self.username_Touch))
        profileUsername.addGestureRecognizer(TapGestureUsername)
        profileUsername.isUserInteractionEnabled = true
    }
    
    @objc func username_Touch() {
        if let id = user?.id{
            delegate?.goToProfileUserViewController(userId: id)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = UIImage(named: "default-img-profile")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
