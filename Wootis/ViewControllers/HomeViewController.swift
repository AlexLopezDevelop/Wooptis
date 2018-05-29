//
//  HomeViewController.swift
//  Wootis
//
//  Created by Alex Lopez on 18/2/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var posts = [Post]()
    var users = [Users]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        loadPosts()
    }
    
    func loadPosts() {
        loadingIndicator.startAnimating()
        Api.Post.observePosts { (post) in
            guard let postId = post.userId else {
                return
            }
            self.fetchUser(userId: postId, completed: {
                self.posts.append(post)
                self.loadingIndicator.stopAnimating()
                self.tableView.reloadData() //Refresh table data
            })
        }
    }
    
    func fetchUser(userId: String, completed: @escaping () -> Void) {
        Api.User.observeUsers(withId: userId, completion: { user in
            self.users.append(user)
            completed()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentSegue" {
            let commentViewController = segue.destination as! CommentViewController
            let postId = sender as! String
            commentViewController.postId = postId
        }
    }
    
}

//Send info to table
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.homeViewController = self
        return cell
    }
}
