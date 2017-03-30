//
//  FilterCell.swift
//  PicFeed
//
//  Created by Eve Denison on 3/30/17.
//  Copyright © 2017 Eve Denison. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }
    
}
