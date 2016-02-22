//
//  ProfileViewController.swift
//  Insta
//
//  Created by Shakeeb Majid on 2/20/16.
//  Copyright © 2016 Shakeeb Majid. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var images: [UIImage]?
    
    var user: PFUser?
    let vc = UIImagePickerController()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hey bitch you miss me")
        vc.delegate = self
        vc.allowsEditing = true
        collectionView.dataSource = self
        
        var tapRecognizer = UITapGestureRecognizer(target: self, action: "tappedImage:")
        
        tapRecognizer.delegate = self
        
        
        self.profileImage.addGestureRecognizer(tapRecognizer)
        
        self.profileImage.userInteractionEnabled = true
        
        if let user = user {
            self.postsLabel.text = "\(user["postsCount"])"
            
            if let profilePictureFile = user["profileImage"]
            {
                profilePictureFile.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            self.profileImage.image = image
                        }
                    }
                    
                }
                
                
                
                
            } else {
                self.profileImage.image = nil
                
            }
            
            
            usernameLabel.text = user.username
            
            let query = PFQuery(className:"UserMedia")
            query.whereKey("author", equalTo:user)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                var images = [] as [UIImage]
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) pictures.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            let imageFile = object["media"] as! PFFile
                            print(imageFile)
                            imageFile.getDataInBackgroundWithBlock {
                                (imageData: NSData?, error: NSError?) -> Void in
                                if error == nil {
                                    if let imageData = imageData {
                                        let image = UIImage(data:imageData)
                                        images.append(image!)
                                       
                                    }
                                     self.images = images
                                    self.collectionView.reloadData()
                                  
                                }
                                
                            }

                            
                            
                            
                            
                            print(object.objectId)
                        }
                            
                        
                    }
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
            
            
            
            
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.translucent = true
            
            self.navigationController?.navigationBar.topItem!.title = ""
            
        } else {
            self.user = PFUser.currentUser()
            self.postsLabel.text = "\(self.user!["postsCount"])"
            
            if let profilePictureFile = self.user!["profileImage"]
            {
                profilePictureFile.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            self.profileImage.image = image
                        }
                    }
                    
                }
                
                
                
                
            } else {
                self.profileImage.image = nil
                
                
            }

            usernameLabel.text = user?.username
            
            let query = PFQuery(className:"UserMedia")
            query.whereKey("author", equalTo:self.user!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                var images = [] as [UIImage]
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) pictures.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            let imageFile = object["media"] as! PFFile
                            
                            print(imageFile)
                            imageFile.getDataInBackgroundWithBlock {
                                (imageData: NSData?, error: NSError?) -> Void in
                                if error == nil {
                                    if let imageData = imageData {
                                        let image = UIImage(data:imageData)
                                        images.append(image!)
                                        print("hello \(image) \(images.count)")
                                        
                                    }
                                    self.images = images
                                    self.collectionView.reloadData()
                                    //self.testImageView.image = images[1]
                                   
                                }
                               
                                
                            }
                            
                            print(object.objectId)
                        }
                        
                        //
                    }
                    
                } else {
                    // Log details of the failure
                    
                }
                
                
            }
            
            
            
            
            
            
            
            
        }
        //testImageView.image = self.images![0]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedImage(sender: AnyObject) {
        
        print("this was tapped")
        
        //vc.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            //print(info)
            vc.dismissViewControllerAnimated(true) { () -> Void in
                UserMedia.changeProfileImage(editedImage, withCompletion: { (success: Bool, error: NSError?) -> Void in
                    print(success)
                    
                })

                
                
                self.profileImage.image = editedImage
            }
            
            
            
            //self.testImageView.image = editedImage
            
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let images = images {
            
            return images.count
            
        } else {
            
            return 0
        }
        
        
        
        
    }
    

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PictureCell", forIndexPath: indexPath) as! PersonalPictureCell
       
        cell.personalPicture.image = images![indexPath.row]
        
        return cell
        
    }
    
    
    @IBAction func onFollow(sender: AnyObject) {
        let currentUser = PFUser.currentUser()
        var followingArray = currentUser!["following"] as! [PFUser]
        currentUser!["following"] = followingArray.append(self.user!) as! [PFUser]
        
        
        currentUser?.saveInBackground()
        
        
        var followerArray = self.user!["followers"] as! [PFUser]
        
        self.user!["followers"] = followerArray.append(currentUser!) as! [PFUser]
        
        
        
        self.user!.saveInBackground()
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
