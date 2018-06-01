//
//  PhotoCollectionViewCell.swift
//  Wootis
//
//  Created by qwerty on 29/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit
protocol PhotoCollectionViewCellDelegate {
    func goToDetailPostViewController(postId: String)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var postImageOne: UIImageView!
    @IBOutlet weak var postImageTwo: UIImageView!
    
    var delegate: PhotoCollectionViewCellDelegate?
    
    var post: Post? {
        didSet{
            updateView()
        }
    }
    
    func updateView() {
        if let photoOneImageString = post?.photoOneUrl {
            let photoOneUrl = URL(string: photoOneImageString)
            postImageOne.sd_setImage(with: photoOneUrl)
        }
        if let photoTwoImageString = post?.photoTwoUrl {
            let photoTwoUrl = URL(string: photoTwoImageString)
            postImageTwo.sd_setImage(with: photoTwoUrl)
        }
        let TapGestureForPost = UITapGestureRecognizer(target: self, action: #selector(self.post_Touch))
        postImageOne.addGestureRecognizer(TapGestureForPost)
        postImageOne.isUserInteractionEnabled = true
        postImageOne.addGestureRecognizer(TapGestureForPost)
        postImageOne.isUserInteractionEnabled = true
    }
    
    @objc func post_Touch() {
        if let id = post?.postId {
            delegate?.goToDetailPostViewController(postId: id)
        }
    }
    
}
