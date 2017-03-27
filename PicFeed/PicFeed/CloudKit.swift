//
//  CloudKit.swift
//  PicFeed
//
//  Created by Eve Denison on 3/27/17.
//  Copyright © 2017 Eve Denison. All rights reserved.
//

import Foundation
import CloudKit

class CloudKit {

    static let shared = CloudKit()
    
    let container = CKContainer.default()
    
    var privateDatabase : CKDatabase {
        return container.privateCloudDatabase
    }
    
}
