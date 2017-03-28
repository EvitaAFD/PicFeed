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
    @IBOutlet weak var filterButtonTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        }
    override func viewDidAppear(_ animated: Bool) {
            filterButtonTopConstraint.constant = 8
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
        }
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
        
        guard let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        guard let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        
        self.imageView.image = editedImage
        
        UIImageWriteToSavedPhotosAlbum(editedImage, self, nil, nil)
        UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, nil)

        Filters.originalImage = originalImage
        
        imagePickerControllerDidCancel(picker)
    }

    @IBAction func imageTapped(_ sender: Any) {
        print("User Tapped Image!")
        
        self.presentActionSheet()
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        if let image = self.imageView.image {
            
            let newPost = Post(image: image)
            CloudKit.shared.save(post: newPost, completion: { (success) in
                
                if success {
                    print("Saved post sucessfully to CloudKit!")
                } else {
                    print("Failed to save post to CloudKit")
                }
                
            })
            
        }
        
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        guard let image = self.imageView.image else { return }
        
        let alertController = UIAlertController(title: "Filter", message: "Please select a filter!", preferredStyle: .alert)
        
        let blackAndWhiteAction = UIAlertAction(title: "Black & White", style: .default) { (action) in
                Filters.filter(name: .blackAndWhite, image: image, completion: { (filteredImage) in
                        self.imageView.image = filteredImage
                })
        }
        
        let vintageAction = UIAlertAction(title: "Vintage", style: .default) { (action) in
                Filters.filter(name: .vintage, image: image, completion: { (filteredImage) in
                        self.imageView.image = filteredImage
                })
            
        }
        
        let resetAction = UIAlertAction(title: "Reset Image", style: .destructive) { (action) in
                self.imageView.image = Filters.originalImage
        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(blackAndWhiteAction)
        alertController.addAction(vintageAction)
        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
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
