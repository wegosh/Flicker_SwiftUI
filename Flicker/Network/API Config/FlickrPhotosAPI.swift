//
//  FlickrPhotosAPI.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

enum FlickrPhotosAPI: NetworkAPIFactory {
    var method: HTTPMethod {
        switch self {
        case .getRecent, .getSizes:
            return .get
        }
    }
    
    var path: String {
        return "services/rest"
    }
    
    var parameters: [String : String] {
        switch self {
        case .getRecent(page: let page):
            var params = [
                "method": "flickr.photos.getRecent",
            ]
            if let page {
                params["page"] = String(page)
            }
            return params
        case .getSizes(photoID: let photoID):
            let params = [
                "photo_id": photoID
            ]
            return params
        }
    }
    
    case getRecent(page: Int?)
    case getSizes(photoID: String)
}
