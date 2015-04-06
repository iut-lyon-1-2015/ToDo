//
//  TaskDetailViewController.swift
//  ToDo
//
//  Created by William Antwi on 29/03/2015.
//  Copyright (c) 2015 William Antwi. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var task: Task!
    
    private var photoData: NSData!
    private var hasChanged: Bool!

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = task.name
        
        let saveButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save,
            target: self,
            action: Selector("save"))
        
        self.navigationItem.rightBarButtonItem = saveButtonItem
        
        
        if let photoData = task.photo as NSData? {
            
            imageView.image = UIImage(data: photoData)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("addPhoto"))
        
        self.view.addGestureRecognizer(tapGesture)
        
        hasChanged = false
    }
    
    
    //MARK: Actions
    func save () {
        
        if (hasChanged == true) {
            
            task.photo = photoData
            
            task.managedObjectContext?.save(nil)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func addPhoto() {
        
        let actionSheet = UIAlertController(
            title: "Photo",
            message: "Add photo",
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        let albumAction = UIAlertAction(
            title: "Album",
            style: UIAlertActionStyle.Default) { (action : UIAlertAction!) -> Void in
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(
            title: "Camera",
            style: UIAlertActionStyle.Default) { (action : UIAlertAction!) -> Void in
                
                
                if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                    imagePicker.allowsEditing = false
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
                
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.Cancel) { (action : UIAlertAction!) -> Void in
        }
        
        actionSheet.addAction(albumAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        
        presentViewController(actionSheet,
            animated: true,
            completion: nil)
    }
    
    @IBAction func selectCategory() {
        
        
    }
    
    //MARK: UIImagePickerControllerDelegate & UINavigationControllerDelegate
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage
        image: UIImage!,
        editingInfo: [NSObject : AnyObject]!) {
        
        self.imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
        photoData = UIImageJPEGRepresentation(image, 100)
        
        hasChanged = true
    }
    
}
