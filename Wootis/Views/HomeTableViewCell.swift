//
//  HomeTableViewCell.swift
//  Wootis
//
//  Created by Alex Lopez on 20/4/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var postImageOne: UIImageView!
    @IBOutlet weak var VoteOneView: UIImageView!
    @IBOutlet weak var CommentsView: UIImageView!
    @IBOutlet weak var shareView: UIImageView!
    @IBOutlet weak var votesAccounts: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refreshData(post: Post) {
        commentLabel.text = post.comment
        profileImageView.image = UIImage(named: "profile-test")
        Username.text = "Michael"
        if let photoImageString = post.photoOneUrl {
            let photoUrl = URL(string: photoImageString)
            postImageOne.sd_setImage(with: photoUrl)
        }
    }

}
