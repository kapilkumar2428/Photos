//
//  ImageModel.swift
//  Photos
//
//  Created by Kapil on 25/03/20.
//  Copyright © 2020 kapil. All rights reserved.
//

import Foundation
import UIKit

struct ImagesModel: Codable {
    let photos: Photos?
    let stat: String?
}

struct Photos: Codable {
    let page, pages, perpage: Int?
    let total: String?
    let photo: [Item]?
}

class Item: Codable {
    let id, owner, secret, server: String?
    let farm: Int?
    let title: String?
    let ispublic, isfriend, isfamily: Int?
    var state = PhotoRecordState.new
    var image = UIImage(named: "Placeholder")
    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server
        case farm
        case title
        case ispublic, isfriend, isfamily
    }
    
    func getImageURL(_ size: String = "m") -> URL? {
        if let url =  URL(string: "https://farm\(farm ?? 0).staticflickr.com/\(server ?? "")/\(id ?? "")_\(secret ?? "")_\(size).jpg") {
        return url
      }
      return nil
    }
}
