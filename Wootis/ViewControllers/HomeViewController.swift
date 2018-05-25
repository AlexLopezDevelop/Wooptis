//
//  HomeViewController.swift
//  Wootis
//
//  Created by Alex Lopez on 18/2/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit
import FirebaseDatabase
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
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let path = snapshot.value as? [String: Any] { //[String: Any] != nil
                let newPost = Post.customPhotoPost(path: path)
                self.fetchUser(userId: newPost.userId!, completed: {
                    self.posts.append(newPost)
                    self.loadingIndicator.stopAnimating()
                    self.tableView.reloadData() //Refresh table data
                })
            }
        }
    }
    
    func fetchUser(userId: String, completed: @escaping () -> Void) {
        Database.database().reference().child("users").child(userId).observeSingleEvent(of: DataEventType.value, with: { snapshot in
            if let path = snapshot.value as? [String: Any] {
                let user = Users.transformUser(path: path)
                self.users.append(user)
                completed()
            }
        })
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
        return cell
    }
}
