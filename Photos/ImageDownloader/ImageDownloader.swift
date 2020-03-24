//
//  ImageDownloader.swift
//  Photos
//
//  Created by Kapil on 25/03/20.
//  Copyright © 2020 kapil. All rights reserved.
//

import Foundation
import UIKit

enum PhotoRecordState {
    case new, downloaded, failed
}

class PendingOperations {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image download queue"
        return queue
    }()
}

class ImageDownloader: Operation {
    var photoRecord: Item
    
    init(_ photoRecord: Item) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        guard let url = photoRecord.getImageURL(),
                let imageData = try? Data(contentsOf: url as URL) else {
                loadingFailed()
                return
        }
        
        if isCancelled {
            return
        }
        
        if !imageData.isEmpty {
            photoRecord.image = UIImage(data:imageData)
            photoRecord.state = .downloaded
        } else {
            loadingFailed()
        }
    }
    
    private func loadingFailed() {
        photoRecord.state = .failed
        photoRecord.image = UIImage(named: "failed")
    }
}
