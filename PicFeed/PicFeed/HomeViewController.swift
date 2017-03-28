//
//  HomeViewController.swift
//  PicFeed
//
//  Created by Eve Denison on 3/27/17.
//  Copyright © 2017 Eve Denison. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = #imageLiteral(resourceName: "P1020947")

    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = sourceType
        self.present(self.imagePicker, animated: true, completion: nil)
        self.imagePicker.allowsEditing = true
    
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imageView.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        print("Info: \(info)")
        if let captureImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
        }
        
        imagePickerControllerDidCancel(picker)
    }

    @IBAction func imageTapped(_ sender: Any) {
        print("User Tapped Image!")
        
        self.presentActionSheet()
    }
    
    func cameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func presentActionSheet(){
        let actionSheetController = UIAlertController(title: "Source", message: "Please select source type", preferredStyle: .actionSheet)
        
        if cameraAvailable() == true {
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .camera)
        }
            actionSheetController.addAction(cameraAction)
        }
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        actionSheetController.addAction(photoAction)
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }

}
