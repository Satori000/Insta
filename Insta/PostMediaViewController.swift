//
//  PostMediaViewController.swift
//  Insta
//
//  Created by Shakeeb Majid on 2/17/16.
//  Copyright © 2016 Shakeeb Majid. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class PostMediaViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var testImageView: UIImageView!
    
    @IBOutlet weak var captionField: UITextField!
    
    let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = "I'am a test label"
        self.view.addSubview(label)
        vc.delegate = self
        vc.allowsEditing = true
        self.tabBarItem.title = "Post"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTakePicture(sender: AnyObject) {
        
        vc.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            //print(info)
            vc.dismissViewControllerAnimated(true) { () -> Void in
                self.testImageView.image = editedImage
            }
            
            //self.testImageView.image = editedImage
            
    }
    
        
    @IBAction func onGetDict(sender: AnyObject) {
        var query = PFQuery(className: "UserMedia")
        query.getObjectInBackgroundWithId("1dHB3wo04u") {
            (userMedia: PFObject?, error: NSError?) -> Void in
            if error == nil && userMedia != nil {
               // print(userMedia)
                let pictureFile = userMedia!["media"] as! PFFile
                
                pictureFile.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            self.testImageView.image = image
                            
                            
                        }
                    }
                    
                }
                

                //UserMedia.getPFFileFromImage(imageFromPicture)
                print(pictureFile)
            } else {
                print(error)
            }
        }
    }
    
    
    
    @IBAction func onLibrary(sender: AnyObject) {

        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func onPost(sender: AnyObject) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.view.endEditing(true)
         let editedImage = testImageView.image
        let caption = captionField.text
        UserMedia.postUserImage(editedImage, withCaption: caption, withCompletion: { (success: Bool, error: NSError?) -> Void in
            print(success)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
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
