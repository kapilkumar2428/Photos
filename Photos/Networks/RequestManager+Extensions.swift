//
//  RequestManager+Extensions.swift
//  Photos
//
//  Created by Krithika Iyer 2 on 25/03/20.
//  Copyright © 2020 kapil. All rights reserved.
//

import Foundation

extension RequestManager {
    
    func getImagesWith(query: String, completion: CompletionHandler<ResponseType>? = nil) {
        self.getData(Endpoints.getImages.getImagesWithQuery(query: query), completion: completion)
    }
}
