//
//  ProfileViewController.swift
//  Insta
//
//  Created by Shakeeb Majid on 2/20/16.
//  Copyright © 2016 Shakeeb Majid. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var user: PFUser?
    let vc = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()

        vc.delegate = self
        vc.allowsEditing = true
        
        
        var tapRecognizer = UITapGestureRecognizer(target: self, action: "tappedImage:")
        
        tapRecognizer.delegate = self
        
        self.profileImage.addGestureRecognizer(tapRecognizer)
        
        self.profileImage.userInteractionEnabled = true
        
        if let user = user {
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
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.translucent = true
            
            self.navigationController?.navigationBar.topItem!.title = ""
            
        } else {
            self.user = PFUser.currentUser()
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
            
        }
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedImage(sender: AnyObject) {
        
        print("this was tapped")
        
        vc.sourceType = UIImagePickerControllerSourceType.Camera
        
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

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
