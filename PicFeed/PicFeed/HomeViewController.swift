//
//  HomeViewController.swift
//  PicFeed
//
//  Created by Eve Denison on 3/27/17.
//  Copyright © 2017 Eve Denison. All rights reserved.
//

import UIKit
import Social

let buttonAnimationDuration = 0.5

class HomeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    let filterNames = [FilterName.blackAndWhite, FilterName.comic, FilterName.cool, FilterName.invert, FilterName.vintage, FilterName.warm]
    let filterStrings = ["Black&White", "Comic", "Cool", "Invert", "Vintage", "Warm"]
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var filterButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var postButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    
    let collectionViewConstant = 150

    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.imageView.image = #imageLiteral(resourceName: "P1020947")
         self.collectionView.dataSource = self
         setupGalleryDelegate()

        }
    
    func setupGalleryDelegate() {
        if let tabBarController = self.tabBarController {
            guard let viewControllers = tabBarController.viewControllers else { return }
            
            guard let galleryController = viewControllers[1] as? GalleryViewController else { return }
            
            galleryController.delegate = self
        }
    }

   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            filterButtonBottomConstraint.constant = 8
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
        self.collectionView.reloadData()
        
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
        
        self.collectionViewHeightConstraint.constant = CGFloat(collectionViewConstant)
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func userLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)) {
            guard let composeController = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else { return }
            composeController.add(self.imageView.image)
            
            self.present(composeController, animated: true, completion: nil)
        }
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

//MARK: UICollectionViewDataSource
extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as! FilterCell
        
        guard let originalImage = Filters.originalImage else { return filterCell }
        
        
        guard let resizedImage = originalImage.resize(size: CGSize(width: 150, height: 150)) else { return filterCell}
        
        let filterName = self.filterNames[indexPath.row]
        let filterString = self.filterStrings[indexPath.row]
        filterCell.filterNameLabel.text = filterString
        
        Filters.filter(name: filterName, image: resizedImage) { (filteredImage) in
            filterCell.imageView.image = filteredImage
        }
        
        return filterCell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNames.count
    }
}
extension HomeViewController: GalleryViewControllerDelegate {
    
    func galleryController(didSelect image: UIImage) {
        self.imageView.image = image
        
        self.tabBarController?.selectedIndex = 0
    }
}


