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
    @IBOutlet weak var votesFirstAccounts: UIButton!
    @IBOutlet weak var votesSecondAccounts: UIButton!
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
        
        Api.Post.REF_POSTS.child(post!.postId!).observeSingleEvent(of: .value, with: { snapshot in
            if let path = snapshot.value as? [String: Any] {
                let post = Post.customPhotoPost(path: path, key: snapshot.key)
                self.updateVote(post: post)
            }
        })
        updateVote(post: post!)
        Api.Post.REF_POSTS.child(post!.postId!).observe(.value, with: { snapshot in
            
            if let path = snapshot.value as? [String: Any] {
                if path["votesCountFirst"] != nil && path["votesCountSecond"] != nil {
                    let votesFirst = path["votesCountFirst"] as! Int
                    let votesSecond = path["votesCountSecond"] as! Int
                    if votesFirst != 0 {
                        self.votesFirstAccounts.setTitle("\(votesFirst) votes", for: UIControlState.normal)
                    } else {
                        self.votesFirstAccounts.setTitle("Vote First!", for: UIControlState.normal)
                    }
                    if votesSecond != 0 {
                        self.votesSecondAccounts.setTitle("\(votesSecond) votes", for: UIControlState.normal)
                    } else {
                        self.votesSecondAccounts.setTitle("Vote First!", for: UIControlState.normal)
                    }
                }
            }
            /*if let path = snapshot.value as? [String: Any] {
                
                print(path["Zeb5SESTeRQv4vZusvF5pLuIIuj1"] as! String)
            }*/
            
       

            if let value = snapshot.value as? Int {
                    self.votesFirstAccounts.setTitle("\(value) votes", for: UIControlState.normal)
            }
        })
    }
    
    func updateVote(post: Post) {
        let imageName = post.votes == nil || !post.isVoted! ? "vote" : "voted"
        let imageNameOposite = imageName == "vote" ? "voted" : "vote"
        if post.votes?.values.description != nil {
            let photoVoted = post.votes?.values.description
            if photoVoted == "[first]" {
                VoteOneView.image = UIImage(named: imageName)
                VoteTwoView.image = UIImage(named: imageNameOposite)
            } else if photoVoted == "[second]" {
                VoteTwoView.image = UIImage(named: imageName)
                VoteOneView.image = UIImage(named: imageNameOposite)
            }
        } else {
            VoteTwoView.image = UIImage(named: imageName)
            VoteOneView.image = UIImage(named: imageName)
        }
        
        if post.voteFirstCount != nil {
            let count = post.voteFirstCount
            if count != 0 {
                votesFirstAccounts.setTitle("\(count!) votes", for: UIControlState.normal)
            } else {
                votesFirstAccounts.setTitle("Vote First!", for: UIControlState.normal)
            }
        }
        
        if post.voteSecondCount != nil {
            let count = post.voteSecondCount
            if count != 0 {
                votesSecondAccounts.setTitle("\(count!) votes", for: UIControlState.normal)
            } else {
                votesSecondAccounts.setTitle("Vote First!", for: UIControlState.normal)
            }
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
        postRef = Api.Post.REF_POSTS.child(post!.postId!)
        incrementVotes(forRef: postRef, photoVoted: "first")
    }
    
    @objc func VoteTwoView_Touch() {
        postRef = Api.Post.REF_POSTS.child(post!.postId!)
        incrementVotes(forRef: postRef, photoVoted: "second")
    }
    
    func incrementVotes(forRef ref: DatabaseReference, photoVoted: String) { //Firebase Transactions
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                var votes: Dictionary<String, String>
                votes = post["votes"] as? [String : String] ?? [:]
                var votesCountFirst = post["votesCountFirst"] as? Int ?? 0
                var votesCountSecond = post["votesCountSecond"] as? Int ?? 0
                if let _ = votes[uid] {
                    // Unstar the post and remove self from stars
                    if votes[uid]!  == "first" {
                        votesCountFirst -= 1
                        post["votesCountFirst"] = votesCountFirst as AnyObject?
                    } else if votes[uid]! == "second"{
                        votesCountSecond -= 1
                        post["votesCountSecond"] = votesCountSecond as AnyObject?
                    }
                    votes.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to stars
                    if photoVoted == "first" {
                        votesCountFirst += 1
                        post["votesCountFirst"] = votesCountFirst as AnyObject?
                    } else if photoVoted == "second" {
                        votesCountSecond += 1
                        post["votesCountSecond"] = votesCountSecond as AnyObject?
                    }
                    
                    votes[uid] = photoVoted
                }
                
                
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
