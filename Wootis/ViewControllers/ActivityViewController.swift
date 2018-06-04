//
//  ActivityViewController.swift
//  Wootis
//
//  Created by Alex Lopez on 3/6/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var notifications = [Notification]()
    var users = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotifications()
    }
    
    func loadNotifications() {
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        Api.Notification.observeNotification(withId: currentUser.uid, completion: { notification in
            guard let uid = notification.form else {
                return
            }
            self.fetchUser(userId: uid, completed: {
                self.notifications.insert(notification, at: 0)
                self.tableView.reloadData()
            })
        })
    }
    
    func fetchUser(userId: String, completed: @escaping () -> Void) {
        Api.User.observeUsers(withId: userId, completion: { user in
            self.users.insert(user, at: 0)
            completed()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Activity_DetailSegue" {
            let DetailPostViewController = segue.destination as! DetailPostViewController
            let postId = sender as! String
            DetailPostViewController.postId = postId
        }
    }
}

extension ActivityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        let notification = notifications[indexPath.row]
        let user = users[indexPath.row]
        cell.notification = notification
        cell.user = user
        cell.delegate = self
        return cell
    }
}

extension ActivityViewController: ActivityTableViewCellDelegate {
    func goToDetailViewController(postId: String) {
        performSegue(withIdentifier: "Activity_DetailSegue", sender: postId)
    }
}
