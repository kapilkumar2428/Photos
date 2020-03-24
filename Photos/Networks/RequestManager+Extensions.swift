//
//  RequestManager+Extensions.swift
//  Photos
//
//  Created by Kapil on 25/03/20.
//  Copyright © 2020 kapil. All rights reserved.
//

import Foundation

extension RequestManager {
    
    func getImagesWith(query: String,pageCount: Int, completion: CompletionHandler<ResponseType>? = nil) {
        self.getData(Endpoints.getImages.getImagesWithQuery(query: query, pageCount: pageCount), completion: completion)
    }
}
