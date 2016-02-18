//
//  InstaFeedViewController.swift
//  Insta
//
//  Created by Shakeeb Majid on 2/17/16.
//  Copyright © 2016 Shakeeb Majid. All rights reserved.
//

import UIKit
import Parse

class InstaFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var feed: [PFObject]?
    
    @IBOutlet weak var tableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tabBarItem.title = "Feed"
        print("hello view did load")
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.Camera
        // Do any additional setup after loading the view.
        let query = PFQuery(className: "UserMedia")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                
                self.feed = media
                self.tableView.reloadData()
                print(self.feed!)
                // do something with the data fetched
            } else {
                // handle error
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var onSignout: UIButton!
    
    @IBAction func onSignout(sender: AnyObject) {
        PFUser.logOut()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let feed = feed {
            print(self.feed!.count)
            
            return self.feed!.count
            
        } else {
            print("0")
            return 0
        }
    
        
    }
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
        
        let post = self.feed![indexPath.row]
        
        let pictureFile = post["media"] as! PFFile
        let caption = post["caption"] as! String
        pictureFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    cell.picturePostView.image = image
                }
            }
            
        }

        cell.captionLabel.text = caption
        
        
        
        
        
        
        return cell
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
