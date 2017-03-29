//
//  GalleryCollectionViewLayout.swift
//  PicFeed
//
//  Created by Eve Denison on 3/29/17.
//  Copyright © 2017 Eve Denison. All rights reserved.
//

import UIKit

class GalleryCollectionViewLayout: UICollectionViewFlowLayout {
    
    var columns = 2
    let spacingBetweenItems: CGFloat = 1.0
    
    var screenWidth : CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var itemWidth : CGFloat {
        let availableScreen = screenWidth - (CGFloat(self.columns) * self.spacingBetweenItems)
        
        return availableScreen / CGFloat(self.columns)
    }
    init(columns : Int = 2) {
        self.columns = columns
        
        super.init()
        
        self.minimumLineSpacing = spacingBetweenItems
        self.minimumInteritemSpacing = spacingBetweenItems
        self.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
