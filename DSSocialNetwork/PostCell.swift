//
//  PostCell.swift
//  DSSocialNetwork
//
//  Created by Zack Falgout on 6/9/17.
//  Copyright © 2017 Zack Falgout. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post) {
        self.post = post
        self.caption.text = post.caption
        self.likesLabel.text = "\(post.likes)"
    }

}
