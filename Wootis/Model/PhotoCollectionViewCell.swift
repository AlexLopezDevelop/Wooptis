//
//  PhotoCollectionViewCell.swift
//  Wootis
//
//  Created by qwerty on 29/5/18.
//  Copyright © 2018 Wootis.inc. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var postImageOne: UIImageView!
    @IBOutlet weak var postImageTwo: UIImageView!
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
    }
    
}
