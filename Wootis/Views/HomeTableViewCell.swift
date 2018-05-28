//
//  HomeTableViewCell.swift
//  Wootis
//
//  Created by Alex Lopez on 20/4/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var postImageOne: UIImageView!
    @IBOutlet weak var imageOneTitle: UILabel!
    @IBOutlet weak var postImageTwo: UIImageView!
    @IBOutlet weak var imageTwoTitle: UILabel!
    @IBOutlet weak var VoteOneView: UIImageView!
    @IBOutlet weak var VoteTwoView: UIImageView!
    @IBOutlet weak var CommentsView: UIImageView!
    @IBOutlet weak var shareView: UIImageView!
    @IBOutlet weak var votesAccounts: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    var homeViewController: HomeViewController?
    
    var post: Post? {
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
        commentLabel.text = post?.comment
        imageOneTitle.text = post?.photoOneTitle
        imageTwoTitle.text = post?.photoTwoTtitle
        if let photoOneImageString = post?.photoOneUrl {
            let photoOneUrl = URL(string: photoOneImageString)
            postImageOne.sd_setImage(with: photoOneUrl)
        }
        
        if let photoTwoImageString = post?.photoTwoUrl {
            let photoTwoUrl = URL(string: photoTwoImageString)
            postImageTwo.sd_setImage(with: photoTwoUrl)
        } else {
            postImageTwo.image = UIImage(named: "post-test")
        }
        
        if let currentUser = Auth.auth().currentUser {
            Api.User.REF_USERS.child((currentUser.uid)).child("votes").child((post?.postId)!).observeSingleEvent(of: .value, with: { snapshot in
                if let _ = snapshot.value as? NSNull {
                    self.VoteOneView.image = UIImage(named: "vote")
                } else {
                    if snapshot.value as! String == "first"{
                        self.VoteOneView.image = UIImage(named: "voted")
                    } else {
                        self.VoteTwoView.image = UIImage(named: "voted")
                    }
                }
            })
        }
    }
    
    func userInfo() {
        Username.text = user?.username
        if let profileImageString = user?.profileImageUrl {
            let profileImageUrl = URL(string: profileImageString)
            profileImageView.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "default-img-profile"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Username.text = ""
        commentLabel.text = ""
        let TapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentsView_Touch))
        CommentsView.addGestureRecognizer(TapGesture)
        CommentsView.isUserInteractionEnabled = true
        
        let TapGestureVoteOne = UITapGestureRecognizer(target: self, action: #selector(self.VoteOneView_Touch))
        VoteOneView.addGestureRecognizer(TapGestureVoteOne)
        VoteOneView.isUserInteractionEnabled = true
        
        let TapGestureVoteTwo = UITapGestureRecognizer(target: self, action: #selector(self.VoteTwoView_Touch))
        VoteTwoView.addGestureRecognizer(TapGestureVoteTwo)
        VoteTwoView.isUserInteractionEnabled = true
    }
    
    @objc func commentsView_Touch() {
        if let id = post?.postId {
            homeViewController?.performSegue(withIdentifier: "CommentSegue", sender: id)
        }
    }
    
    @objc func VoteOneView_Touch() {
        if let currentUser = Auth.auth().currentUser {
            Api.User.REF_USERS.child((currentUser.uid)).child("votes").child((post?.postId)!).observeSingleEvent(of: .value, with: { snapshot in
                if let _ = snapshot.value as? NSNull {
                    Api.User.REF_USERS.child(currentUser.uid).child("votes").child(self.post!.postId!).setValue("first")
                    self.VoteOneView.image = UIImage(named: "voted")
                } else {
                    Api.User.REF_USERS.child(currentUser.uid).child("votes").child(self.post!.postId!).removeValue()
                    if self.VoteTwoView.image == UIImage(named: "voted"){
                        self.VoteTwoView.image = UIImage(named: "vote")
                    }
                    self.VoteOneView.image = UIImage(named: "vote")
                }
            })
        }
    }
    
    @objc func VoteTwoView_Touch() {
        if let currentUser = Auth.auth().currentUser {
            Api.User.REF_USERS.child((currentUser.uid)).child("votes").child((post?.postId)!).observeSingleEvent(of: .value, with: { snapshot in
                if let _ = snapshot.value as? NSNull {
                    Api.User.REF_USERS.child(currentUser.uid).child("votes").child(self.post!.postId!).setValue("second")
                    self.VoteTwoView.image = UIImage(named: "voted")
                } else {
                    Api.User.REF_USERS.child(currentUser.uid).child("votes").child(self.post!.postId!).removeValue()
                    if self.VoteOneView.image == UIImage(named: "voted"){
                        self.VoteOneView.image = UIImage(named: "vote")
                    }
                    self.VoteTwoView.image = UIImage(named: "vote")
                }
            })
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "default-img-profile")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
