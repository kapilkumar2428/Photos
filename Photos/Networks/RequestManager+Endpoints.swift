//
//  RequestManager+Endpoints.swift
//  Photos
//
//  Created by Kapil on 25/03/20.
//  Copyright © 2020 kapil. All rights reserved.
//

import Foundation

typealias HTTPHeader = [String: String]

enum Endpoints {
    private static let baseUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key="
    private static let apiKey = "062a6c0c49e4de1d78497d13a7dbb360"
    private static let path = "&per_page=20&format=json&nojsoncallback=1"
    
    case getImages
    
    func getImagesWithQuery(query: String, pageCount: Int) -> URLRequest {
        switch self {
        case .getImages:
            let queryWithSpace = query.replacingOccurrences(of: " ", with: "%20")
            let urlString = Endpoints.baseUrl  + Endpoints.apiKey + "&text=\(queryWithSpace)" + Endpoints.path
            let url = URL(string: urlString)?.appending("page", value: pageCount.description)
            return URLRequest(url: url!)
        }
    }
}
