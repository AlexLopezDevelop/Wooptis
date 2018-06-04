//
//  DetailPostViewController.swift
//  Wootis
//
//  Created by Alex Lopez on 1/6/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit

class DetailPostViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var postId = ""
    var post = Post()
    var user = Users()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPosts()
    }
    
    func loadPosts() {
        Api.Post.observePost(with: postId) { (post) in
            guard let postId = post.userId else {
                return
            }
            self.fetchUser(userId: postId, completed: {
                self.post = post
                self.tableView.reloadData()
            })
        }
    }
    
    func fetchUser(userId: String, completed: @escaping () -> Void) {
        Api.User.observeUsers(withId: userId, completion: { user in
            self.user = user
            completed()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail_CommentSegue" {
            let commentViewController = segue.destination as! CommentViewController
            let postId = sender as! String
            commentViewController.postId = postId
        }
        
        if segue.identifier == "Detail_ProfileUserSegue" {
            let profileViewController = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileViewController.userId = userId
        }
        
        if segue.identifier == "Detail_HastagSegue" {
            let hastagViewController = segue.destination as! HastagViewController
            let tag = sender as! String
            hastagViewController.tag = tag
        }
    }
}

extension DetailPostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
    }
}

extension DetailPostViewController:  HomeTableViewCellDelegate {
    func goToHastag(tag: String) {
        performSegue(withIdentifier: "Detail_HastagSegue", sender: tag)
    }
    
    func goToCommentViewController(postId: String) {
        performSegue(withIdentifier: "Detail_CommentSegue", sender: postId)
    }
    
    func goToProfileUserViewController(userId: String) {
        performSegue(withIdentifier: "Detail_ProfileUserSegue", sender: userId)
    }
}

