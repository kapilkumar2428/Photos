//
//  RequestManager+Endpoints.swift
//  Photos
//
//  Created by Krithika Iyer 2 on 25/03/20.
//  Copyright © 2020 kapil. All rights reserved.
//

import Foundation

typealias HTTPHeader = [String: String]

enum Endpoints {
    private static let baseUrl = "https://www.googleapis.com/customsearch/v1?q="
    private static let apiKey = "AIzaSyAjTPFgulkdrELcWmo1jAa8wqtHLrztyKc"
    private static let path = "&cx=011476162607576381860:ra4vmliv9ti&key="
    
    case getImages
    
    func getImagesWithQuery(query: String) -> URLRequest {
        switch self {
        case .getImages:
            let queryWithSpace = query.replacingOccurrences(of: " ", with: "%20")
            let urlString = Endpoints.baseUrl + "\(queryWithSpace)" + Endpoints.path + Endpoints.apiKey
            let url = URL(string: urlString)
            return URLRequest(url: url!)
        }
    }
}
