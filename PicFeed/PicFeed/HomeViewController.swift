//
//  HomeViewController.swift
//  PicFeed
//
//  Created by Eve Denison on 3/27/17.
//  Copyright © 2017 Eve Denison. All rights reserved.
//

import UIKit

let buttonAnimationDuration = 0.5

class HomeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var postButtonBottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.imageView.image = #imageLiteral(resourceName: "P1020947")
        }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            filterButtonTopConstraint.constant = 8
            postButtonBottomConstraint.constant = 8
        
            UIView.animate(withDuration: buttonAnimationDuration) {
                self.view.layoutIfNeeded()
        }
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
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            
        }
        
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        guard let image = self.imageView.image else { return }
        
        let alertController = UIAlertController(title: "Filter", message: "Please select a filter!", preferredStyle: .alert)
        
        let blackAndWhiteAction = UIAlertAction(title: "Black & White", style: .default) { (action) in
                Filters.filter(name: .blackAndWhite, image: image, completion: { (filteredImage) in
                    guard let unwrapFilters = filteredImage else { return }
                        Filters.selectedFilters.append(unwrapFilters)
                        self.imageView.image = filteredImage
                })
        }
        
        let vintageAction = UIAlertAction(title: "Vintage", style: .default) { (action) in
                Filters.filter(name: .vintage, image: image, completion: { (filteredImage) in
                    guard let unwrapFilters = filteredImage else { return }
                        Filters.selectedFilters.append(unwrapFilters)
                        self.imageView.image = filteredImage
                })
            
        }
        
        let invertAction = UIAlertAction(title: "Invert", style: .default) { (action) in
            Filters.filter(name: .invert, image: image, completion: { (filteredImage) in
                guard let unwrapFilters = filteredImage else { return }
                Filters.selectedFilters.append(unwrapFilters)
                self.imageView.image = filteredImage
            })
            
        }
        
        let warmAction = UIAlertAction(title: "Warm", style: .default) { (action) in
            Filters.filter(name: .warm, image: image, completion: { (filteredImage) in
                guard let unwrapFilters = filteredImage else { return }
                Filters.selectedFilters.append(unwrapFilters)
                self.imageView.image = filteredImage
            })
            
        }
        
        let coolAction = UIAlertAction(title: "Cool", style: .default) { (action) in
            Filters.filter(name: .cool, image: image, completion: { (filteredImage) in
                guard let unwrapFilters = filteredImage else { return }
                Filters.selectedFilters.append(unwrapFilters)
                self.imageView.image = filteredImage
            })
        }
            
        let comicAction = UIAlertAction(title: "Comic", style: .default) { (action) in
            Filters.filter(name: .comic, image: image, completion: { (filteredImage) in
                guard let unwrapFilters = filteredImage else { return }
                Filters.selectedFilters.append(unwrapFilters)
                self.imageView.image = filteredImage
            })
            
        }
    
        let resetAction = UIAlertAction(title: "Reset Image", style: .destructive) { (action) in
                self.imageView.image = Filters.originalImage
        
        }
        
        let undoAction = UIAlertAction(title: "Undo Filter", style: .destructive) { (action) in
            if Filters.selectedFilters.count > 0 {
                if self.imageView.image == Filters.selectedFilters.last {
                    Filters.selectedFilters.removeLast()
                }
                self.imageView.image = Filters.selectedFilters.popLast()
                } else {
                self.imageView.image = Filters.originalImage
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(blackAndWhiteAction)
        alertController.addAction(vintageAction)
        alertController.addAction(invertAction)
        alertController.addAction(warmAction)
        alertController.addAction(coolAction)
        alertController.addAction(comicAction)
        alertController.addAction(resetAction)
        alertController.addAction(undoAction)
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
