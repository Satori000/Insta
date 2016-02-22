//
//  PostCell.swift
//  Insta
//
//  Created by Shakeeb Majid on 2/17/16.
//  Copyright © 2016 Shakeeb Majid. All rights reserved.
//

import UIKit
import Parse

class PostCell: UITableViewCell {
    
    @IBOutlet weak var usernameButton: UIButton!
    
    
    @IBOutlet weak var usernameLabel2: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var picturePostView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    
    var post: PFObject?
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onComment(sender: AnyObject) {
        
        if let object = post {
            let id = object["id"] as! String
            var query = PFQuery(className:"UserMedia")
            query.getObjectInBackgroundWithId("id") {
                (media: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else if let media = media {
                    media["comment"] = "hey i like to comment things and here it is"
                    media.saveInBackground()
                }
            }
        }
    }
    
    @IBAction func onLike(sender: AnyObject) {
        UserMedia.likePicture(post)
        
     let newLikesCount = post!["likesCount"] as! Int
    self.likeCountLabel.text = "\(newLikesCount)"
        
    }
    
    

}
