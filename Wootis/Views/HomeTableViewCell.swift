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
import KILabel

protocol HomeTableViewCellDelegate {
    func goToCommentViewController(postId: String)
    func goToProfileUserViewController(userId: String)
    func goToHastag(tag: String)
}

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
    @IBOutlet weak var commentLabel: KILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var delegate: HomeTableViewCellDelegate?
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
        commentLabel.hashtagLinkTapHandler = { label, string, range in //Hastag
            let tag = String(string.dropFirst())
            self.delegate?.goToHastag(tag: tag)
        }
        commentLabel.userHandleLinkTapHandler = { label, string, range in // User mention
            let mention = String(string.dropFirst())
            Api.User.observUserByUsername(username: mention.lowercased(), completion: { (user) in
                self.delegate?.goToProfileUserViewController(userId: user.id!)
            })
        }
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
        
        if post?.postId != nil {
        Api.Post.REF_POSTS.child(post!.postId!).observeSingleEvent(of: .value, with: { snapshot in
            if let path = snapshot.value as? [String: Any] {
                let post = Post.customPhotoPost(path: path, key: snapshot.key)
                self.updateVote(post: post)
            }
        })
            
            if let timestamp = post?.timestamp {
                let timestampDate = Date(timeIntervalSince1970: Double(timestamp))
                let now = Date()
                let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
                let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
                var timeText = ""
                if diff.second! <= 0 {
                    timeText = "Now"
                }
                if diff.second! > 0 && diff.minute! == 0 {
                    timeText = (diff.second == 1) ? "\(diff.second!) second ago" : "\(diff.second!) seconds ago"
                }
                if diff.minute! > 0 && diff.hour! == 0 {
                    timeText = (diff.minute == 1) ? "\(diff.minute!) minute ago" : "\(diff.minute!) minutes ago"
                }
                if diff.hour! > 0 && diff.day! == 0 {
                    timeText = (diff.hour == 1) ? "\(diff.hour!) hour ago" : "\(diff.second!) hours ago"
                }
                if diff.day! > 0 && diff.weekOfMonth! == 0 {
                    timeText = (diff.day == 1) ? "\(diff.day!) day ago" : "\(diff.second!) days ago"
                }
                if diff.weekOfMonth! > 0 {
                    timeText = (diff.weekOfMonth == 1) ? "\(diff.weekOfMonth!) week ago" : "\(diff.weekOfMonth!) weeks ago"
                }
                
                timeLabel.text = timeText
            }
            
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

            if let value = snapshot.value as? Int {
                    self.votesFirstAccounts.setTitle("\(value) votes", for: UIControlState.normal)
            }
        })
        }
    }
    
    func updateVote(post: Post) {
        var dictionary: NSDictionary = [:]
        if post.votes != nil {
            dictionary = post.votes! as NSDictionary
        }
        let imageName = dictionary[Api.User.CURRENT_USER?.uid] == nil || !post.isVoted! ? "vote" : "voted"
        let imageNameOposite = imageName == "vote" ? "voted" : "vote"
        if dictionary[Api.User.CURRENT_USER?.uid] != nil {
            let photoVoted = dictionary[Api.User.CURRENT_USER?.uid] as! String
            if photoVoted == "first" {
                VoteOneView.image = UIImage(named: imageName)
                VoteTwoView.image = UIImage(named: imageNameOposite)
            } else if photoVoted == "second" {
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
        
        let TapGestureUsername = UITapGestureRecognizer(target: self, action: #selector(self.username_Touch))
        Username.addGestureRecognizer(TapGestureUsername)
        Username.isUserInteractionEnabled = true
    }
    
    @objc func username_Touch() {
        if let id = user?.id{
            delegate?.goToProfileUserViewController(userId: id)
        }
    }
    
    @objc func commentsView_Touch() {
        if let id = post?.postId {
            delegate?.goToCommentViewController(postId: id)
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
                var totalVotes = post["totalVotes"] as? Int ?? 0
                if let _ = votes[uid] {
                    // Unstar the post and remove self from stars
                    if votes[uid]!  == "first" {
                        votesCountFirst -= 1
                        post["votesCountFirst"] = votesCountFirst as AnyObject?
                    } else if votes[uid]! == "second"{
                        votesCountSecond -= 1
                        post["votesCountSecond"] = votesCountSecond as AnyObject?
                    }
                    totalVotes -= 1
                    post["totalVotes"] = totalVotes as AnyObject?
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
                    totalVotes += 1
                    post["totalVotes"] = totalVotes as AnyObject?
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
