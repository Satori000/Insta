//
//  CommentsViewController.swift
//  Insta
//
//  Created by Shakeeb Majid on 2/18/16.
//  Copyright © 2016 Shakeeb Majid. All rights reserved.
//

import UIKit
import Parse

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var usernameButton: UIButton!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var commentField: UITextField!
    
    var media: PFObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPostComment(sender: AnyObject) {
        let comment = "you should be able to see this comment"
        if let media = media {
            let id = media.objectId!
            var query = PFQuery(className:"UserMedia")
            query.getObjectInBackgroundWithId(id) {
                (media: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else if var comment = media!["comment"] as? [String] {
                    print("hey this should append")
                    comment.append(self.commentField.text!)
                    media!["comment"] = comment

                    media!.saveInBackground()
                } else {
                    let array = [self.commentField.text!] as! [String]
                    media!["comment"] = array
                    print("hello this should set")
                    media!.saveInBackground()
                }
                //print(media)
            }
            
            //print(media)
        
            
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
