//
//  HastagViewController.swift
//  Wootis
//
//  Created by Alex Lopez on 2/6/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit

class HastagViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [Post] = []
    var tag = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "#\(tag)"
        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadPosts()
    }
    
    func loadPosts() {
        Api.Hastag.fetchPosts(sithTag: tag) { (postId) in
            Api.Post.observePost(with: postId, completion: { (post) in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Hastag_DetailSegue" {
            let detailPostViewController = segue.destination as! DetailPostViewController
            let postId = sender as! String
            detailPostViewController.postId = postId
        }
        
    }
}

extension HastagViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        return cell
    }
}

extension HastagViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 1, height: collectionView.frame.size.width / 3 - 1)
    }
}

extension HastagViewController: PhotoCollectionViewCellDelegate {
    func goToDetailPostViewController(postId: String) {
        performSegue(withIdentifier: "Hastag_DetailSegue", sender: postId)
    }
}
