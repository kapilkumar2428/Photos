//
//  RequestManager.swift
//  Photos
//
//  Created by Kapil on 25/03/20.
//  Copyright © 2020 kapil. All rights reserved.
//

import Foundation

typealias CompletionHandler<T> = (_ response: APIResponse<T>) -> Void

enum APIResponse<Result> {
    case success(Result?)
    case failed(String, Int?)
}

class RequestManager<ResponseType: Codable> {
    
    let urlSession = URLSession.shared
    
    func getData(_ request: URLRequest, completion: CompletionHandler<ResponseType>? = nil) -> Void {
        let task = self.urlSession.dataTask(with: request) { (data, response, error) in
            let defaultError = "Something went wrong, please try again later."
            
            guard let data = data else {
                completion?(APIResponse.failed(error?.localizedDescription ?? defaultError, 500))
                return
            }
            
            do {
                print(try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) )
                let parsedData = try JSONDecoder().decode(ResponseType.self, from: data)
                completion?(APIResponse<ResponseType>.success(parsedData))
            } catch {
                print(error.localizedDescription, "StatusCode: \(response!)")
                completion?(APIResponse<ResponseType>.failed("Issue with JSON parsing", 500))
            }
        }
        task.resume()
    }
}
