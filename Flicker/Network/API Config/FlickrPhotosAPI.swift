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
        case .getRecent, .getInfo, .search:
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
            params["per_page"] = String(20)
            params["extras"] = ["tags", "owner_name", "icon_server"].joined(separator: ", ")
            if let page {
                params["page"] = String(page)
            }
            return params
        case .getInfo(photoID: let id, secret: let secret):
            var params = [
                "method": "flickr.photos.getInfo",
                "photo_id": id
            ]
            if let secret {
                params["secret"] = secret
            }
            return params
        case .search(searchTerm: let term, tagMode: let mode, page: let page):
            var params = [
                "method": "flickr.photos.search",
                "tags": term,
                "tag_mode": mode.rawValue
            ]
            params["per_page"] = String(20)
            params["extras"] = ["tags", "owner_name", "icon_server"].joined(separator: ", ")
            if let page {
                params["page"] = String(page)
            }
            return params
        }
    }
    
    case getRecent(page: Int?)
    case getInfo(photoID: String, secret: String?)
    case search(searchTerm: String, tagMode: TagSearchMode, page: Int?)
    
}

enum TagSearchMode: String {
    case anyMatching = "any"
    case allMatching = "all"
    
    var description: String {
        switch self {
        case .allMatching:
            return "All matching"
        case .anyMatching:
            return "Any matching"
        }
    }
}
