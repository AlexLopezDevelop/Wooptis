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
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postImageTwo: UIImageView!
    @IBOutlet weak var VoteOneView: UIImageView!
    @IBOutlet weak var VoteTwoView: UIImageView!
    @IBOutlet weak var CommentsView: UIImageView!
    @IBOutlet weak var shareView: UIImageView!
    @IBOutlet weak var votesAccounts: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    var homeViewController: HomeViewController?
    var postRef: DatabaseReference!
    
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
        postTitle.text = post?.postTitle
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
        
        updateVote(post: post!)
        Api.Post.REF_POSTS.child(post!.postId!).observe(.childChanged, with: { snapshot in
            if let value = snapshot.value as? Int {
                self.votesAccounts.setTitle("\(value) votes", for: UIControlState.normal)
            }
        })
        /*if let currentUser = Auth.auth().currentUser {
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
        }*/
    }
    
    func updateVote(post: Post) {
        let imageName = post.votes == nil || !post.isVoted! ? "vote" : "voted"
        VoteOneView.image = UIImage(named: imageName)
        guard let count = post.voteCount else {
            return
        }
        if count != 0 {
            votesAccounts.setTitle("\(count) votes", for: UIControlState.normal)
        } else {
            votesAccounts.setTitle("Do the first vote this", for: UIControlState.normal)
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
        
        /*let TapGestureVoteTwo = UITapGestureRecognizer(target: self, action: #selector(self.VoteTwoView_Touch))
        VoteTwoView.addGestureRecognizer(TapGestureVoteTwo)
        VoteTwoView.isUserInteractionEnabled = true*/
    }
    
    @objc func commentsView_Touch() {
        if let id = post?.postId {
            homeViewController?.performSegue(withIdentifier: "CommentSegue", sender: id)
        }
    }
    
    @objc func VoteOneView_Touch() {
        postRef = Api.Post.REF_POSTS.child(post!.postId!)
        incrementVotes(forRef: postRef)
        /*if let currentUser = Auth.auth().currentUser {
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
        }*/
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
    
    func incrementVotes(forRef ref: DatabaseReference) { //Firebase Transactions
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                var votes: Dictionary<String, Bool>
                votes = post["votes"] as? [String : Bool] ?? [:]
                var votesCount = post["votesCount"] as? Int ?? 0
                if let _ = votes[uid] {
                    // Unstar the post and remove self from stars
                    votesCount -= 1
                    votes.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to stars
                    votesCount += 1
                    votes[uid] = true
                }
                post["votesCount"] = votesCount as AnyObject?
                post["votes"] = votes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let path = snapshot?.value as? [String: Any] {
                let post = Post.customPhotoPost(path: path, key: snapshot!.key)
                self.updateVote(post: post)
            }
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
