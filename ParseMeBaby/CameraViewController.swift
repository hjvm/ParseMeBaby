//
//  CameraViewController.swift
//  ParseMeBaby
//
//  Created by Héctor J. Vázquez on 6/21/16.
//  Copyright © 2016 Héctor J. Vázquez. All rights reserved.
//

import UIKit
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var captionField: UITextView!
    var originalImage: UIImage?
    var editedImage: UIImage?
    var caption: String?
    @IBOutlet weak var previewPhoto: UIImageView!
    
    @IBAction func cameraRollUpload(sender: AnyObject) {
        //Instantiate UIImagePicker
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
        @IBAction func takePictureUpload(sender: AnyObject) {
        //Instantiate UIImagePickerController
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        
        
    
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        

        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
        
        // Do something with the images (based on your use case)
        UIView.animateWithDuration(1.0, animations: {
            self.previewPhoto.image = self.originalImage
            self.previewPhoto.alpha = 1
        })

    }
    
    @IBAction func submitPost(sender: AnyObject) {
        caption = captionField.text
        
        if let originalImage = originalImage {
            if caption == nil { caption = "" }
            PostModel.postUserImage(originalImage, withCaption: caption, withCompletion: nil)
            captionField.text = ""
            caption = ""
            // Do something with the images (based on your use case)
            UIView.animateWithDuration(1.0, animations: {
                self.previewPhoto.alpha = 0
            })


//        }else if var editedImage = editedImage {
//            if caption == nil { caption = "" }
//            PostModel.postUserImage(editedImage, withCaption: caption, withCompletion: nil)
//            captionField.text = ""
        }else{
            let alertController = UIAlertController(title: "Invalid post", message:
                "Please choose or take a picture before pressing the Submit button", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }

        

    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

}
