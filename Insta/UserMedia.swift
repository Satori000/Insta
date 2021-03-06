//
//  UserMedia.swift
//  Insta
//
//  Created by Shakeeb Majid on 2/17/16.
//  Copyright © 2016 Shakeeb Majid. All rights reserved.
//

import UIKit
import Parse

class UserMedia: NSObject {
    /**
     Method to post user media to Parse by uploading image file
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    
    
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let media = PFObject(className: "UserMedia")
        
        let date = NSDate()
        
        
        // Add relevant fields to the object
        media["media"] = getPFFileFromImage(image) // PFFile column type
        media["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        media["caption"] = caption
        media["likesCount"] = 0
        media["commentsCount"] = 0
        media["time"] = date
        print(date)
        // Save object (following function will save the object in Parse asynchronously)
        
        let str = "Working at Parse is great!"
        let data = str.dataUsingEncoding(NSUTF8StringEncoding)
        let file = PFFile(name:"resume.txt", data:data!)
        
        let user = PFUser.currentUser()
        user!["postsCount"] = user!["postsCount"] as! Int + 1
        user?.saveInBackground()
        media.saveInBackgroundWithBlock(completion)
    }
    
    class func changeProfileImage(image: UIImage?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let user = PFUser.currentUser()!
        
        user["profileImage"] = getPFFileFromImage(image)
        
        
        // Add relevant fields to the object
       // media["media"] = getPFFileFromImage(image) // PFFile column type
               // Save object (following function will save the object in Parse asynchronously)
        
        
        user.saveInBackgroundWithBlock(completion)
    }
    
    class func getPictureFromFile(file: PFFile?) -> UIImage {
        var image: UIImage?
        file!.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    image = UIImage(data:imageData)
                }
            }
            
        }

        
        
        return image!
    }
    
    class func likePicture(picture: PFObject?) {
        if let likeCount = picture!["likesCount"] as? Int{
            let newLikeCount = likeCount + 1
            
            picture!["likesCount"] = newLikeCount
            picture!.saveInBackground()
            
        } else {
            
            picture!["likesCount"] = 1
            picture!.saveInBackground()
        }
        
        
        
    }
    
    class func unLikePicture(picture: PFObject?) {
        if let likeCount = picture!["likesCount"] as? Int{
            let newLikeCount = likeCount - 1
            
            picture!["likesCount"] = newLikeCount
            picture!.saveInBackground()
            
        }
    }
    
    /**
     Method to post user media to Parse by uploading image file
     
     - parameter image: Image that the user wants upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }

}
