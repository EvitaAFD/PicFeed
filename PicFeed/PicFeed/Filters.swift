//
//  Filters.swift
//  PicFeed
//
//  Created by Eve Denison on 3/28/17.
//  Copyright © 2017 Eve Denison. All rights reserved.
//

import UIKit

enum FilterName : String {
    case vintage = "CIPhotoEffectTransfer"
    case blackAndWhite = "CIPhotoEffectMono"

}

typealias FilterCompletion = (UIImage?) -> ()

class Filters {
    
//store original before reassigning
        static var originalImage = UIImage()

}
