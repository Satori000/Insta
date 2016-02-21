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
    
    var commentPost: PFObject?
    @IBOutlet weak var tableView: UITableView!
    
    let CellIdentifier = "PostCell", HeaderViewIdentifier = "TableViewHeaderView"


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500

        //tableView.registerClass(PostCell.self, forCellReuseIdentifier: CellIdentifier)
        //tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        
        
        self.tabBarItem.title = "Feed"
        //print("hello view did load")
        let vc = UIImagePickerController()
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
                //print(self.feed!)
                // do something with the data fetched
            } else {
                // handle error
            }
            
        }
        
    }

  /*  override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        let query = PFQuery(className: "UserMedia")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        

        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                
                self.feed = media
                self.tableView.reloadData()
                //print(self.feed!)
                // do something with the data fetched
            } else {
                // handle error
            }
            
        }
    } */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignout(sender: AnyObject) {
        PFUser.logOut()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let feed = feed {
            //print(self.feed!.count)
            
            return feed.count
            
        } else {
            //print("0")
            return 0
        }
    
        
    }
    
    /////////////////////////////////////////
   /* func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let feed = feed {
            print(self.feed!.count)
            
            return feed.count
            
        } else {
            //print("0")
            return 0
        }

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("1")
        return 1
    }

    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderViewIdentifier)! as UITableViewHeaderFooterView
        
        print("hello")
        //header.textLabel!.text = "hello"
        return header
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //print("30")
        return 30
    } */
    
    ///////////////////////////////////////////
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
        
        let post = self.feed![indexPath.row]
        
        let pictureFile = post["media"] as! PFFile
        let caption = post["caption"] as! String
        //print(post)
        let user = post["author"] as! PFUser
        //print(user)
        
        let username = user.username!
        let date = post["time"] as! NSDate
        //print(date)
        
        let timeElapsed = Int(0 - date.timeIntervalSinceNow)
        //print(timeElapsed)
        
        let secondsInMinute = 60
        let secondsInHour = secondsInMinute * 60
        let secondsInDay = secondsInHour * 24
        let secondsInMonth = secondsInDay * 30
        let monthsElapsed = timeElapsed/secondsInMonth
        let daysElapsed = timeElapsed/secondsInDay
        let hoursElapsed = timeElapsed/secondsInHour
        let minutesElapsed = timeElapsed/secondsInMinute
        let secondsElapsed = timeElapsed
        var timeElapsedString: String?
        
        if monthsElapsed != 0 {
            timeElapsedString = "\(monthsElapsed)mon"
            
        } else if daysElapsed != 0 {
            timeElapsedString = "\(daysElapsed)d"
            
            
        } else if hoursElapsed != 0 {
            timeElapsedString = "\(hoursElapsed)h"
            
            
        } else if minutesElapsed != 0 {
            timeElapsedString = "\(minutesElapsed)m"
            
        } else {
            timeElapsedString = "\(secondsElapsed)s"
            
            
        }
        
        
       

       

        //view.addConstraints([newButtonConstraintX,newButtonConstraintY,newButtonConstraintH,newButtonConstraintL])
        
        cell.post = post
        cell.captionLabel.text = caption
        cell.usernameButton.setTitle(username, forState: .Normal)
        cell.timestampLabel.text = timeElapsedString
        pictureFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    cell.picturePostView.image = image
                }
            }
        
        }
        if let profilePictureFile = user["profileImage"]
        {
            profilePictureFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        cell.profileImageView.image = image
                    }
                }
                
            }

            
            
            
        } else {
            cell.profileImageView.image = nil
            
        }
        
        
        //cell.profileImageView.image = image
        
        
        
        
        
        //var temp = cell.captionLabel
       // var constraints = [] as! [NSLayoutConstraint]
       /*
        var container: UIView?
        
        if let container1 = container {
            container1.removeFromSuperview()
        }
    
        
        container = UIView()
        container!.backgroundColor = UIColor.blackColor()
        container!.translatesAutoresizingMaskIntoConstraints = false
        //cell.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(container!)
        let viewW = NSLayoutConstraint(item: container!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 200)
        
        let viewH = NSLayoutConstraint(item: container!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 21)
        
        let viewTrailing = NSLayoutConstraint(item: container!, attribute: .Trailing, relatedBy: .Equal, toItem: container!.superview, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
        let viewLeading = NSLayoutConstraint(item: container!, attribute: .Leading, relatedBy: .Equal, toItem: container!.superview, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        let viewTop = NSLayoutConstraint(item: container!, attribute: .Top, relatedBy: .Equal, toItem: cell.captionLabel, attribute: .Bottom, multiplier: 1.0, constant: 1.0)
        let viewBottom = NSLayoutConstraint(item: container!, attribute: .Bottom, relatedBy: .Equal, toItem: container!.superview, attribute: .Bottom, multiplier: 1.0, constant: 1.0)
        NSLayoutConstraint.activateConstraints([viewH,viewLeading, viewTrailing, viewTop])

    
    */
        
    
    
    
     /*   let container = UIView()
        container.backgroundColor = UIColor.blackColor()
        container.translatesAutoresizingMaskIntoConstraints = false
        //cell.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(container)
        let viewW = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 200)
        
        let viewH = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 21)
        
        let viewTrailing = NSLayoutConstraint(item: container, attribute: .Trailing, relatedBy: .Equal, toItem: container.superview, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
        let viewLeading = NSLayoutConstraint(item: container, attribute: .Leading, relatedBy: .Equal, toItem: container.superview, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        let viewTop = NSLayoutConstraint(item: container, attribute: .Top, relatedBy: .Equal, toItem: cell.captionLabel, attribute: .Bottom, multiplier: 1.0, constant: 1.0)
        let viewBottom = NSLayoutConstraint(item: container, attribute: .Bottom, relatedBy: .Equal, toItem: container.superview, attribute: .Bottom, multiplier: 1.0, constant: 1.0)
        NSLayoutConstraint.activateConstraints([viewH,viewLeading, viewTrailing, viewTop])
        

        */
        
        // 
        /*
        if let comments = post["comment"] as? [String] {
            
            
            
           /* for comment in comments {
                let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = comment
                cell.container.addSubview(label)
                
                let con = NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: temp, attribute: .Leading, multiplier: 1.0, constant: 0.0)
                
                let con1 = NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: temp, attribute: .Bottom, multiplier: 1.0, constant: 10.0)
                
                let con2 = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 200)
                
                let con3 = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 21)

                constraints.append(con)
                constraints.append(con1)
                constraints.append(con2)
                constraints.append(con3)
                
                //NSLayoutConstraint.activateConstraints([con])
                //NSLayoutConstraint.activateConstraints([con, con1, con2, con3])
                //print("before: \(temp.text)")
                temp = label
                //print("after: \(temp.text)")
                
            }

        */
           
        } else {
            
            
        
        }
        
        let con2 = NSLayoutConstraint(item: temp, attribute: .Bottom, relatedBy: .Equal, toItem: temp.superview, attribute: .Bottom, multiplier: 1.0, constant: -10.0)
        
        NSLayoutConstraint.activateConstraints(constraints)
        NSLayoutConstraint.activateConstraints([con2])

        
        //
        
        */
        
        
        
        
       //
/*
        var label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "I'm a test label"
        cell.container.addSubview(label)
        
       
        let con = NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: cell.captionLabel, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        
        let con1 = NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: cell.captionLabel, attribute: .Bottom, multiplier: 1.0, constant: 10.0)
        
        var label1 = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.text = "I'm a test label"
        cell.container.addSubview(label1)
        
        
        let con0 = NSLayoutConstraint(item: label1, attribute: .Leading, relatedBy: .Equal, toItem: label, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        
        let con10 = NSLayoutConstraint(item: label1, attribute: .Top, relatedBy: .Equal, toItem: label, attribute: .Bottom, multiplier: 1.0, constant: 10.0)
        
        let con2 = NSLayoutConstraint(item: label1, attribute: .Bottom, relatedBy: .Equal, toItem: label1.superview, attribute: .Bottom, multiplier: 1.0, constant: -10.0)
        
        
        NSLayoutConstraint.activateConstraints([con, con1, con0, con10])
        NSLayoutConstraint.activateConstraints([con2])
       //
        */
        
        
        return cell
    }
    
    
    
    
    func timeElapsed(date: NSDate) -> String {
      
        let timeElapsed = Int(0 - date.timeIntervalSinceNow)
        print(timeElapsed)
        
        let secondsInMinute = 60
        let secondsInHour = secondsInMinute * 60
        let secondsInDay = secondsInHour * 24
        let secondsInMonth = secondsInDay * 30
        let monthsElapsed = timeElapsed/secondsInMonth
        let daysElapsed = timeElapsed/secondsInDay
        let hoursElapsed = timeElapsed/secondsInHour
        let minutesElapsed = timeElapsed/secondsInMinute
        let secondsElapsed = timeElapsed
        var timeElapsedString: String?
        
        if monthsElapsed != 0 {
            timeElapsedString = "\(monthsElapsed)mon"
            
        } else if daysElapsed != 0 {
            timeElapsedString = "\(daysElapsed)d"
            
            
        } else if hoursElapsed != 0 {
            timeElapsedString = "\(hoursElapsed)h"
            
            
        } else if minutesElapsed != 0 {
            timeElapsedString = "\(minutesElapsed)m"
            
        } else {
            timeElapsedString = "\(secondsElapsed)s"
            
            
        }

        
        
        
        
        
        return timeElapsedString!
        
    }

    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "commentSegue" {
            
            let commentVC = segue.destinationViewController as! CommentsViewController
            let cell = sender!.superview!!.superview! as! PostCell
            
            let media = cell.post
            //print(media)
            commentVC.media = media!
            
        } else {
            let profileVC = segue.destinationViewController as! ProfileViewController
            let cell = sender!.superview!!.superview! as! PostCell
            
            let user = cell.post!["author"] as! PFUser
            //print(media)
            profileVC.user = user
            
            
            
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
