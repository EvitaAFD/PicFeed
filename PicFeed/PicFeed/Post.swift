//
//  Post.swift
//  PicFeed
//
//  Created by Eve Denison on 3/28/17.
//  Copyright © 2017 Eve Denison. All rights reserved.
//

import UIKit
import CloudKit

class Post {
    
    let image: UIImage
    
    
    init(image: UIImage) {
    
        self.image = image
    }
}
    
    enum PostError : Error {
        case writtingImageToData
        case writingDataToDisk
    
    }
    
extension Post {
    
    class func recordFor(post: Post) throws -> CKRecord? {
        guard let data = UIImageJPEGRepresentation(post.image, 0.7) else { throw PostError.writtingImageToData }
        do{
            try data.write(to: post.image.path)
            
            let asset = CKAsset(fileURL: post.image.path)
            
            let record = CKRecord(recordType: "Post")
            record.setValue(asset, forKey: "image")
            
            return record
            
            
        } catch{
        throw PostError.writingDataToDisk
        }
    }

}