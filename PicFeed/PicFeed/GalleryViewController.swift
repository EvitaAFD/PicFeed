//
//  GalleryViewController.swift
//  PicFeed
//
//  Created by Eve Denison on 3/29/17.
//  Copyright © 2017 Eve Denison. All rights reserved.
//

import UIKit


//Protocol that is the delegate

protocol GalleryViewControllerDelegate : class {
    func galleryController(didSelect image: UIImage)
}

class GalleryViewController: UIViewController {
    
    weak var delegate : GalleryViewControllerDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var allPosts = [Post]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = GalleryCollectionViewLayout(columns: 1)
    
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        update()
    }
    
    func update() {
        CloudKit.shared.getPosts { (posts) in
            if let posts = posts {
                self.allPosts = posts
            }
        }
    }
    
    
    @IBAction func userPinched(_ sender: UIPinchGestureRecognizer) {
        
        guard let layout = collectionView.collectionViewLayout as? GalleryCollectionViewLayout else { return }
        
        switch sender.state {
        case .began:
            print("Pinch Gesture by User!")
        case .changed:
            print("<-----User Pinch Changed----->")
        case .ended:
            print("Pinch Ended")
            
            let columns = sender.velocity > 0 ? layout.columns - 1 : layout.columns + 1
            
            if columns < 1 || columns > 10 { return }
            
            collectionView.setCollectionViewLayout(GalleryCollectionViewLayout(columns: columns), animated: true)
            
        default:
            print("Unknown Sender State")
        }
    }

}

//MARK: UICollectionViewDataSource and UICollectionViewDelegate Extension
extension GalleryViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.identifier, for: indexPath) as! GalleryCell
        
            cell.post = self.allPosts[indexPath.row]

        
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return allPosts.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = self.delegate else { return }
        
        let selectedPost = self.allPosts[indexPath.row]
        
        delegate.galleryController(didSelect: selectedPost.image)
    }
}


